<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.zjut.passcode.bean.Admin" %>
<%
    Admin user = (Admin) request.getAttribute("resetUser");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>重置管理员密码 - 校园通行码系统</title>
    <style>
        body { font-family: 'Microsoft YaHei', Arial, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; }
        .container { max-width: 500px; margin: 40px auto; background: #fff; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); padding: 40px; }
        h2 { text-align: center; margin-bottom: 30px; }
        label { display: block; margin-bottom: 8px; color: #333; }
        input { width: 100%; padding: 10px; margin-bottom: 20px; border-radius: 5px; border: 1px solid #ccc; }
        .btn { background: #17a2b8; color: #fff; border: none; padding: 10px 30px; border-radius: 5px; cursor: pointer; font-size: 1em; }
        .btn-cancel { background: #6c757d; margin-left: 10px; }
        .error { color: #dc3545; margin-bottom: 10px; }
        .message { color: #28a745; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>重置管理员密码</h2>
        <form method="post" action="<%=request.getContextPath()%>/admin/users">
            <input type="hidden" name="action" value="resetPwd" />
            <input type="hidden" name="userId" value="<%= user.getId() %>" />
            <div>
                <label>管理员姓名：</label>
                <input type="text" value="<%= user.getFullName() %>" disabled />
            </div>
            <div>
                <label>新密码：</label>
                <input type="password" name="newPassword" required />
                <span style="color:#888;font-size:0.9em;">密码需8位以上，含数字、大小写字母、特殊字符</span>
            </div>
            <% if (request.getAttribute("error") != null) { %>
                <div class="error">错误：<%=request.getAttribute("error")%></div>
            <% } %>
            <% if (request.getAttribute("message") != null) { %>
                <div class="message">提示：<%=request.getAttribute("message")%></div>
            <% } %>
            <button type="submit" class="btn">重置密码</button>
            <a href="<%=request.getContextPath()%>/admin/users" class="btn btn-cancel">取消</a>
        </form>
    </div>
</body>
</html> 