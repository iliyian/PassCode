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
    
    // Check if user has audit admin role
    if (!"AUDIT_ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>审计日志管理 - 校园通行码系统</title>
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
        
        .audit-content {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .audit-section {
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 1.5em;
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }
        
        .audit-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .audit-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            border-left: 4px solid #667eea;
        }
        
        .audit-card h4 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .audit-card p {
            color: #666;
            margin-bottom: 5px;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
        }
        
        .status-success {
            background: #d4edda;
            color: #155724;
        }
        
        .status-warning {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-danger {
            background: #f8d7da;
            color: #721c24;
        }
        
        .status-info {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            border: 1px solid #e9ecef;
        }
        
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.9em;
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
            
            .audit-grid {
                grid-template-columns: 1fr;
            }
            
            .stats-overview {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">📊 审计日志管理系统</div>
        <div class="user-info">
            <div class="user-name">
                审计管理员：<%= admin.getFullName() %>
            </div>
            <a href="${pageContext.request.contextPath}/admin/index.jsp" class="back-btn">🔙 返回控制台</a>
        </div>
    </div>
    
    <div class="container">
        <div class="page-title">
            <div class="title">审计日志管理</div>
            <div class="subtitle">监控系统安全，查看操作日志</div>
        </div>
        
        <div class="stats-overview">
            <div class="stat-item">
                <div class="stat-number">0</div>
                <div class="stat-label">今日登录</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">0</div>
                <div class="stat-label">登录失败</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">0</div>
                <div class="stat-label">系统错误</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">0</div>
                <div class="stat-label">安全事件</div>
            </div>
        </div>
        
        <div class="audit-content">
            <div class="audit-section">
                <h3 class="section-title">🔍 最近审计事件</h3>
                <%-- 分页表格 --%>
                <% List auditLogs = (List)request.getAttribute("auditLogs"); %>
                <% Integer page = (Integer)request.getAttribute("page"); %>
                <% Integer totalPages = (Integer)request.getAttribute("totalPages"); %>
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
                        <% if (auditLogs != null && !auditLogs.isEmpty()) {
                            for (Object obj : auditLogs) {
                                com.zjut.passcode.bean.AuditLog log = (com.zjut.passcode.bean.AuditLog)obj; %>
                        <tr>
                            <td><%= log.getId() %></td>
                            <td><%= log.getAdminName() %></td>
                            <td><%= log.getAction() %></td>
                            <td><%= log.getDetails() %></td>
                            <td><%= log.getIpAddress() %></td>
                            <td><%= log.getCreatedAt() %></td>
                        </tr>
                        <%   }
                        } else { %>
                        <tr><td colspan="6" style="text-align:center;">暂无审计日志</td></tr>
                        <% } %>
                    </tbody>
                </table>
                <%-- 分页控件 --%>
                <div style="margin:20px 0;text-align:center;">
                    <% if (totalPages != null && totalPages > 1) { %>
                        <% for (int i = 1; i <= totalPages; i++) { %>
                            <% if (i == page) { %>
                                <span style="margin:0 5px;font-weight:bold;"><%=i%></span>
                            <% } else { %>
                                <a href="?page=<%=i%>" style="margin:0 5px;">[<%=i%>]</a>
                            <% } %>
                        <% } %>
                    <% } %>
                </div>
            </div>
            <div class="audit-section">
                <h3 class="section-title">⚠️ 安全警告</h3>
                <div class="audit-grid">
                    <div class="audit-card">
                        <h4>密码过期提醒</h4>
                        <p><strong>用户：</strong>admin</p>
                        <p><strong>过期时间：</strong>2024-04-15</p>
                        <p><strong>建议：</strong>请及时修改密码</p>
                        <span class="status-badge status-warning">需要关注</span>
                    </div>
                    <div class="audit-card">
                        <h4>登录尝试</h4>
                        <p><strong>用户：</strong>unknown_user</p>
                        <p><strong>时间：</strong>2024-01-15 09:55:00</p>
                        <p><strong>结果：</strong>用户不存在</p>
                        <span class="status-badge status-danger">登录失败</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Auto refresh every 30 seconds
        setTimeout(() => {
            location.reload();
        }, 30000);
        
        // Update current time
        function updateTime() {
            const now = new Date();
            console.log('Current time: ' + now.toLocaleString('zh-CN'));
        }
        
        updateTime();
        setInterval(updateTime, 60000); // Update every minute
    </script>
</body>
</html> 