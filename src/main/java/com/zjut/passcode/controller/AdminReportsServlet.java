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
        System.out.println("INFO: Admin reports page accessed by: " + admin.getLoginName());
        
        // Set attributes for JSP
        request.setAttribute("admin", admin);
        
        // 统计数据
        AppointmentDao appointmentDao = new AppointmentDao();
        List<Map<String, Object>> applyMonthStats = appointmentDao.getStatsByApplyMonth();
        List<Map<String, Object>> entryMonthStats = appointmentDao.getStatsByEntryMonth();
        List<Map<String, Object>> campusStats = appointmentDao.getStatsByCampus();
        List<Map<String, Object>> deptStats = appointmentDao.getStatsByOfficialDept();
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