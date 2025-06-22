package com.zjut.passcode.controller;

import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.zjut.passcode.bean.Admin;
import com.zjut.passcode.bean.Department;
import com.zjut.passcode.dao.DepartmentDao;

@WebServlet("/admin/department/*")
public class DepartmentOperationServlet extends HttpServlet {
    private DepartmentDao departmentDao = new DepartmentDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set character encoding to handle Chinese characters
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/admin/departments");
            return;
        }
        
        String[] pathParts = pathInfo.split("/");
        if (pathParts.length < 2) {
            response.sendRedirect(request.getContextPath() + "/admin/departments");
            return;
        }
        
        String operation = pathParts[1];
        
        switch (operation) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteDepartment(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/departments");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set character encoding to handle Chinese characters
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/admin/departments");
            return;
        }
        
        String[] pathParts = pathInfo.split("/");
        if (pathParts.length < 2) {
            response.sendRedirect(request.getContextPath() + "/admin/departments");
            return;
        }
        
        String operation = pathParts[1];
        
        switch (operation) {
            case "add":
                addDepartment(request, response);
                break;
            case "edit":
                editDepartment(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/departments");
                break;
        }
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/add_department.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("error", "部门ID不能为空");
            response.sendRedirect(request.getContextPath() + "/admin/departments");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            Department department = departmentDao.getDepartmentById(id);
            
            if (department == null) {
                request.setAttribute("error", "部门不存在");
                response.sendRedirect(request.getContextPath() + "/admin/departments");
                return;
            }
            
            request.setAttribute("department", department);
            request.getRequestDispatcher("/admin/edit_department.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "无效的部门ID");
            response.sendRedirect(request.getContextPath() + "/admin/departments");
        }
    }
    
    private void addDepartment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String deptNo = request.getParameter("deptNo");
        String deptName = request.getParameter("deptName");
        String deptType = request.getParameter("deptType");
        
        // Debug: Print received parameters
        System.out.println("DEBUG: Received parameters:");
        System.out.println("  deptNo: " + deptNo);
        System.out.println("  deptName: " + deptName);
        System.out.println("  deptType: " + deptType);
        
        // Validate input
        if (deptNo == null || deptNo.trim().isEmpty() ||
            deptName == null || deptName.trim().isEmpty() ||
            deptType == null || deptType.trim().isEmpty()) {
            request.setAttribute("error", "所有字段都是必填的");
            request.setAttribute("deptNo", deptNo);
            request.setAttribute("deptName", deptName);
            request.setAttribute("deptType", deptType);
            request.getRequestDispatcher("/admin/add_department.jsp").forward(request, response);
            return;
        }
        
        // Trim whitespace
        deptNo = deptNo.trim();
        deptName = deptName.trim();
        deptType = deptType.trim();
        
        // Validate department type
        if (!isValidDepartmentType(deptType)) {
            request.setAttribute("error", "无效的部门类型");
            request.setAttribute("deptNo", deptNo);
            request.setAttribute("deptName", deptName);
            request.setAttribute("deptType", deptType);
            request.getRequestDispatcher("/admin/add_department.jsp").forward(request, response);
            return;
        }
        
        try {
            // Create department object
            Department department = new Department(deptNo, deptName, deptType);
            
            // Add to database
            boolean success = departmentDao.addDepartment(department);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/departments?success=" + URLEncoder.encode("部门添加成功", "UTF-8"));
            } else {
                request.setAttribute("error", "部门添加失败，请检查部门编号是否已存在");
                request.setAttribute("deptNo", deptNo);
                request.setAttribute("deptName", deptName);
                request.setAttribute("deptType", deptType);
                request.getRequestDispatcher("/admin/add_department.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("ERROR: Failed to add department");
            System.out.println("ERROR Details: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "添加部门时发生错误: " + e.getMessage());
            request.setAttribute("deptNo", deptNo);
            request.setAttribute("deptName", deptName);
            request.setAttribute("deptType", deptType);
            request.getRequestDispatcher("/admin/add_department.jsp").forward(request, response);
        }
    }
    
    private void editDepartment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String idParam = request.getParameter("id");
        String deptNo = request.getParameter("deptNo");
        String deptName = request.getParameter("deptName");
        String deptType = request.getParameter("deptType");
        
        // Debug: Print received parameters
        System.out.println("DEBUG: Edit department parameters:");
        System.out.println("  id: " + idParam);
        System.out.println("  deptNo: " + deptNo);
        System.out.println("  deptName: " + deptName);
        System.out.println("  deptType: " + deptType);
        
        // Validate input
        if (idParam == null || idParam.trim().isEmpty() ||
            deptNo == null || deptNo.trim().isEmpty() ||
            deptName == null || deptName.trim().isEmpty() ||
            deptType == null || deptType.trim().isEmpty()) {
            request.setAttribute("error", "所有字段都是必填的");
            response.sendRedirect(request.getContextPath() + "/admin/departments");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            
            // Trim whitespace
            deptNo = deptNo.trim();
            deptName = deptName.trim();
            deptType = deptType.trim();
            
            // Validate department type
            if (!isValidDepartmentType(deptType)) {
                request.setAttribute("error", "无效的部门类型");
                response.sendRedirect(request.getContextPath() + "/admin/departments");
                return;
            }
            
            // Get existing department
            Department existingDept = departmentDao.getDepartmentById(id);
            if (existingDept == null) {
                request.setAttribute("error", "部门不存在");
                response.sendRedirect(request.getContextPath() + "/admin/departments");
                return;
            }
            
            // Update department object
            existingDept.setDeptNo(deptNo);
            existingDept.setDeptName(deptName);
            existingDept.setDeptType(deptType);
            
            // Update in database
            boolean success = departmentDao.updateDepartment(existingDept);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/departments?success=" + URLEncoder.encode("部门更新成功", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/departments?error=" + URLEncoder.encode("部门更新失败", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "无效的部门ID");
            response.sendRedirect(request.getContextPath() + "/admin/departments");
        } catch (Exception e) {
            System.out.println("ERROR: Failed to update department");
            System.out.println("ERROR Details: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "更新部门时发生错误: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/departments");
        }
    }
    
    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("error", "部门ID不能为空");
            response.sendRedirect(request.getContextPath() + "/admin/departments");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            
            // Check if department exists
            Department department = departmentDao.getDepartmentById(id);
            if (department == null) {
                request.setAttribute("error", "部门不存在");
                response.sendRedirect(request.getContextPath() + "/admin/departments");
                return;
            }
            
            // Delete from database
            boolean success = departmentDao.deleteDepartment(id);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/departments?success=" + URLEncoder.encode("部门删除成功", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/departments?error=" + URLEncoder.encode("部门删除失败", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "无效的部门ID");
            response.sendRedirect(request.getContextPath() + "/admin/departments");
        } catch (Exception e) {
            System.out.println("ERROR: Failed to delete department");
            System.out.println("ERROR Details: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "删除部门时发生错误: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/departments");
        }
    }
    
    private boolean isValidDepartmentType(String deptType) {
        return "行政部门".equals(deptType) || 
               "直属部门".equals(deptType) || 
               "学院".equals(deptType);
    }
} 