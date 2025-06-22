<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.zjut.passcode.bean.Admin" %>
<%@ page import="com.zjut.passcode.bean.Department" %>
<%@ page import="java.util.List" %>
<%
    // Check if admin is logged in
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login");
        return;
    }
    
    List<Department> departments = (List<Department>) request.getAttribute("departments");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>部门管理 - 校园通行码系统</title>
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
        
        .departments-content {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .add-dept-btn {
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
        
        .add-dept-btn:hover {
            background: #218838;
        }
        
        .departments-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .departments-table th,
        .departments-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        .departments-table th {
            background: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        
        .departments-table tr:hover {
            background: #f8f9fa;
        }
        
        .type-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
        }
        
        .type-administrative {
            background: #dc3545;
            color: white;
        }
        
        .type-direct {
            background: #fd7e14;
            color: white;
        }
        
        .type-college {
            background: #28a745;
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
            
            .departments-table {
                font-size: 0.9em;
            }
            
            .departments-table th,
            .departments-table td {
                padding: 8px 4px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">🏢 部门管理系统</div>
        <div class="user-info">
            <div class="user-name">
                管理员：<%= admin.getFullName() %>
            </div>
            <a href="${pageContext.request.contextPath}/admin/index.jsp" class="back-btn">🔙 返回控制台</a>
        </div>
    </div>
    
    <div class="container">
        <div class="page-title">
            <div class="title">部门管理</div>
            <div class="subtitle">管理学校部门和机构信息</div>
        </div>
        
        <div class="departments-content">
            <a href="#" class="add-dept-btn">➕ 添加新部门</a>
            
            <% if (departments != null && !departments.isEmpty()) { %>
                <table class="departments-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>部门编号</th>
                            <th>部门名称</th>
                            <th>部门类型</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Department dept : departments) { %>
                            <tr>
                                <td><%= dept.getId() %></td>
                                <td><%= dept.getDeptNo() %></td>
                                <td><%= dept.getDeptName() %></td>
                                <td>
                                    <span class="type-badge type-<%= getTypeClass(dept.getDeptType()) %>">
                                        <%= dept.getDeptType() %>
                                    </span>
                                </td>
                                <td>
                                    <a href="#" class="action-btn btn-edit">编辑</a>
                                    <a href="#" class="action-btn btn-delete">删除</a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <h3>暂无部门记录</h3>
                    <p>当前系统中没有部门记录</p>
                </div>
            <% } %>
        </div>
    </div>
    
    <%!
    private String getTypeClass(String deptType) {
        switch (deptType) {
            case "行政部门":
                return "administrative";
            case "直属部门":
                return "direct";
            case "学院":
                return "college";
            default:
                return "administrative";
        }
    }
    %>
</body>
</html> 