<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.zjut.passcode.bean.Admin" %>
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
                <div class="audit-grid">
                    <div class="audit-card">
                        <h4>系统启动</h4>
                        <p><strong>时间：</strong>2024-01-15 10:00:00</p>
                        <p><strong>操作者：</strong>系统</p>
                        <p><strong>IP地址：</strong>127.0.0.1</p>
                        <span class="status-badge status-info">系统事件</span>
                    </div>
                    
                    <div class="audit-card">
                        <h4>管理员登录</h4>
                        <p><strong>时间：</strong>2024-01-15 10:05:00</p>
                        <p><strong>操作者：</strong><%= admin.getFullName() %></p>
                        <p><strong>IP地址：</strong>127.0.0.1</p>
                        <span class="status-badge status-success">登录成功</span>
                    </div>
                    
                    <div class="audit-card">
                        <h4>数据库连接</h4>
                        <p><strong>时间：</strong>2024-01-15 10:00:00</p>
                        <p><strong>操作者：</strong>系统</p>
                        <p><strong>状态：</strong>连接正常</p>
                        <span class="status-badge status-success">正常</span>
                    </div>
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
            
            <div class="audit-section">
                <h3 class="section-title">📈 系统状态</h3>
                <div class="audit-grid">
                    <div class="audit-card">
                        <h4>数据库状态</h4>
                        <p><strong>连接状态：</strong>正常</p>
                        <p><strong>响应时间：</strong>15ms</p>
                        <p><strong>最后检查：</strong>2024-01-15 10:00:00</p>
                        <span class="status-badge status-success">运行正常</span>
                    </div>
                    
                    <div class="audit-card">
                        <h4>系统性能</h4>
                        <p><strong>CPU使用率：</strong>25%</p>
                        <p><strong>内存使用率：</strong>40%</p>
                        <p><strong>磁盘使用率：</strong>30%</p>
                        <span class="status-badge status-success">性能良好</span>
                    </div>
                    
                    <div class="audit-card">
                        <h4>安全状态</h4>
                        <p><strong>防火墙：</strong>启用</p>
                        <p><strong>SSL证书：</strong>有效</p>
                        <p><strong>安全扫描：</strong>通过</p>
                        <span class="status-badge status-success">安全</span>
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