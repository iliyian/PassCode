package com.zjut.passcode.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.zjut.passcode.bean.Admin;
import com.zjut.passcode.bean.AuditLog;
import com.zjut.passcode.dao.AuditLogDao;

@WebServlet("/admin/audit_logs")
public class AdminAuditLogsServlet extends HttpServlet {
    private AuditLogDao auditLogDao = new AuditLogDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        Admin admin = (Admin) session.getAttribute("admin");
        System.out.println("INFO: Admin audit logs page accessed by: " + admin.getLoginName());
        
        try {
            // 分页参数
            int page = 1;
            int pageSize = 20;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try { page = Integer.parseInt(pageParam); } catch (NumberFormatException ignored) {}
            }
            String pageSizeParam = request.getParameter("pageSize");
            if (pageSizeParam != null) {
                try { pageSize = Integer.parseInt(pageSizeParam); } catch (NumberFormatException ignored) {}
            }
            int totalLogs = auditLogDao.getAuditLogsCount();
            int totalPages = (int)Math.ceil((double)totalLogs / pageSize);
            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;
            // 分页查询
            List<AuditLog> auditLogs = auditLogDao.getAuditLogsByPage(page, pageSize);
            // Set attributes for JSP
            request.setAttribute("auditLogs", auditLogs);
            request.setAttribute("admin", admin);
            request.setAttribute("page", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalLogs", totalLogs);
            request.setAttribute("totalPages", totalPages);
            // Forward to audit logs page
            request.getRequestDispatcher("/admin/audit_logs.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR: Failed to retrieve audit logs");
            System.out.println("ERROR Details: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "获取审计日志失败");
            request.setAttribute("errorDetails", "错误详情: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 