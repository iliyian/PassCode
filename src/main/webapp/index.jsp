<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园通行码预约管理系统</title>
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
        }
        
        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 40px;
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        
        .logo {
            font-size: 2.5em;
            color: #333;
            margin-bottom: 20px;
            font-weight: bold;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 40px;
            font-size: 1.1em;
        }
        
        .qr-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .qr-title {
            font-size: 1.3em;
            color: #333;
            margin-bottom: 20px;
        }
        
        .qr-code {
            width: 200px;
            height: 200px;
            background: #ddd;
            margin: 0 auto 20px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9em;
            color: #666;
        }
        
        .btn-group {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 1.1em;
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
        
        .admin-link {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .admin-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 0.9em;
        }
        
        .admin-link a:hover {
            text-decoration: underline;
        }
        
        @media (max-width: 480px) {
            .container {
                padding: 20px;
            }
            
            .logo {
                font-size: 2em;
            }
            
            .btn {
                padding: 12px 20px;
                font-size: 1em;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">🏫 校园通行码</div>
        <div class="subtitle">预约管理系统</div>
        
        <div class="qr-section">
            <div class="qr-title">📱 扫码预约</div>
            <div class="qr-code">
                预约通道二维码<br>
                (200×200px)
            </div>
            <p style="color: #666; font-size: 0.9em;">
                扫描二维码进入预约系统<br>
                或点击下方按钮直接访问
            </p>
        </div>
        
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/appointment/apply" class="btn btn-primary">
                📝 我要预约
            </a>
            <a href="${pageContext.request.contextPath}/appointment/query" class="btn btn-secondary">
                📋 我的预约
            </a>
        </div>
        
        <div class="admin-link">
            <a href="${pageContext.request.contextPath}/admin/login">管理员登录</a>
        </div>
    </div>
</body>
</html>