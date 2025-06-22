<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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
            max-width: 600px;
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
            margin-bottom: 20px;
            font-size: 1.1em;
            line-height: 1.6;
        }
        
        .error-details {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            text-align: left;
        }
        
        .error-details h4 {
            color: #495057;
            margin-bottom: 10px;
            font-size: 1.1em;
        }
        
        .error-details p {
            color: #6c757d;
            margin: 5px 0;
            font-size: 0.95em;
        }
        
        .error-type {
            display: inline-block;
            background: #dc3545;
            color: white;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85em;
            margin-bottom: 15px;
        }
        
        .timestamp {
            color: #6c757d;
            font-size: 0.9em;
            margin-bottom: 20px;
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
        
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-2px);
        }
        
        .error-code {
            font-family: 'Courier New', monospace;
            background: #f1f3f4;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
            font-size: 0.9em;
            color: #333;
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
        
        <% 
        String errorMessage = (String) request.getAttribute("error");
        String errorDetails = (String) request.getAttribute("errorDetails");
        String errorType = (String) request.getAttribute("errorType");
        String currentTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        %>
        
        <div class="error-message">
            <% if (errorMessage != null) { %>
                <%= errorMessage %>
            <% } else { %>
                系统发生未知错误，请稍后重试。
            <% } %>
        </div>
        
        <% if (errorType != null) { %>
            <div class="error-type">
                错误类型: <%= getErrorTypeDescription(errorType) %>
            </div>
        <% } %>
        
        <div class="timestamp">
            发生时间: <%= currentTime %>
        </div>
        
        <% if (errorDetails != null && !errorDetails.trim().isEmpty()) { %>
            <div class="error-details">
                <h4>🔍 错误详情</h4>
                <p><%= errorDetails %></p>
                
                <% if (errorType != null) { %>
                    <h4>💡 解决建议</h4>
                    <p><%= getErrorSolution(errorType) %></p>
                <% } %>
            </div>
        <% } %>
        
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                🏠 返回首页
            </a>
            <a href="javascript:history.back()" class="btn btn-secondary">
                🔙 返回上页
            </a>
            <% if ("DATABASE_CONNECTION".equals(errorType) || "UNKNOWN_ERROR".equals(errorType)) { %>
                <a href="javascript:location.reload()" class="btn btn-danger">
                    🔄 重新加载
                </a>
            <% } %>
        </div>
    </div>
    
    <%!
    private String getErrorTypeDescription(String errorType) {
        switch (errorType) {
            case "INPUT_VALIDATION":
                return "输入验证错误";
            case "USER_NOT_FOUND":
                return "用户不存在";
            case "PASSWORD_MISMATCH":
                return "密码不匹配";
            case "ACCOUNT_LOCKED":
                return "账户被锁定";
            case "DATABASE_CONNECTION":
                return "数据库连接错误";
            case "PASSWORD_ENCRYPTION":
                return "密码加密错误";
            case "LOCKOUT_ERROR":
                return "账户锁定错误";
            case "UNKNOWN_ERROR":
                return "未知错误";
            default:
                return "系统错误";
        }
    }
    
    private String getErrorSolution(String errorType) {
        switch (errorType) {
            case "INPUT_VALIDATION":
                return "请检查输入的用户名和密码是否完整，确保没有多余的空格。";
            case "USER_NOT_FOUND":
                return "请确认用户名是否正确，或联系系统管理员创建账户。";
            case "PASSWORD_MISMATCH":
                return "请确认密码是否正确，注意大小写。如果忘记密码，请联系系统管理员重置。";
            case "ACCOUNT_LOCKED":
                return "账户因多次登录失败被锁定，请等待锁定时间结束后再试，或联系系统管理员解锁。";
            case "DATABASE_CONNECTION":
                return "系统暂时无法连接数据库，请稍后重试。如果问题持续存在，请联系技术支持。";
            case "PASSWORD_ENCRYPTION":
                return "密码处理过程中出现技术问题，请稍后重试。如果问题持续存在，请联系技术支持。";
            case "LOCKOUT_ERROR":
                return "账户锁定过程中出现错误，请联系系统管理员处理。";
            case "UNKNOWN_ERROR":
                return "系统发生未知错误，请稍后重试。如果问题持续存在，请联系技术支持并提供错误详情。";
            default:
                return "请稍后重试，如果问题持续存在，请联系技术支持。";
        }
    }
    %>
</body>
</html> 