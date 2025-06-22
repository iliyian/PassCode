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
import com.zjut.passcode.bean.Department;
import com.zjut.passcode.dao.AdminDao;
import com.zjut.passcode.dao.AuditLogDao;
import com.zjut.passcode.dao.DepartmentDao;
import com.zjut.passcode.util.CryptoUtil;

@WebServlet("/admin/manage")
public class AdminManageServlet extends HttpServlet {
    private AdminDao adminDao = new AdminDao();
    private DepartmentDao departmentDao = new DepartmentDao();
    private AuditLogDao auditLogDao = new AuditLogDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        String adminRole = (String) session.getAttribute("adminRole");
        if (!"SYSTEM_ADMIN".equals(adminRole) && !"SCHOOL_ADMIN".equals(adminRole)) {
            request.setAttribute("error", "权限不足");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        String action = request.getParameter("action");
        if ("list".equals(action) || action == null) {
            listAdmins(request, response);
        } else if ("add".equals(action)) {
            showAddForm(request, response);
        } else if ("edit".equals(action)) {
            showEditForm(request, response);
        } else if ("delete".equals(action)) {
            deleteAdmin(request, response);
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
        
        String adminRole = (String) session.getAttribute("adminRole");
        if (!"SYSTEM_ADMIN".equals(adminRole) && !"SCHOOL_ADMIN".equals(adminRole)) {
            request.setAttribute("error", "权限不足");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addAdmin(request, response);
        } else if ("update".equals(action)) {
            updateAdmin(request, response);
        } else if ("changePassword".equals(action)) {
            changePassword(request, response);
        }
    }
    
    private void listAdmins(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Admin> admins = adminDao.getAllAdmins();
        request.setAttribute("admins", admins);
        request.getRequestDispatcher("/admin/admin_manage.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Department> departments = departmentDao.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/admin/admin_add.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Admin admin = adminDao.getAdminById(id);
                if (admin != null) {
                    List<Department> departments = departmentDao.getAllDepartments();
                    request.setAttribute("admin", admin);
                    request.setAttribute("departments", departments);
                    request.getRequestDispatcher("/admin/admin_edit.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // 忽略
            }
        }
        request.setAttribute("error", "管理员不存在");
        listAdmins(request, response);
    }
    
    private void addAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String loginName = request.getParameter("loginName");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String deptIdStr = request.getParameter("deptId");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        
        // 验证输入
        if (loginName == null || loginName.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            request.setAttribute("error", "请填写所有必填字段");
            showAddForm(request, response);
            return;
        }
        
        // 验证密码复杂度
        if (!CryptoUtil.validatePasswordComplexity(password)) {
            request.setAttribute("error", "密码必须包含8位以上，包含数字、大小写字母、特殊字符");
            showAddForm(request, response);
            return;
        }
        
        // 检查登录名是否已存在
        Admin existingAdmin = adminDao.getAdminByLoginName(loginName);
        if (existingAdmin != null) {
            request.setAttribute("error", "登录名已存在");
            showAddForm(request, response);
            return;
        }
        
        try {
            // 加密密码和手机号
            String hashedPassword = CryptoUtil.sm3Hash(password);
            String encryptedPhone = CryptoUtil.sm4Encrypt(phone, "campus_pass_key_2024");
            
            Admin admin = new Admin();
            admin.setLoginName(loginName);
            admin.setPasswordHash(hashedPassword);
            admin.setFullName(fullName);
            admin.setDeptId(deptIdStr != null && !deptIdStr.trim().isEmpty() ? Integer.parseInt(deptIdStr) : 0);
            admin.setPhone(encryptedPhone);
            admin.setRole(role);
            
            if (adminDao.addAdmin(admin)) {
                // 记录审计日志
                HttpSession session = request.getSession();
                int currentAdminId = (Integer) session.getAttribute("adminId");
                String currentAdminName = (String) session.getAttribute("adminName");
                AuditLog log = new AuditLog(currentAdminId, currentAdminName, "添加管理员", 
                                           "添加管理员: " + loginName, request.getRemoteAddr());
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
        
        listAdmins(request, response);
    }
    
    private void updateAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String idStr = request.getParameter("id");
        String loginName = request.getParameter("loginName");
        String fullName = request.getParameter("fullName");
        String deptIdStr = request.getParameter("deptId");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "管理员ID不能为空");
            listAdmins(request, response);
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Admin admin = adminDao.getAdminById(id);
            if (admin == null) {
                request.setAttribute("error", "管理员不存在");
                listAdmins(request, response);
                return;
            }
            
            // 更新信息
            admin.setLoginName(loginName);
            admin.setFullName(fullName);
            admin.setDeptId(deptIdStr != null && !deptIdStr.trim().isEmpty() ? Integer.parseInt(deptIdStr) : 0);
            admin.setPhone(CryptoUtil.sm4Encrypt(phone, "campus_pass_key_2024"));
            admin.setRole(role);
            
            if (adminDao.updateAdmin(admin)) {
                // 记录审计日志
                HttpSession session = request.getSession();
                int currentAdminId = (Integer) session.getAttribute("adminId");
                String currentAdminName = (String) session.getAttribute("adminName");
                AuditLog log = new AuditLog(currentAdminId, currentAdminName, "更新管理员", 
                                           "更新管理员: " + loginName, request.getRemoteAddr());
                log.setHmacSignature(CryptoUtil.generateHmacSm3(log.toString()));
                auditLogDao.addAuditLog(log);
                
                request.setAttribute("message", "管理员更新成功");
            } else {
                request.setAttribute("error", "管理员更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请重试");
        }
        
        listAdmins(request, response);
    }
    
    private void deleteAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "管理员ID不能为空");
            listAdmins(request, response);
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Admin admin = adminDao.getAdminById(id);
            if (admin == null) {
                request.setAttribute("error", "管理员不存在");
                listAdmins(request, response);
                return;
            }
            
            if (adminDao.deleteAdmin(id)) {
                // 记录审计日志
                HttpSession session = request.getSession();
                int currentAdminId = (Integer) session.getAttribute("adminId");
                String currentAdminName = (String) session.getAttribute("adminName");
                AuditLog log = new AuditLog(currentAdminId, currentAdminName, "删除管理员", 
                                           "删除管理员: " + admin.getLoginName(), request.getRemoteAddr());
                log.setHmacSignature(CryptoUtil.generateHmacSm3(log.toString()));
                auditLogDao.addAuditLog(log);
                
                request.setAttribute("message", "管理员删除成功");
            } else {
                request.setAttribute("error", "管理员删除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请重试");
        }
        
        listAdmins(request, response);
    }
    
    private void changePassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String idStr = request.getParameter("id");
        String newPassword = request.getParameter("newPassword");
        
        if (idStr == null || idStr.trim().isEmpty() || 
            newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "参数错误");
            listAdmins(request, response);
            return;
        }
        
        // 验证密码复杂度
        if (!CryptoUtil.validatePasswordComplexity(newPassword)) {
            request.setAttribute("error", "密码必须包含8位以上，包含数字、大小写字母、特殊字符");
            listAdmins(request, response);
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            String hashedPassword = CryptoUtil.sm3Hash(newPassword);
            
            if (adminDao.updatePassword(id, hashedPassword)) {
                // 记录审计日志
                HttpSession session = request.getSession();
                int currentAdminId = (Integer) session.getAttribute("adminId");
                String currentAdminName = (String) session.getAttribute("adminName");
                AuditLog log = new AuditLog(currentAdminId, currentAdminName, "修改密码", 
                                           "修改管理员密码，ID: " + id, request.getRemoteAddr());
                log.setHmacSignature(CryptoUtil.generateHmacSm3(log.toString()));
                auditLogDao.addAuditLog(log);
                
                request.setAttribute("message", "密码修改成功");
            } else {
                request.setAttribute("error", "密码修改失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请重试");
        }
        
        listAdmins(request, response);
    }
} 