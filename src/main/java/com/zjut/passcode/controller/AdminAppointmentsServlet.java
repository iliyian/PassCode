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
            List<Appointment> appointments;
            
            // 根据管理员角色获取相应的预约
            if ("DEPT_ADMIN".equals(admin.getRole())) {
                // 部门管理员根据权限获取预约
                if (admin.isCanManagePublicAppointment()) {
                    // 可以管理社会公众预约，获取本部门所有预约（公务预约 + 社会公众预约）
                    appointments = appointmentDao.getAppointmentsByDept(admin.getDeptId());
                    System.out.println("INFO: Dept admin with public permission retrieved " + appointments.size() + " appointments for dept " + admin.getDeptId());
                } else {
                    // 只能管理公务预约，获取本部门公务预约
                    appointments = appointmentDao.getAppointmentsByDeptAndType(admin.getDeptId(), "OFFICIAL");
                    System.out.println("INFO: Dept admin without public permission retrieved " + appointments.size() + " official appointments for dept " + admin.getDeptId());
                }
            } else if ("SCHOOL_ADMIN".equals(admin.getRole()) || "SYSTEM_ADMIN".equals(admin.getRole())) {
                // 学校管理员和系统管理员可以查看所有预约
                appointments = appointmentDao.getAllAppointments();
                System.out.println("INFO: School/System admin retrieved " + appointments.size() + " appointments");
            } else {
                // 其他角色无权访问
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问预约管理");
                return;
            }
            
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
                
                // 获取预约信息进行权限检查
                Appointment appointment = appointmentDao.getAppointmentById(appointmentId);
                if (appointment == null) {
                    request.setAttribute("error", "预约不存在");
                    doGet(request, response);
                    return;
                }
                
                // 权限检查：部门管理员根据权限审核预约
                if ("DEPT_ADMIN".equals(admin.getRole())) {
                    if ("OFFICIAL".equals(appointment.getAppointmentType())) {
                        // 公务预约：检查是否是本部门的预约
                        if (appointment.getOfficialDeptId() == null || 
                            appointment.getOfficialDeptId() != admin.getDeptId()) {
                            request.setAttribute("error", "您只能审核本部门的公务预约");
                            doGet(request, response);
                            return;
                        }
                    } else if ("PUBLIC".equals(appointment.getAppointmentType())) {
                        // 社会公众预约：检查是否有管理权限
                        if (!admin.isCanManagePublicAppointment()) {
                            request.setAttribute("error", "您没有权限审核社会公众预约");
                            doGet(request, response);
                            return;
                        }
                    }
                }
                
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