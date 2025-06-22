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
import com.zjut.passcode.bean.Appointment;
import com.zjut.passcode.dao.AppointmentDao;

@WebServlet("/admin/appointments")
public class AdminAppointmentsServlet extends HttpServlet {
    private AppointmentDao appointmentDao = new AppointmentDao();
    
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
        System.out.println("INFO: Admin appointments page accessed by: " + admin.getLoginName());
        
        try {
            // Get all appointments
            List<Appointment> appointments = appointmentDao.getAllAppointments();
            System.out.println("INFO: Retrieved " + appointments.size() + " appointments");
            
            // Set attributes for JSP
            request.setAttribute("appointments", appointments);
            request.setAttribute("admin", admin);
            
            // Forward to appointments management page
            request.getRequestDispatcher("/admin/appointments.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR: Failed to retrieve appointments");
            System.out.println("ERROR Details: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "获取预约信息失败");
            request.setAttribute("errorDetails", "错误详情: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        Admin admin = (Admin) session.getAttribute("admin");

        String action = request.getParameter("action");
        String appointmentIdStr = request.getParameter("appointmentId");
        if (action != null && appointmentIdStr != null) {
            try {
                long appointmentId = Long.parseLong(appointmentIdStr);
                AppointmentDao appointmentDao = new AppointmentDao();
                boolean result = false;
                if ("approve".equals(action)) {
                    result = appointmentDao.updateAppointmentStatus(appointmentId, "APPROVED", admin.getId());
                } else if ("reject".equals(action)) {
                    result = appointmentDao.updateAppointmentStatus(appointmentId, "REJECTED", admin.getId());
                }
                if (result) {
                    // 记录审计日志
                    // 这里假设有AuditLogDao和AuditLog类
                    com.zjut.passcode.dao.AuditLogDao auditLogDao = new com.zjut.passcode.dao.AuditLogDao();
                    com.zjut.passcode.bean.AuditLog log = new com.zjut.passcode.bean.AuditLog(
                        admin.getId(), admin.getFullName(),
                        ("approve".equals(action) ? "通过预约" : "拒绝预约"),
                        ("approve".equals(action) ? "通过预约ID: " : "拒绝预约ID: ") + appointmentId,
                        request.getRemoteAddr()
                    );
                    log.setHmacSignature(com.zjut.passcode.util.CryptoUtil.generateHmacSm3(log.toString()));
                    auditLogDao.addAuditLog(log);
                    request.setAttribute("message", ("approve".equals(action) ? "预约已通过" : "预约已拒绝"));
                } else {
                    request.setAttribute("error", "操作失败，请重试");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "系统错误，请重试");
            }
        }
        doGet(request, response);
    }
} 