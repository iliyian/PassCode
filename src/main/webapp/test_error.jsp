<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>错误处理测试 - 校园通行码系统</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        .test-section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #e9ecef;
            border-radius: 10px;
        }
        .test-section h3 {
            color: #333;
            margin-bottom: 15px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 5px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s ease;
        }
        .btn:hover {
            background: #5a6fd8;
            transform: translateY(-2px);
        }
        .btn-danger {
            background: #dc3545;
        }
        .btn-danger:hover {
            background: #c82333;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔧 错误处理测试页面</h1>
        <p>这个页面用于测试各种错误情况的处理。</p>
        
        <div class="test-section">
            <h3>📋 登录错误测试</h3>
            <p>测试不同类型的登录错误：</p>
            <a href="test_error.jsp?error=INPUT_VALIDATION" class="btn">输入验证错误</a>
            <a href="test_error.jsp?error=USER_NOT_FOUND" class="btn">用户不存在</a>
            <a href="test_error.jsp?error=PASSWORD_MISMATCH" class="btn">密码不匹配</a>
            <a href="test_error.jsp?error=ACCOUNT_LOCKED" class="btn">账户被锁定</a>
        </div>
        
        <div class="test-section">
            <h3>🔧 系统错误测试</h3>
            <p>测试系统级别的错误：</p>
            <a href="test_error.jsp?error=DATABASE_CONNECTION" class="btn btn-danger">数据库连接错误</a>
            <a href="test_error.jsp?error=PASSWORD_ENCRYPTION" class="btn btn-danger">密码加密错误</a>
            <a href="test_error.jsp?error=UNKNOWN_ERROR" class="btn btn-danger">未知错误</a>
        </div>
        
        <div class="test-section">
            <h3>🔗 页面跳转测试</h3>
            <p>测试页面跳转功能：</p>
            <a href="${pageContext.request.contextPath}/" class="btn">返回首页</a>
            <a href="${pageContext.request.contextPath}/admin/login" class="btn">管理员登录</a>
        </div>
        
        <% 
        String errorType = request.getParameter("error");
        if (errorType != null) {
            request.setAttribute("error", getErrorMessage(errorType));
            request.setAttribute("errorDetails", getErrorDetails(errorType));
            request.setAttribute("errorType", errorType);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
        %>
    </div>
    
    <%!
    private String getErrorMessage(String errorType) {
        switch (errorType) {
            case "INPUT_VALIDATION":
                return "用户名和密码不能为空";
            case "USER_NOT_FOUND":
                return "用户名或密码错误";
            case "PASSWORD_MISMATCH":
                return "用户名或密码错误";
            case "ACCOUNT_LOCKED":
                return "账户已被锁定，请稍后再试";
            case "DATABASE_CONNECTION":
                return "系统暂时无法连接数据库，请稍后重试";
            case "PASSWORD_ENCRYPTION":
                return "密码处理失败，请稍后重试";
            case "UNKNOWN_ERROR":
                return "系统发生未知错误，请稍后重试";
            default:
                return "系统发生错误";
        }
    }
    
    private String getErrorDetails(String errorType) {
        switch (errorType) {
            case "INPUT_VALIDATION":
                return "请检查输入的用户名和密码是否完整";
            case "USER_NOT_FOUND":
                return "用户名 'testuser' 在系统中不存在";
            case "PASSWORD_MISMATCH":
                return "连续失败次数: 2，剩余尝试次数: 3";
            case "ACCOUNT_LOCKED":
                return "账户锁定截止时间: 2024-01-15 14:30:00";
            case "DATABASE_CONNECTION":
                return "错误详情: Connection refused: connect";
            case "PASSWORD_ENCRYPTION":
                return "密码加密过程出现错误: NoSuchAlgorithmException";
            case "UNKNOWN_ERROR":
                return "错误详情: NullPointerException in AdminLoginServlet";
            default:
                return "未知错误详情";
        }
    }
    %>
</body>
</html> 