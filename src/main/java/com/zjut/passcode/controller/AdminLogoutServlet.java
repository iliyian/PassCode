package com.zjut.passcode.controller;

import java.io.IOException;
import java.time.LocalDateTime;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.zjut.passcode.bean.Admin;
import com.zjut.passcode.bean.AuditLog;
import com.zjut.passcode.dao.AuditLogDao;
import com.zjut.passcode.util.CryptoUtil;

@WebServlet("/admin/logout")
public class AdminLogoutServlet extends HttpServlet {
    private AuditLogDao auditLogDao = new AuditLogDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            Admin admin = (Admin) session.getAttribute("admin");
            String ipAddress = getClientIpAddress(request);
            
            if (admin != null) {
                System.out.println("INFO: Admin logout - User: " + admin.getLoginName());
                System.out.println("INFO: Logout time: " + LocalDateTime.now());
                
                // Record logout audit log
                try {
                    AuditLog log = new AuditLog(admin.getId(), admin.getFullName(), "退出登录", 
                                               "管理员退出登录", ipAddress);
                    log.setHmacSignature(CryptoUtil.generateHmacSm3(log.toString()));
                    auditLogDao.addAuditLog(log);
                    System.out.println("INFO: Logout audit log recorded");
                } catch (Exception e) {
                    System.out.println("ERROR: Failed to record logout audit log");
                    System.out.println("ERROR Details: " + e.getMessage());
                }
            }
            
            // Invalidate session
            session.invalidate();
            System.out.println("INFO: Session invalidated");
        }
        
        // Redirect to login page
        response.sendRedirect(request.getContextPath() + "/admin/login");
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
} 