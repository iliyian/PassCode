<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.zjut.passcode.bean.Admin" %>
<%@ page import="java.util.List" %>
<%
    // Check if admin is logged in
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login");
        return;
    }
    
    List<Admin> admins = (List<Admin>) request.getAttribute("admins");
    Admin currentAdmin = (Admin) request.getAttribute("currentAdmin");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - 校园通行码系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .header {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 1.5em;
            font-weight: bold;
            color: #333;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-name {
            color: #333;
            font-weight: 500;
        }
        
        .back-btn {
            background: #6c757d;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9em;
        }
        
        .back-btn:hover {
            background: #5a6268;
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .page-title {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .title {
            font-size: 2em;
            color: #333;
            margin-bottom: 10px;
        }
        
        .subtitle {
            color: #666;
            font-size: 1.1em;
        }
        
        .users-content {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .add-user-btn {
            background: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            margin-bottom: 20px;
            text-decoration: none;
            display: inline-block;
        }
        
        .add-user-btn:hover {
            background: #218838;
        }
        
        .users-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .users-table th,
        .users-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        .users-table th {
            background: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        
        .users-table tr:hover {
            background: #f8f9fa;
        }
        
        .role-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
        }
        
        .role-system-admin {
            background: #dc3545;
            color: white;
        }
        
        .role-school-admin {
            background: #fd7e14;
            color: white;
        }
        
        .role-dept-admin {
            background: #ffc107;
            color: #212529;
        }
        
        .role-audit-admin {
            background: #17a2b8;
            color: white;
        }
        
        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.8em;
            margin: 2px;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-edit {
            background: #17a2b8;
            color: white;
        }
        
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        
        .btn-reset-pwd {
            background: #6c757d;
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .empty-state h3 {
            margin-bottom: 10px;
            color: #333;
        }
        
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
            }
            
            .user-info {
                flex-direction: column;
                gap: 10px;
            }
            
            .title {
                font-size: 1.5em;
            }
            
            .users-table {
                font-size: 0.9em;
            }
            
            .users-table th,
            .users-table td {
                padding: 8px 4px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">👥 用户管理系统</div>
        <div class="user-info">
            <div class="user-name">
                管理员：<%= currentAdmin.getFullName() %>
            </div>
            <a href="${pageContext.request.contextPath}/admin/index.jsp" class="back-btn">🔙 返回控制台</a>
        </div>
    </div>
    
    <div class="container">
        <div class="page-title">
            <div class="title">用户管理</div>
            <div class="subtitle">管理系统用户和管理员账户</div>
        </div>
        
        <div class="users-content">
            <a href="#" class="add-user-btn">➕ 添加新用户</a>
            
            <% if (admins != null && !admins.isEmpty()) { %>
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>登录名</th>
                            <th>姓名</th>
                            <th>角色</th>
                            <th>部门</th>
                            <th>联系电话</th>
                            <th>最后登录</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Admin user : admins) { %>
                            <tr>
                                <td><%= user.getId() %></td>
                                <td><%= user.getLoginName() %></td>
                                <td><%= user.getFullName() %></td>
                                <td>
                                    <span class="role-badge role-<%= user.getRole().toLowerCase().replace("_", "-") %>">
                                        <%= getRoleDisplayName(user.getRole()) %>
                                    </span>
                                </td>
                                <td><%= user.getDeptName() != null ? user.getDeptName() : "未分配" %></td>
                                <td><%= user.getPhone() != null ? user.getPhone() : "未设置" %></td>
                                <td><%= user.getPasswordLastChanged() != null ? user.getPasswordLastChanged() : "从未登录" %></td>
                                <td>
                                    <% if (user.getLockoutUntil() != null) { %>
                                        <span style="color: #dc3545;">已锁定</span>
                                    <% } else { %>
                                        <span style="color: #28a745;">正常</span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="#" class="action-btn btn-edit">编辑</a>
                                    <a href="#" class="action-btn btn-reset-pwd">重置密码</a>
                                    <% if (user.getId() != currentAdmin.getId()) { %>
                                        <a href="#" class="action-btn btn-delete">删除</a>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <h3>暂无用户记录</h3>
                    <p>当前系统中没有用户记录</p>
                </div>
            <% } %>
        </div>
    </div>
    
    <%!
    private String getRoleDisplayName(String role) {
        switch (role) {
            case "SYSTEM_ADMIN":
                return "系统管理员";
            case "SCHOOL_ADMIN":
                return "学校管理员";
            case "DEPT_ADMIN":
                return "部门管理员";
            case "AUDIT_ADMIN":
                return "审计管理员";
            default:
                return role;
        }
    }
    %>
</body>
</html> 