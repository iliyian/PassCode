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
        
        System.out.println("=== Login Attempt ===");
        System.out.println("Username: " + loginName);
        System.out.println("IP Address: " + ipAddress);
        System.out.println("Timestamp: " + LocalDateTime.now());
        
        try {
            // Validate input
            if (loginName == null || loginName.trim().isEmpty() || 
                password == null || password.trim().isEmpty()) {
                System.out.println("ERROR: Input validation failed - empty username or password");
                request.setAttribute("error", "用户名和密码不能为空");
                request.setAttribute("errorDetails", "请检查输入的用户名和密码是否完整");
                request.setAttribute("errorType", "INPUT_VALIDATION");
                request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
                return;
            }
            
            // Get admin information
            Admin admin = null;
            try {
                System.out.println("INFO: Attempting to retrieve admin from database...");
                admin = adminDao.getAdminByLoginName(loginName);
                if (admin != null) {
                    System.out.println("INFO: Admin found - ID: " + admin.getId() + ", Name: " + admin.getFullName());
                } else {
                    System.out.println("WARNING: Admin not found for username: " + loginName);
                }
            } catch (Exception e) {
                // Database connection error
                System.out.println("ERROR: Database connection failed");
                System.out.println("ERROR Details: " + e.getMessage());
                e.printStackTrace();
                logError("Database connection failed", e, loginName, ipAddress);
                request.setAttribute("error", "系统暂时无法连接数据库，请稍后重试");
                request.setAttribute("errorDetails", "错误详情: " + e.getMessage());
                request.setAttribute("errorType", "DATABASE_CONNECTION");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            if (admin == null) {
                System.out.println("ERROR: User not found - " + loginName);
                logFailedLogin(loginName, ipAddress, "User not found");
                request.setAttribute("error", "用户名或密码错误");
                request.setAttribute("errorDetails", "用户名 '" + loginName + "' 在系统中不存在");
                request.setAttribute("errorType", "USER_NOT_FOUND");
                request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
                return;
            }
            
            // Check if account is locked
            if (admin.getLockoutUntil() != null && 
                admin.getLockoutUntil().after(Timestamp.valueOf(LocalDateTime.now()))) {
                System.out.println("ERROR: Account locked for user: " + loginName);
                System.out.println("ERROR: Lockout until: " + admin.getLockoutUntil());
                logFailedLogin(loginName, ipAddress, "Account locked");
                request.setAttribute("error", "账户已被锁定，请稍后再试");
                request.setAttribute("errorDetails", "账户锁定截止时间: " + admin.getLockoutUntil());
                request.setAttribute("errorType", "ACCOUNT_LOCKED");
                request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
                return;
            }
            
            // Verify password
            String hashedPassword = null;
            try {
                System.out.println("INFO: Hashing password...");
                hashedPassword = CryptoUtil.sm3Hash(password);
                if (hashedPassword == null) {
                    throw new Exception("Password hashing failed");
                }
                System.out.println("INFO: Password hashed successfully");
            } catch (Exception e) {
                System.out.println("ERROR: Password encryption failed");
                System.out.println("ERROR Details: " + e.getMessage());
                e.printStackTrace();
                logError("Password encryption failed", e, loginName, ipAddress);
                request.setAttribute("error", "密码处理失败，请稍后重试");
                request.setAttribute("errorDetails", "密码加密过程出现错误: " + e.getMessage());
                request.setAttribute("errorType", "PASSWORD_ENCRYPTION");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            System.out.println("INFO: Input password hash: " + hashedPassword);
            System.out.println("INFO: Database password hash: " + admin.getPasswordHash());
            System.out.println("INFO: Password match: " + hashedPassword.equals(admin.getPasswordHash()));
            
            if (!hashedPassword.equals(admin.getPasswordHash())) {
                // Increase failed attempts
                int failedAttempts = admin.getFailedLoginAttempts() + 1;
                System.out.println("ERROR: Password mismatch for user: " + loginName);
                System.out.println("ERROR: Failed attempts: " + failedAttempts);
                
                try {
                    adminDao.updateFailedLoginAttempts(admin.getId(), failedAttempts);
                    System.out.println("INFO: Updated failed login attempts in database");
                } catch (Exception e) {
                    System.out.println("ERROR: Failed to update login attempts");
                    System.out.println("ERROR Details: " + e.getMessage());
                    logError("Failed to update login attempts", e, loginName, ipAddress);
                }
                
                // Lock account if failed 5 times
                if (failedAttempts >= 5) {
                    try {
                        Timestamp lockoutUntil = Timestamp.valueOf(LocalDateTime.now().plus(30, ChronoUnit.MINUTES));
                        adminDao.setLockoutUntil(admin.getId(), lockoutUntil);
                        System.out.println("WARNING: Account locked for 30 minutes");
                        System.out.println("WARNING: Lockout until: " + lockoutUntil);
                        logFailedLogin(loginName, ipAddress, "Password error, account locked");
                        request.setAttribute("error", "密码错误次数过多，账户已被锁定30分钟");
                        request.setAttribute("errorDetails", "连续失败次数: " + failedAttempts + "，锁定截止时间: " + lockoutUntil);
                        request.setAttribute("errorType", "ACCOUNT_LOCKED");
                    } catch (Exception e) {
                        System.out.println("ERROR: Failed to set account lockout");
                        System.out.println("ERROR Details: " + e.getMessage());
                        logError("Failed to set account lockout", e, loginName, ipAddress);
                        request.setAttribute("error", "密码错误次数过多，但锁定账户时出现错误");
                        request.setAttribute("errorDetails", "错误详情: " + e.getMessage());
                        request.setAttribute("errorType", "LOCKOUT_ERROR");
                    }
                } else {
                    logFailedLogin(loginName, ipAddress, "Password error");
                    request.setAttribute("error", "用户名或密码错误");
                    request.setAttribute("errorDetails", "连续失败次数: " + failedAttempts + "，剩余尝试次数: " + (5 - failedAttempts));
                    request.setAttribute("errorType", "PASSWORD_MISMATCH");
                }
                request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
                return;
            }
            
            // Check if password is expired (90 days)
            if (admin.getPasswordLastChanged() != null) {
                long daysSinceChange = ChronoUnit.DAYS.between(
                    admin.getPasswordLastChanged().toLocalDateTime(), 
                    LocalDateTime.now()
                );
                System.out.println("INFO: Days since password change: " + daysSinceChange);
                if (daysSinceChange > 90) {
                    System.out.println("WARNING: Password expired for user: " + loginName);
                    request.setAttribute("warning", "密码已过期，请及时修改密码");
                    request.setAttribute("warningDetails", "密码已使用 " + daysSinceChange + " 天，建议修改密码");
                }
            }
            
            // Login successful, reset failed attempts
            try {
                adminDao.resetFailedLoginAttempts(admin.getId());
                System.out.println("INFO: Reset failed login attempts");
            } catch (Exception e) {
                System.out.println("ERROR: Failed to reset login attempts");
                System.out.println("ERROR Details: " + e.getMessage());
                logError("Failed to reset login attempts", e, loginName, ipAddress);
                // Don't affect successful login, just log error
            }

            System.out.println("SUCCESS: Login successful for user: " + loginName);

            // Record login log
            try {
                AuditLog log = new AuditLog(admin.getId(), admin.getFullName(), "登录", 
                                           "管理员登录成功", ipAddress);
                log.setHmacSignature(CryptoUtil.generateHmacSm3(log.toString()));
                auditLogDao.addAuditLog(log);
                System.out.println("INFO: Login audit log recorded");
            } catch (Exception e) {
                System.out.println("ERROR: Failed to record login audit log");
                System.out.println("ERROR Details: " + e.getMessage());
                logError("Failed to record login audit log", e, loginName, ipAddress);
                // Don't affect successful login, just log error
            }
            
            // Set session
            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);
            session.setAttribute("adminId", admin.getId());
            session.setAttribute("adminName", admin.getFullName());
            session.setAttribute("adminRole", admin.getRole());
            session.setAttribute("adminDeptId", admin.getDeptId());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout
            System.out.println("INFO: Session created for user: " + loginName);
            System.out.println("INFO: Session timeout: 30 minutes");
            
            // Redirect based on role
            if ("AUDIT_ADMIN".equals(admin.getRole())) {
                System.out.println("INFO: Redirecting to audit admin page");
                response.sendRedirect(request.getContextPath() + "/admin/audit_log_manage.jsp");
            } else {
                System.out.println("INFO: Redirecting to admin index page");
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
            }
            
        } catch (Exception e) {
            // Catch all unexpected exceptions
            System.out.println("ERROR: Unexpected error during login process");
            System.out.println("ERROR Details: " + e.getMessage());
            e.printStackTrace();
            logError("Unexpected error during login process", e, loginName, ipAddress);
            request.setAttribute("error", "系统发生未知错误，请稍后重试");
            request.setAttribute("errorDetails", "错误详情: " + e.getMessage());
            request.setAttribute("errorType", "UNKNOWN_ERROR");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
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
        try {
            AuditLog log = new AuditLog(0, loginName, "登录失败", reason, ipAddress);
            log.setHmacSignature(CryptoUtil.generateHmacSm3(log.toString()));
            auditLogDao.addAuditLog(log);
            System.out.println("INFO: Failed login logged to audit trail");
        } catch (Exception e) {
            System.out.println("ERROR: Failed to log failed login attempt");
            System.out.println("ERROR Details: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void logError(String action, Exception e, String loginName, String ipAddress) {
        try {
            String details = action + " - Exception: " + e.getClass().getSimpleName() + ": " + e.getMessage();
            AuditLog log = new AuditLog(0, loginName, "System Error", details, ipAddress);
            log.setHmacSignature(CryptoUtil.generateHmacSm3(log.toString()));
            auditLogDao.addAuditLog(log);
            System.out.println("INFO: Error logged to audit trail");
        } catch (Exception ex) {
            System.out.println("ERROR: Failed to log error to audit trail");
            System.out.println("ERROR Details: " + ex.getMessage());
            ex.printStackTrace();
        }
        // Also output to console
        System.out.println("ERROR: Login error - " + action + ": " + e.getMessage());
        e.printStackTrace();
    }
} 