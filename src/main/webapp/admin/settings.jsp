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
    <title>系统设置 - 校园通行码系统</title>
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
        
        .settings-content {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .settings-section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #e9ecef;
            border-radius: 10px;
        }
        
        .section-title {
            font-size: 1.3em;
            color: #333;
            margin-bottom: 15px;
            font-weight: bold;
        }
        
        .setting-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f8f9fa;
        }
        
        .setting-item:last-child {
            border-bottom: none;
        }
        
        .setting-label {
            font-weight: 500;
            color: #333;
        }
        
        .setting-value {
            color: #666;
        }
        
        .setting-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
        }
        
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
        }
        
        .slider:before {
            position: absolute;
            content: "";
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        input:checked + .slider {
            background-color: #2196F3;
        }
        
        input:checked + .slider:before {
            transform: translateX(26px);
        }
        
        .save-btn {
            background: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            margin-top: 20px;
        }
        
        .save-btn:hover {
            background: #218838;
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
            
            .setting-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">⚙️ 系统设置</div>
        <div class="user-info">
            <div class="user-name">
                管理员：<%= admin.getFullName() %>
            </div>
            <a href="${pageContext.request.contextPath}/admin/index.jsp" class="back-btn">🔙 返回控制台</a>
        </div>
    </div>
    
    <div class="container">
        <div class="page-title">
            <div class="title">系统设置</div>
            <div class="subtitle">配置系统参数和安全设置</div>
        </div>
        
        <div class="settings-content">
            <form>
                <div class="settings-section">
                    <div class="section-title">安全设置</div>
                    <div class="setting-item">
                        <div class="setting-label">密码过期时间</div>
                        <div class="setting-control">
                            <input type="number" value="90" min="30" max="365" style="width: 80px; padding: 5px;">
                            <span>天</span>
                        </div>
                    </div>
                    <div class="setting-item">
                        <div class="setting-label">登录失败锁定</div>
                        <div class="setting-control">
                            <label class="toggle-switch">
                                <input type="checkbox" checked>
                                <span class="slider"></span>
                            </label>
                            <span>启用</span>
                        </div>
                    </div>
                    <div class="setting-item">
                        <div class="setting-label">锁定时间</div>
                        <div class="setting-control">
                            <input type="number" value="30" min="5" max="1440" style="width: 80px; padding: 5px;">
                            <span>分钟</span>
                        </div>
                    </div>
                </div>
                
                <div class="settings-section">
                    <div class="section-title">会话设置</div>
                    <div class="setting-item">
                        <div class="setting-label">会话超时时间</div>
                        <div class="setting-control">
                            <input type="number" value="30" min="5" max="480" style="width: 80px; padding: 5px;">
                            <span>分钟</span>
                        </div>
                    </div>
                    <div class="setting-item">
                        <div class="setting-label">强制单点登录</div>
                        <div class="setting-control">
                            <label class="toggle-switch">
                                <input type="checkbox">
                                <span class="slider"></span>
                            </label>
                            <span>禁用</span>
                        </div>
                    </div>
                </div>
                
                <div class="settings-section">
                    <div class="section-title">日志设置</div>
                    <div class="setting-item">
                        <div class="setting-label">日志保留时间</div>
                        <div class="setting-control">
                            <input type="number" value="90" min="30" max="365" style="width: 80px; padding: 5px;">
                            <span>天</span>
                        </div>
                    </div>
                    <div class="setting-item">
                        <div class="setting-label">详细日志记录</div>
                        <div class="setting-control">
                            <label class="toggle-switch">
                                <input type="checkbox" checked>
                                <span class="slider"></span>
                            </label>
                            <span>启用</span>
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="save-btn">💾 保存设置</button>
            </form>
        </div>
    </div>
</body>
</html> 