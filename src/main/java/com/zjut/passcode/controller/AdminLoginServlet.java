package com.zjut.passcode.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.zjut.passcode.bean.Admin;
import com.zjut.passcode.bean.AuditLog;
import com.zjut.passcode.dao.AdminDao;
import com.zjut.passcode.dao.AuditLogDao;
import com.zjut.passcode.util.CryptoUtil;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    private AdminDao adminDao = new AdminDao();
    private AuditLogDao auditLogDao = new AuditLogDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String loginName = request.getParameter("loginName");
        String password = request.getParameter("password");
        String ipAddress = getClientIpAddress(request);
        
        // 验证输入
        if (loginName == null || loginName.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "用户名和密码不能为空");
            request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
            return;
        }
        
        // 获取管理员信息
        Admin admin = adminDao.getAdminByLoginName(loginName);
        if (admin == null) {
            logFailedLogin(loginName, ipAddress, "用户不存在");
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
            return;
        }
        
        // 检查账户是否被锁定
        if (admin.getLockoutUntil() != null && 
            admin.getLockoutUntil().after(Timestamp.valueOf(LocalDateTime.now()))) {
            logFailedLogin(loginName, ipAddress, "账户被锁定");
            request.setAttribute("error", "账户已被锁定，请稍后再试");
            request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
            return;
        }
        
        // 验证密码
        String hashedPassword = CryptoUtil.sm3Hash(password);
        if (!hashedPassword.equals(admin.getPasswordHash())) {
            // 增加失败次数
            int failedAttempts = admin.getFailedLoginAttempts() + 1;
            adminDao.updateFailedLoginAttempts(admin.getId(), failedAttempts);
            
            // 如果失败5次，锁定账户30分钟
            if (failedAttempts >= 5) {
                Timestamp lockoutUntil = Timestamp.valueOf(LocalDateTime.now().plus(30, ChronoUnit.MINUTES));
                adminDao.setLockoutUntil(admin.getId(), lockoutUntil);
                logFailedLogin(loginName, ipAddress, "密码错误，账户被锁定");
                request.setAttribute("error", "密码错误次数过多，账户已被锁定30分钟");
            } else {
                logFailedLogin(loginName, ipAddress, "密码错误");
                request.setAttribute("error", "用户名或密码错误");
            }
            request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
            return;
        }
        
        // 检查密码是否过期（90天）
        if (admin.getPasswordLastChanged() != null) {
            long daysSinceChange = ChronoUnit.DAYS.between(
                admin.getPasswordLastChanged().toLocalDateTime(), 
                LocalDateTime.now()
            );
            if (daysSinceChange > 90) {
                request.setAttribute("warning", "密码已过期，请及时修改密码");
            }
        }
        
        // 登录成功，重置失败次数
        adminDao.resetFailedLoginAttempts(admin.getId());
        
        // 记录登录日志
        AuditLog log = new AuditLog(admin.getId(), admin.getFullName(), "登录", 
                                   "管理员登录成功", ipAddress);
        log.setHmacSignature(CryptoUtil.generateHmacSm3(log.toString()));
        auditLogDao.addAuditLog(log);
        
        // 设置session
        HttpSession session = request.getSession();
        session.setAttribute("admin", admin);
        session.setAttribute("adminId", admin.getId());
        session.setAttribute("adminName", admin.getFullName());
        session.setAttribute("adminRole", admin.getRole());
        session.setAttribute("adminDeptId", admin.getDeptId());
        session.setMaxInactiveInterval(30 * 60); // 30分钟超时
        
        // 根据角色跳转到不同页面
        if ("AUDIT_ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/audit_log_manage.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
        }
    }
    
    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty() && !"unknown".equalsIgnoreCase(xForwardedFor)) {
            return xForwardedFor.split(",")[0];
        }
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty() && !"unknown".equalsIgnoreCase(xRealIp)) {
            return xRealIp;
        }
        return request.getRemoteAddr();
    }
    
    private void logFailedLogin(String loginName, String ipAddress, String reason) {
        AuditLog log = new AuditLog(0, loginName, "登录失败", reason, ipAddress);
        log.setHmacSignature(CryptoUtil.generateHmacSm3(log.toString()));
        auditLogDao.addAuditLog(log);
    }
} 