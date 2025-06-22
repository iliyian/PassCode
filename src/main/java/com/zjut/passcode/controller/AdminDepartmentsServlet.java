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
import com.zjut.passcode.bean.Department;
import com.zjut.passcode.dao.DepartmentDao;

@WebServlet("/admin/departments")
public class AdminDepartmentsServlet extends HttpServlet {
    private DepartmentDao departmentDao = new DepartmentDao();
    
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
        System.out.println("INFO: Admin departments page accessed by: " + admin.getLoginName());
        
        try {
            // Get all departments
            List<Department> departments = departmentDao.getAllDepartments();
            System.out.println("INFO: Retrieved " + departments.size() + " departments");
            
            // Set attributes for JSP
            request.setAttribute("departments", departments);
            request.setAttribute("admin", admin);
            
            // Forward to departments management page
            request.getRequestDispatcher("/admin/departments.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR: Failed to retrieve departments");
            System.out.println("ERROR Details: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "获取部门信息失败");
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