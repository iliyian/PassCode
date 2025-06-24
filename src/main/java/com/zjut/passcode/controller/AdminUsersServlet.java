package com.zjut.passcode.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.zjut.passcode.bean.Admin;
import com.zjut.passcode.bean.AuditLog;
import com.zjut.passcode.bean.Department;
import com.zjut.passcode.dao.AdminDao;
import com.zjut.passcode.dao.AuditLogDao;
import com.zjut.passcode.dao.DepartmentDao;
import com.zjut.passcode.util.CryptoUtil;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {
    private AdminDao adminDao = new AdminDao();
    private DepartmentDao departmentDao = new DepartmentDao();
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
        String adminRole = admin.getRole();
        if (!"SYSTEM_ADMIN".equals(adminRole) && !"SCHOOL_ADMIN".equals(adminRole)) {
            request.setAttribute("error", "权限不足");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        String action = request.getParameter("action");
        List<Department> departments = departmentDao.getAllDepartments();
        request.setAttribute("departments", departments);
        if ("add".equals(action)) {
            showAddForm(request, response);
            return;
        } else if ("editUser".equals(action)) {
            showEditForm(request, response);
            return;
        } else if ("resetPwd".equals(action)) {
            showResetPwdForm(request, response);
            return;
        }
        
        System.out.println("INFO: Admin users page accessed by: " + admin.getLoginName());
        
        try {
            // Get admins based on current admin's role
            List<Admin> admins;
            if ("SYSTEM_ADMIN".equals(adminRole)) {
                // 系统管理员可以查看所有管理员
                admins = adminDao.getAllAdmins();
            } else if ("SCHOOL_ADMIN".equals(adminRole)) {
                // 学校管理员只能查看部门管理员
                admins = adminDao.getAdminsByRole("DEPT_ADMIN");
            } else {
                admins = new ArrayList<>();
            }
            
            System.out.println("INFO: Retrieved " + admins.size() + " admin users");
            
            // Set attributes for JSP
            request.setAttribute("admins", admins);
            request.setAttribute("currentAdmin", admin);
            
            // Forward to users management page
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR: Failed to retrieve admin users");
            System.out.println("ERROR Details: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "获取用户信息失败");
            request.setAttribute("errorDetails", "错误详情: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        Admin admin = (Admin) session.getAttribute("admin");
        String adminRole = admin.getRole();
        if (!"SYSTEM_ADMIN".equals(adminRole) && !"SCHOOL_ADMIN".equals(adminRole)) {
            request.setAttribute("error", "权限不足");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addAdmin(request, response);
            return;
        } else if ("edit".equals(action)) {
            editAdmin(request, response);
            return;
        } else if ("delete".equals(action)) {
            deleteAdmin(request, response);
            return;
        } else if ("resetPwd".equals(action)) {
            resetPassword(request, response);
            return;
        }
        doGet(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Department> departments = departmentDao.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/admin/users.jsp?action=showAddForm").forward(request, response);
    }

    private void addAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Admin admin = (Admin) request.getSession().getAttribute("admin");
        String adminRole = admin.getRole();
        String loginName = request.getParameter("loginName");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String deptIdStr = request.getParameter("deptId");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        boolean canManagePublicAppointment = "1".equals(request.getParameter("canManagePublicAppointment"));
        boolean canReportPublicAppointment = "1".equals(request.getParameter("canReportPublicAppointment"));
        
        // 权限检查：学校管理员只能添加部门管理员
        if ("SCHOOL_ADMIN".equals(adminRole) && !"DEPT_ADMIN".equals(role)) {
            request.setAttribute("error", "学校管理员只能添加部门管理员");
            showAddForm(request, response);
            return;
        }
        
        if (loginName == null || loginName.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            request.setAttribute("error", "请填写所有必填字段");
            showAddForm(request, response);
            return;
        }
        if (!CryptoUtil.validatePasswordComplexity(password)) {
            request.setAttribute("error", "密码必须包含8位以上，包含数字、大小写字母、特殊字符");
            showAddForm(request, response);
            return;
        }
        Admin existingAdmin = adminDao.getAdminByLoginName(loginName);
        if (existingAdmin != null) {
            request.setAttribute("error", "登录名已存在");
            showAddForm(request, response);
            return;
        }
        try {
            String hashedPassword = CryptoUtil.sm3Hash(password);
            String encryptedPhone = CryptoUtil.sm4Encrypt(phone, "campus_pass_key_");
            Admin newAdmin = new Admin();
            newAdmin.setLoginName(loginName);
            newAdmin.setPasswordHash(hashedPassword);
            newAdmin.setFullName(fullName);
            newAdmin.setDeptId(deptIdStr != null && !deptIdStr.trim().isEmpty() ? Integer.parseInt(deptIdStr) : 0);
            newAdmin.setPhone(encryptedPhone);
            newAdmin.setRole(role);
            newAdmin.setCanManagePublicAppointment(canManagePublicAppointment);
            newAdmin.setCanReportPublicAppointment(canReportPublicAppointment);
            if (adminDao.addAdmin(newAdmin)) {
                // 记录审计日志
                int currentAdminId = admin.getId();
                String currentAdminName = admin.getFullName();
                AuditLog log = new AuditLog(currentAdminId, currentAdminName, "添加管理员", "添加管理员: " + loginName, request.getRemoteAddr());
                log.setHmacSignature(CryptoUtil.generateHmacSm3(log.toString()));
                auditLogDao.addAuditLog(log);
                request.setAttribute("message", "管理员添加成功");
            } else {
                request.setAttribute("error", "管理员添加失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请重试");
        }
        doGet(request, response);
    }

    private void deleteAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        Admin currentAdmin = (Admin) request.getSession().getAttribute("admin");
        String adminRole = currentAdmin.getRole();
        
        if (userId == currentAdmin.getId()) {
            request.setAttribute("error", "不能删除自己");
            doGet(request, response);
            return;
        }
        
        // 获取要删除的用户信息
        Admin userToDelete = adminDao.getAdminById(userId);
        if (userToDelete == null) {
            request.setAttribute("error", "用户不存在");
            doGet(request, response);
            return;
        }
        
        // 权限检查：学校管理员只能删除部门管理员
        if ("SCHOOL_ADMIN".equals(adminRole) && !"DEPT_ADMIN".equals(userToDelete.getRole())) {
            request.setAttribute("error", "学校管理员只能删除部门管理员");
            doGet(request, response);
            return;
        }
        
        if (adminDao.deleteAdmin(userId)) {
            request.setAttribute("message", "管理员删除成功");
        } else {
            request.setAttribute("error", "管理员删除失败");
        }
        doGet(request, response);
    }

    private void editAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        Admin currentAdmin = (Admin) request.getSession().getAttribute("admin");
        String adminRole = currentAdmin.getRole();
        String loginName = request.getParameter("loginName");
        String fullName = request.getParameter("fullName");
        String deptIdStr = request.getParameter("deptId");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        boolean canManagePublicAppointment = "1".equals(request.getParameter("canManagePublicAppointment"));
        boolean canReportPublicAppointment = "1".equals(request.getParameter("canReportPublicAppointment"));
        
        // 获取要编辑的用户信息
        Admin user = adminDao.getAdminById(userId);
        if (user == null) {
            request.setAttribute("error", "用户不存在");
            doGet(request, response);
            return;
        }
        
        // 权限检查：学校管理员只能编辑部门管理员，且不能改变角色
        if ("SCHOOL_ADMIN".equals(adminRole)) {
            if (!"DEPT_ADMIN".equals(user.getRole())) {
                request.setAttribute("error", "学校管理员只能编辑部门管理员");
                doGet(request, response);
                return;
            }
            if (!"DEPT_ADMIN".equals(role)) {
                request.setAttribute("error", "学校管理员不能将部门管理员改为其他角色");
                doGet(request, response);
                return;
            }
        }
        
        if (loginName == null || loginName.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            request.setAttribute("error", "请填写所有必填字段");
            request.getRequestDispatcher("/admin/edit_user.jsp?userId=" + userId).forward(request, response);
            return;
        }
        
        user.setLoginName(loginName);
        user.setFullName(fullName);
        user.setDeptId(deptIdStr != null && !deptIdStr.trim().isEmpty() ? Integer.parseInt(deptIdStr) : 0);
        user.setPhone(phone);
        user.setRole(role);
        user.setCanManagePublicAppointment(canManagePublicAppointment);
        user.setCanReportPublicAppointment(canReportPublicAppointment);
        if (adminDao.updateAdmin(user)) {
            request.setAttribute("message", "管理员信息修改成功");
        } else {
            request.setAttribute("error", "管理员信息修改失败");
        }
        doGet(request, response);
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String newPassword = request.getParameter("newPassword");
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "新密码不能为空");
            request.getRequestDispatcher("/admin/reset_password.jsp?userId=" + userId).forward(request, response);
            return;
        }
        if (!CryptoUtil.validatePasswordComplexity(newPassword)) {
            request.setAttribute("error", "密码必须包含8位以上，包含数字、大小写字母、特殊字符");
            request.getRequestDispatcher("/admin/reset_password.jsp?userId=" + userId).forward(request, response);
            return;
        }
        String hashedPassword = CryptoUtil.sm3Hash(newPassword);
        if (adminDao.updatePassword(userId, hashedPassword)) {
            request.setAttribute("message", "密码重置成功");
        } else {
            request.setAttribute("error", "密码重置失败");
        }
        doGet(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        Admin user = adminDao.getAdminById(userId);
        List<Department> departments = departmentDao.getAllDepartments();
        request.setAttribute("editUser", user);
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/admin/edit_user.jsp").forward(request, response);
    }

    private void showResetPwdForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        Admin user = adminDao.getAdminById(userId);
        request.setAttribute("resetUser", user);
        request.getRequestDispatcher("/admin/reset_password.jsp").forward(request, response);
    }
} 