<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>错误 - 校园通行码系统</title>
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
        
        .error-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 40px;
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        
        .error-icon {
            font-size: 4em;
            margin-bottom: 20px;
            color: #e74c3c;
        }
        
        .error-title {
            font-size: 1.8em;
            color: #333;
            margin-bottom: 15px;
            font-weight: bold;
        }
        
        .error-message {
            color: #666;
            margin-bottom: 30px;
            font-size: 1.1em;
            line-height: 1.6;
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
        
        @media (max-width: 480px) {
            .error-container {
                padding: 30px 20px;
            }
            
            .error-title {
                font-size: 1.5em;
            }
            
            .btn-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <div class="error-title">出错了！</div>
        <div class="error-message">
            <% if (request.getAttribute("error") != null) { %>
                <%= request.getAttribute("error") %>
            <% } else { %>
                系统发生未知错误，请稍后重试。
            <% } %>
        </div>
        
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                🏠 返回首页
            </a>
            <a href="javascript:history.back()" class="btn btn-secondary">
                🔙 返回上页
            </a>
        </div>
    </div>
</body>
</html> 