<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员登录 - 校园通行码系统</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 40px;
            max-width: 400px;
            width: 100%;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .login-icon {
            font-size: 3em;
            margin-bottom: 15px;
        }
        
        .login-title {
            font-size: 1.8em;
            color: #333;
            margin-bottom: 10px;
            font-weight: bold;
        }
        
        .login-subtitle {
            color: #666;
            font-size: 1em;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 1em;
            transition: border-color 0.3s ease;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .password-container {
            position: relative;
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.2em;
            color: #666;
        }
        
        .password-toggle:hover {
            color: #333;
        }
        
        .btn-login {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1em;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-login:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        
        .back-link {
            text-align: center;
        }
        
        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 0.9em;
        }
        
        .back-link a:hover {
            text-decoration: underline;
        }
        
        .message {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 500;
        }
        
        .message-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .message-warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .security-info {
            background: #e7f3ff;
            color: #0c5460;
            padding: 15px;
            border-radius: 10px;
            margin-top: 20px;
            font-size: 0.9em;
            border: 1px solid #bee5eb;
        }
        
        .security-info h4 {
            margin-bottom: 10px;
            font-size: 1em;
        }
        
        .security-info ul {
            list-style: none;
            padding-left: 0;
        }
        
        .security-info li {
            margin-bottom: 5px;
            padding-left: 20px;
            position: relative;
        }
        
        .security-info li:before {
            content: "🔒";
            position: absolute;
            left: 0;
        }
        
        @media (max-width: 480px) {
            .login-container {
                padding: 30px 20px;
            }
            
            .login-title {
                font-size: 1.5em;
            }
            
            .login-icon {
                font-size: 2.5em;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <div class="login-icon">🔐</div>
            <div class="login-title">管理员登录</div>
            <div class="login-subtitle">校园通行码管理系统</div>
        </div>
        
        <!-- 错误消息 -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="message message-error">
                ❌ <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <!-- 警告消息 -->
        <% if (request.getAttribute("warning") != null) { %>
            <div class="message message-warning">
                ⚠️ <%= request.getAttribute("warning") %>
            </div>
        <% } %>
        
                <form action="${pageContext.request.contextPath}/admin/login" method="post">
            <div class="form-group">
                <label for="loginName">用户名</label>
                <input type="text" id="loginName" name="loginName" required 
                       placeholder="请输入登录用户名">
            </div>
            
            <div class="form-group">
                <label for="password">密码</label>
                <div class="password-container">
                    <input type="password" id="password" name="password" required 
                           placeholder="请输入密码">
                    <button type="button" class="password-toggle" onclick="togglePassword()">
                        👁️
                    </button>
                </div>
            </div>
            
            <button type="submit" class="btn-login" id="loginBtn">
                🔑 登录
            </button>
        </form>
        
        <div class="back-link">
            <a href="${pageContext.request.contextPath}/">← 返回首页</a>
        </div>
        
        <div class="security-info">
            <h4>🔒 安全提示</h4>
            <ul>
                <li>密码长度至少8位，包含数字、大小写字母、特殊字符</li>
                <li>连续登录失败5次将锁定账户30分钟</li>
                <li>密码90天过期，请及时修改</li>
                <li>登录超时30分钟自动退出</li>
            </ul>
        </div>
    </div>
    
    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleBtn = document.querySelector('.password-toggle');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleBtn.textContent = '🙈';
            } else {
                passwordInput.type = 'password';
                toggleBtn.textContent = '👁️';
            }
        }
        
        // 表单提交时禁用按钮防止重复提交
        document.querySelector('form').addEventListener('submit', function() {
            const loginBtn = document.getElementById('loginBtn');
            loginBtn.disabled = true;
            loginBtn.textContent = '⏳ 登录中...';
        });
        
        // 自动聚焦到用户名输入框
        window.onload = function() {
            document.getElementById('loginName').focus();
        };
    </script>
</body>
</html>