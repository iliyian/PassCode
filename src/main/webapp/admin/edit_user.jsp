<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.zjut.passcode.bean.Admin" %>
<%@ page import="java.util.List" %>
<%
    Admin user = (Admin) request.getAttribute("editUser");
    List deptList = (List)request.getAttribute("departments");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑管理员 - 校园通行码系统</title>
    <style>
        body { font-family: 'Microsoft YaHei', Arial, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; }
        .container { max-width: 600px; margin: 40px auto; background: #fff; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); padding: 40px; }
        h2 { text-align: center; margin-bottom: 30px; }
        label { display: block; margin-bottom: 8px; color: #333; }
        input, select { width: 100%; padding: 10px; margin-bottom: 20px; border-radius: 5px; border: 1px solid #ccc; }
        .btn { background: #28a745; color: #fff; border: none; padding: 10px 30px; border-radius: 5px; cursor: pointer; font-size: 1em; }
        .btn-cancel { background: #6c757d; margin-left: 10px; }
        .error { color: #dc3545; margin-bottom: 10px; }
        .message { color: #28a745; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>编辑管理员</h2>
        <form method="post" action="<%=request.getContextPath()%>/admin/users">
            <input type="hidden" name="action" value="edit" />
            <input type="hidden" name="userId" value="<%= user.getId() %>" />
            <div>
                <label>登录名：</label>
                <input type="text" name="loginName" value="<%= user.getLoginName() %>" required />
            </div>
            <div>
                <label>姓名：</label>
                <input type="text" name="fullName" value="<%= user.getFullName() %>" required />
            </div>
            <div>
                <label>部门：</label>
                <select name="deptId">
                    <option value="">请选择部门</option>
                    <% if (deptList != null) { for (Object obj : deptList) { com.zjut.passcode.bean.Department dept = (com.zjut.passcode.bean.Department)obj; %>
                        <option value="<%=dept.getId()%>" <%=dept.getId()==user.getDeptId()?"selected":""%>><%=dept.getDeptName()%></option>
                    <% }} %>
                </select>
            </div>
            <div>
                <label>联系电话：</label>
                <input type="text" name="phone" value="<%= user.getPhone() %>" required />
            </div>
            <div>
                <label>角色：</label>
                <select name="role" required>
                    <option value="SYSTEM_ADMIN" <%= "SYSTEM_ADMIN".equals(user.getRole())?"selected":""%>>系统管理员</option>
                    <option value="SCHOOL_ADMIN" <%= "SCHOOL_ADMIN".equals(user.getRole())?"selected":""%>>学校管理员</option>
                    <option value="DEPT_ADMIN" <%= "DEPT_ADMIN".equals(user.getRole())?"selected":""%>>部门管理员</option>
                    <option value="AUDIT_ADMIN" <%= "AUDIT_ADMIN".equals(user.getRole())?"selected":""%>>审计管理员</option>
                </select>
            </div>
            <% if (request.getAttribute("error") != null) { %>
                <div class="error">错误：<%=request.getAttribute("error")%></div>
            <% } %>
            <% if (request.getAttribute("message") != null) { %>
                <div class="message">提示：<%=request.getAttribute("message")%></div>
            <% } %>
            <button type="submit" class="btn">保存</button>
            <a href="<%=request.getContextPath()%>/admin/users" class="btn btn-cancel">取消</a>
        </form>
    </div>
</body>
</html> 