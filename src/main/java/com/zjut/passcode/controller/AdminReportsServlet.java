package com.zjut.passcode.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.zjut.passcode.bean.Admin;
import com.zjut.passcode.dao.AppointmentDao;

@WebServlet("/admin/reports")
public class AdminReportsServlet extends HttpServlet {
    
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
        String role = admin.getRole();
        boolean canReportPublic = admin.isCanReportPublicAppointment();
        System.out.println("INFO: Admin reports page accessed by: " + admin.getLoginName());
        
        // Set attributes for JSP
        request.setAttribute("admin", admin);
        
        // 统计数据
        AppointmentDao appointmentDao = new AppointmentDao();
        List<Map<String, Object>> applyMonthStats = null;
        List<Map<String, Object>> entryMonthStats = null;
        List<Map<String, Object>> campusStats = null;
        List<Map<String, Object>> deptStats = null;
        if ("SYSTEM_ADMIN".equals(role) || "SCHOOL_ADMIN".equals(role)) {
            // 学校/系统管理员可查所有
            applyMonthStats = appointmentDao.getStatsByApplyMonth();
            entryMonthStats = appointmentDao.getStatsByEntryMonth();
            campusStats = appointmentDao.getStatsByCampus();
            deptStats = appointmentDao.getStatsByOfficialDept();
        } else if ("DEPT_ADMIN".equals(role)) {
            if (!canReportPublic) {
                // 只允许统计本部门公务预约
                applyMonthStats = appointmentDao.getStatsByApplyMonthForDept(admin.getDeptId(), "OFFICIAL");
                entryMonthStats = appointmentDao.getStatsByEntryMonthForDept(admin.getDeptId(), "OFFICIAL");
                campusStats = appointmentDao.getStatsByCampusForDept(admin.getDeptId(), "OFFICIAL");
                deptStats = appointmentDao.getStatsByOfficialDeptForDept(admin.getDeptId());
            } else {
                // 可统计本部门所有预约
                applyMonthStats = appointmentDao.getStatsByApplyMonthForDept(admin.getDeptId(), "PUBLIC");
                List<Map<String, Object>> officialApply = appointmentDao.getStatsByApplyMonthForDept(admin.getDeptId(), "OFFICIAL");
                applyMonthStats.addAll(officialApply);
                entryMonthStats = appointmentDao.getStatsByEntryMonthForDept(admin.getDeptId(), "PUBLIC");
                List<Map<String, Object>> officialEntry = appointmentDao.getStatsByEntryMonthForDept(admin.getDeptId(), "OFFICIAL");
                entryMonthStats.addAll(officialEntry);
                campusStats = appointmentDao.getStatsByCampusForDept(admin.getDeptId(), "PUBLIC");
                List<Map<String, Object>> officialCampus = appointmentDao.getStatsByCampusForDept(admin.getDeptId(), "OFFICIAL");
                campusStats.addAll(officialCampus);
                deptStats = appointmentDao.getStatsByOfficialDeptForDept(admin.getDeptId());
            }
        } else {
            // 其它角色无权访问
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问统计报告");
            return;
        }
        request.setAttribute("applyMonthStats", applyMonthStats);
        request.setAttribute("entryMonthStats", entryMonthStats);
        request.setAttribute("campusStats", campusStats);
        request.setAttribute("deptStats", deptStats);
        
        // Forward to reports page
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 