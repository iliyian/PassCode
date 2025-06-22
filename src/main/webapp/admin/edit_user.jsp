<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.zjut.passcode.bean.Admin" %>
<%@ page import="java.util.List" %>
<%
    Admin user = (Admin) request.getAttribute("editUser");
    List departments = (List)request.getAttribute("departments");
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
                    <% if (departments != null) { for (Object obj : departments) { com.zjut.passcode.bean.Department dept = (com.zjut.passcode.bean.Department)obj; %>
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
            <div id="deptAdminPerms" style="display:<%= "DEPT_ADMIN".equals(user.getRole()) ? "block" : "none" %>;margin-bottom:20px;">
                <label style="font-weight:bold;">部门管理员权限：</label>
                <div style="margin:8px 0 0 10px;">
                    <input type="checkbox" name="canManagePublicAppointment" value="1" <%= user.isCanManagePublicAppointment() ? "checked" : "" %> />
                    <span>可管理本部门社会公众预约</span>
                </div>
                <div style="margin:8px 0 0 10px;">
                    <input type="checkbox" name="canReportPublicAppointment" value="1" <%= user.isCanReportPublicAppointment() ? "checked" : "" %> />
                    <span>可统计本部门社会公众预约</span>
                </div>
            </div>
            <script>
            // 动态显示/隐藏部门管理员权限
            document.addEventListener('DOMContentLoaded', function() {
                var roleSelect = document.querySelector('select[name="role"]');
                var permsDiv = document.getElementById('deptAdminPerms');
                roleSelect.addEventListener('change', function() {
                    if (this.value === 'DEPT_ADMIN') {
                        permsDiv.style.display = 'block';
                    } else {
                        permsDiv.style.display = 'none';
                    }
                });
            });
            </script>
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