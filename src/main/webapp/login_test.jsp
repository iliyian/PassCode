<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录测试 - 校园通行码系统</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .test-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 40px;
            max-width: 600px;
            width: 100%;
            text-align: center;
        }
        
        .test-title {
            font-size: 2em;
            color: #333;
            margin-bottom: 20px;
        }
        
        .test-info {
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .test-accounts {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .test-accounts h3 {
            color: #333;
            margin-bottom: 15px;
        }
        
        .account-item {
            margin-bottom: 10px;
            padding: 10px;
            background: white;
            border-radius: 5px;
            border-left: 4px solid #667eea;
        }
        
        .account-item strong {
            color: #333;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        .status-info {
            background: #e7f3ff;
            color: #0c5460;
            padding: 15px;
            border-radius: 10px;
            margin-top: 20px;
            border: 1px solid #bee5eb;
        }
    </style>
</head>
<body>
    <div class="test-container">
        <div class="test-title">🔐 登录功能测试</div>
        <div class="test-info">
            这个页面用于测试管理员登录功能。请使用以下测试账号进行登录测试。
        </div>
        
        <div class="test-accounts">
            <h3>📋 测试账号信息</h3>
            <div class="account-item">
                <strong>系统管理员：</strong>admin / Admin@123
            </div>
            <div class="account-item">
                <strong>学校管理员：</strong>school_admin / Admin@123
            </div>
            <div class="account-item">
                <strong>部门管理员：</strong>dept_admin / Admin@123
            </div>
            <div class="account-item">
                <strong>审计管理员：</strong>audit_admin / Admin@123
            </div>
        </div>
        
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/admin/login" class="btn btn-primary">
                🔑 开始登录测试
            </a>
            <a href="${pageContext.request.contextPath}/test_error.jsp" class="btn btn-secondary">
                ⚠️ 错误处理测试
            </a>
        </div>
        
        <div class="status-info">
            <h4>💡 测试说明</h4>
            <ul style="text-align: left; margin: 10px 0;">
                <li>所有账号的密码都是：Admin@123</li>
                <li>系统管理员和学校管理员会跳转到管理员控制台</li>
                <li>审计管理员会跳转到审计日志管理页面</li>
                <li>可以尝试输入错误密码测试错误处理功能</li>
                <li>连续失败5次会锁定账户30分钟</li>
            </ul>
        </div>
    </div>
</body>
</html> 