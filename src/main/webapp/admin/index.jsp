<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.zjut.passcode.bean.Admin" %>
<%
    // Check if admin is logged in
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员控制台 - 校园通行码系统</title>
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
        
        .logout-btn {
            background: #dc3545;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9em;
        }
        
        .logout-btn:hover {
            background: #c82333;
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .welcome-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .welcome-title {
            font-size: 2em;
            color: #333;
            margin-bottom: 10px;
        }
        
        .welcome-subtitle {
            color: #666;
            font-size: 1.1em;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-icon {
            font-size: 2.5em;
            margin-bottom: 15px;
        }
        
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .stat-label {
            color: #666;
            font-size: 1em;
        }
        
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .action-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }
        
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }
        
        .action-icon {
            font-size: 3em;
            margin-bottom: 15px;
        }
        
        .action-title {
            font-size: 1.3em;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .action-description {
            color: #666;
            font-size: 0.95em;
            line-height: 1.5;
        }
        
        .role-badge {
            background: #667eea;
            color: white;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.8em;
            margin-left: 10px;
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
            
            .welcome-title {
                font-size: 1.5em;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .actions-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">🏫 校园通行码管理系统</div>
        <div class="user-info">
            <div class="user-name">
                欢迎，<%= admin.getFullName() %>
                <span class="role-badge"><%= getRoleDisplayName(admin.getRole()) %></span>
            </div>
            <a href="${pageContext.request.contextPath}/admin/logout" class="logout-btn">🚪 退出登录</a>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome-card">
            <div class="welcome-title">欢迎使用管理员控制台</div>
            <div class="welcome-subtitle">
                当前时间：<span id="current-time"></span> | 
                登录时间：<%= session.getAttribute("loginTime") != null ? session.getAttribute("loginTime") : "未知" %>
            </div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">📋</div>
                <div class="stat-number">0</div>
                <div class="stat-label">待审核预约</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">✅</div>
                <div class="stat-number">0</div>
                <div class="stat-label">已审核预约</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-number">0</div>
                <div class="stat-label">今日访客</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📊</div>
                <div class="stat-number">0</div>
                <div class="stat-label">系统日志</div>
            </div>
        </div>
        
        <div class="actions-grid">
            <% if ("SYSTEM_ADMIN".equals(admin.getRole())) { %>
                <a href="${pageContext.request.contextPath}/admin/users" class="action-card">
                    <div class="action-icon">👥</div>
                    <div class="action-title">用户管理</div>
                    <div class="action-description">管理系统用户和管理员账户</div>
                </a>
            <% } else if ("AUDIT_ADMIN".equals(admin.getRole())) { %>
                <a href="${pageContext.request.contextPath}/admin/audit_logs" class="action-card">
                    <div class="action-icon">📊</div>
                    <div class="action-title">审计日志</div>
                    <div class="action-description">查看系统操作和登录日志</div>
                </a>
            <% } else if ("SCHOOL_ADMIN".equals(admin.getRole())) { %>
                <a href="${pageContext.request.contextPath}/admin/users" class="action-card">
                    <div class="action-icon">👥</div>
                    <div class="action-title">用户管理</div>
                    <div class="action-description">仅管理部门管理员账户</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/appointments" class="action-card">
                    <div class="action-icon">📋</div>
                    <div class="action-title">预约管理</div>
                    <div class="action-description">审核社会公众预约和公务预约</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/departments" class="action-card">
                    <div class="action-icon">🏢</div>
                    <div class="action-title">部门管理</div>
                    <div class="action-description">管理所有学校部门和机构信息</div>
                </a>
            <% } else if ("DEPT_ADMIN".equals(admin.getRole())) { %>
                <a href="${pageContext.request.contextPath}/admin/appointments" class="action-card">
                    <div class="action-icon">📋</div>
                    <div class="action-title">预约管理</div>
                    <div class="action-description">仅能管理本部门社会公众预约，管理公务预约需学校管理员授权</div>
                </a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/admin/appointments" class="action-card">
                    <div class="action-icon">📋</div>
                    <div class="action-title">预约管理</div>
                    <div class="action-description">查看、审核和管理访客预约申请</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="action-card">
                    <div class="action-icon">👥</div>
                    <div class="action-title">用户管理</div>
                    <div class="action-description">管理系统用户和管理员账户</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/departments" class="action-card">
                    <div class="action-icon">🏢</div>
                    <div class="action-title">部门管理</div>
                    <div class="action-description">管理学校部门和机构信息</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/audit_logs" class="action-card">
                    <div class="action-icon">📊</div>
                    <div class="action-title">审计日志</div>
                    <div class="action-description">查看系统操作和登录日志</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/reports" class="action-card">
                    <div class="action-icon">📈</div>
                    <div class="action-title">统计报告</div>
                    <div class="action-description">查看系统使用统计和报告</div>
                </a>
            <% } %>
        </div>
    </div>
    
    <script>
        // Update current time
        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleString('zh-CN');
            document.getElementById('current-time').textContent = timeString;
        }
        
        // Update time every second
        updateTime();
        setInterval(updateTime, 1000);
        
        // Auto logout after 30 minutes of inactivity
        let inactivityTimer;
        function resetInactivityTimer() {
            clearTimeout(inactivityTimer);
            inactivityTimer = setTimeout(() => {
                alert('登录超时，即将退出系统');
                window.location.href = '${pageContext.request.contextPath}/admin/login';
            }, 30 * 60 * 1000); // 30 minutes
        }
        
        // Reset timer on user activity
        document.addEventListener('mousemove', resetInactivityTimer);
        document.addEventListener('keypress', resetInactivityTimer);
        document.addEventListener('click', resetInactivityTimer);
        
        // Start timer
        resetInactivityTimer();
    </script>
    
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
                return "管理员";
        }
    }
    %>
</body>
</html> 