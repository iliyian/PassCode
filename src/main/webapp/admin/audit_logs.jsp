<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.zjut.passcode.bean.Admin" %>
<%@ page import="com.zjut.passcode.bean.AuditLog" %>
<%@ page import="java.util.List" %>
<%
    // Check if admin is logged in
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login");
        return;
    }
    
    List<AuditLog> auditLogs = (List<AuditLog>) request.getAttribute("auditLogs");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>审计日志 - 校园通行码系统</title>
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
        
        .logs-content {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .logs-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .logs-table th,
        .logs-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        .logs-table th {
            background: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        
        .logs-table tr:hover {
            background: #f8f9fa;
        }
        
        .action-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
        }
        
        .action-login {
            background: #d4edda;
            color: #155724;
        }
        
        .action-logout {
            background: #f8d7da;
            color: #721c24;
        }
        
        .action-system-error {
            background: #fff3cd;
            color: #856404;
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
            
            .logs-table {
                font-size: 0.9em;
            }
            
            .logs-table th,
            .logs-table td {
                padding: 8px 4px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">📊 审计日志系统</div>
        <div class="user-info">
            <div class="user-name">
                管理员：<%= admin.getFullName() %>
            </div>
            <a href="${pageContext.request.contextPath}/admin/index.jsp" class="back-btn">🔙 返回控制台</a>
        </div>
    </div>
    
    <div class="container">
        <div class="page-title">
            <div class="title">审计日志</div>
            <div class="subtitle">查看系统操作和登录日志</div>
        </div>
        
        <div class="logs-content">
            <% if (auditLogs != null && !auditLogs.isEmpty()) { %>
                <table class="logs-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>管理员</th>
                            <th>操作</th>
                            <th>详情</th>
                            <th>IP地址</th>
                            <th>时间</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (AuditLog log : auditLogs) { %>
                            <tr>
                                <td><%= log.getId() %></td>
                                <td><%= log.getAdminName() %></td>
                                <td>
                                    <span class="action-badge action-<%= getActionClass(log.getAction()) %>">
                                        <%= log.getAction() %>
                                    </span>
                                </td>
                                <td><%= log.getDetails() %></td>
                                <td><%= log.getIpAddress() %></td>
                                <td><%= log.getCreatedAt() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <h3>暂无审计日志</h3>
                    <p>当前系统中没有审计日志记录</p>
                </div>
            <% } %>
        </div>
    </div>
    
    <%!
    private String getActionClass(String action) {
        if (action.contains("登录")) {
            return "login";
        } else if (action.contains("退出")) {
            return "logout";
        } else if (action.contains("错误") || action.contains("Error")) {
            return "system-error";
        } else {
            return "login";
        }
    }
    %>
</body>
</html> 