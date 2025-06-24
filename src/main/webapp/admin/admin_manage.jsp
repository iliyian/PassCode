<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.zjut.passcode.bean.Admin" %>
<%@ page import="com.zjut.passcode.bean.Department" %>
<%@ page import="java.util.List" %>
<%
    Admin currentAdmin = (Admin) session.getAttribute("admin");
    if (currentAdmin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login");
        return;
    }
    List<Admin> admins = (List<Admin>) request.getAttribute("admins");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    String action = request.getParameter("action");
    Admin editAdmin = (Admin) request.getAttribute("editAdmin");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员管理 - 校园通行码系统</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #e0eafc 0%, #cfdef3 100%);
            min-height: 100vh;
            margin: 0;
        }
        .header {
            background: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            padding: 24px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            font-size: 1.7em;
            font-weight: bold;
            color: #3a3a3a;
        }
        .user-info {
            color: #555;
            font-size: 1em;
        }
        .container {
            max-width: 1100px;
            margin: 40px auto;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.08);
            padding: 40px 32px 32px 32px;
        }
        .page-title {
            font-size: 2.1em;
            color: #333;
            margin-bottom: 10px;
            text-align: center;
        }
        .subtitle {
            color: #888;
            font-size: 1.1em;
            text-align: center;
            margin-bottom: 30px;
        }
        .add-btn {
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 10px 28px;
            font-size: 1em;
            cursor: pointer;
            margin-bottom: 24px;
            float: right;
        }
        .add-btn:hover {
            background: linear-gradient(90deg, #5a67d8 0%, #6b47b6 100%);
        }
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .admin-table th, .admin-table td {
            padding: 13px 10px;
            border-bottom: 1px solid #e9ecef;
            text-align: left;
        }
        .admin-table th {
            background: #f6f8fa;
            color: #333;
            font-weight: bold;
        }
        .admin-table tr:hover {
            background: #f3f6fa;
        }
        .role-badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.9em;
            font-weight: bold;
            color: #fff;
        }
        .role-system-admin { background: #dc3545; }
        .role-school-admin { background: #fd7e14; }
        .role-dept-admin { background: #ffc107; color: #212529; }
        .role-audit-admin { background: #17a2b8; }
        .action-btn {
            padding: 6px 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.95em;
            margin: 2px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-edit { background: #17a2b8; color: #fff; }
        .btn-delete { background: #dc3545; color: #fff; }
        .btn-reset { background: #6c757d; color: #fff; }
        .form-modal {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.18);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        .form-box {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.13);
            padding: 32px 36px 24px 36px;
            min-width: 350px;
            max-width: 95vw;
        }
        .form-box h3 {
            margin-top: 0;
            margin-bottom: 18px;
            color: #333;
        }
        .form-row {
            margin-bottom: 18px;
        }
        .form-row label {
            display: inline-block;
            width: 90px;
            color: #555;
        }
        .form-row input, .form-row select {
            padding: 7px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            width: 220px;
            font-size: 1em;
        }
        .form-actions {
            text-align: right;
        }
        .form-actions button, .form-actions a {
            margin-left: 10px;
        }
        .error-msg { color: #dc3545; margin-bottom: 10px; }
        .success-msg { color: #28a745; margin-bottom: 10px; }
        @media (max-width: 700px) {
            .container { padding: 10px; }
            .form-box { padding: 18px 8px; }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">👤 管理员管理</div>
        <div class="user-info">当前登录：<%= currentAdmin.getFullName() %></div>
    </div>
    <div class="container">
        <div class="page-title">管理员管理</div>
        <div class="subtitle">管理系统所有管理员账户，可添加、编辑、删除和重置密码</div>
        <button class="add-btn" onclick="showAddModal()">➕ 添加新管理员</button>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>登录名</th>
                    <th>姓名</th>
                    <th>角色</th>
                    <th>部门</th>
                    <th>联系电话</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <% if (admins != null && !admins.isEmpty()) {
                    for (Admin user : admins) { %>
                <tr>
                    <td><%= user.getId() %></td>
                    <td><%= user.getLoginName() %></td>
                    <td><%= user.getFullName() %></td>
                    <td>
                        <span class="role-badge role-<%= user.getRole().toLowerCase().replace("_", "-") %>">
                            <%= getRoleDisplayName(user.getRole()) %>
                        </span>
                    </td>
                    <td><%= user.getDeptName() != null ? user.getDeptName() : "未分配" %></td>
                    <td><%= user.getPhone() != null ? user.getPhone() : "未设置" %></td>
                    <td>
                        <button class="action-btn btn-edit" onclick="showEditModal(<%= user.getId() %>)">编辑</button>
                        <% if (user.getId() != currentAdmin.getId()) { %>
                        <button class="action-btn btn-delete" onclick="confirmDelete(<%= user.getId() %>)">删除</button>
                        <% } %>
                        <button class="action-btn btn-reset" onclick="resetPwd(<%= user.getId() %>)">重置密码</button>
                    </td>
                </tr>
                <%  }
                } else { %>
                <tr><td colspan="7" style="text-align:center;color:#888;">暂无管理员记录</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <!-- 添加管理员弹窗 -->
    <div class="form-modal" id="addModal" style="display:none;">
        <div class="form-box">
            <h3>添加新管理员</h3>
            <form method="post" action="<%=request.getContextPath()%>/admin/users">
                <input type="hidden" name="action" value="add" />
                <div class="form-row">
                    <label>登录名：</label>
                    <input type="text" name="loginName" required />
                </div>
                <div class="form-row">
                    <label>密码：</label>
                    <input type="password" name="password" required />
                </div>
                <div class="form-row">
                    <label>姓名：</label>
                    <input type="text" name="fullName" required />
                </div>
                <div class="form-row">
                    <label>部门：</label>
                    <select name="deptId">
                        <option value="">请选择部门</option>
                        <% if (departments != null) for (Department dept : departments) { %>
                        <option value="<%=dept.getId()%>"><%=dept.getDeptName()%></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-row">
                    <label>联系电话：</label>
                    <input type="text" name="phone" required />
                </div>
                <div class="form-row">
                    <label>角色：</label>
                    <select name="role" required>
                        <% if ("SYSTEM_ADMIN".equals(currentAdmin.getRole())) { %>
                            <option value="SYSTEM_ADMIN">系统管理员</option>
                            <option value="SCHOOL_ADMIN">学校管理员</option>
                            <option value="DEPT_ADMIN">部门管理员</option>
                            <option value="AUDIT_ADMIN">审计管理员</option>
                        <% } else if ("SCHOOL_ADMIN".equals(currentAdmin.getRole())) { %>
                            <option value="DEPT_ADMIN">部门管理员</option>
                        <% } %>
                    </select>
                </div>
                <% if (request.getAttribute("error") != null) { %>
                    <div class="error-msg">错误：<%=request.getAttribute("error")%></div>
                <% } %>
                <% if (request.getAttribute("message") != null) { %>
                    <div class="success-msg">提示：<%=request.getAttribute("message")%></div>
                <% } %>
                <div class="form-actions">
                    <button type="submit" class="add-btn" style="float:none;">提交</button>
                    <a href="#" onclick="closeAddModal();return false;" class="back-btn">取消</a>
                </div>
            </form>
        </div>
    </div>
    <!-- 编辑管理员弹窗 -->
    <div class="form-modal" id="editModal" style="display:none;">
        <div class="form-box">
            <h3>编辑管理员</h3>
            <form method="post" action="<%=request.getContextPath()%>/admin/users">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="id" id="editId" />
                <div class="form-row">
                    <label>登录名：</label>
                    <input type="text" name="loginName" id="editLoginName" required />
                </div>
                <div class="form-row">
                    <label>姓名：</label>
                    <input type="text" name="fullName" id="editFullName" required />
                </div>
                <div class="form-row">
                    <label>部门：</label>
                    <select name="deptId" id="editDeptId">
                        <option value="">请选择部门</option>
                        <% if (departments != null) for (Department dept : departments) { %>
                        <option value="<%=dept.getId()%>"><%=dept.getDeptName()%></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-row">
                    <label>联系电话：</label>
                    <input type="text" name="phone" id="editPhone" required />
                </div>
                <div class="form-row">
                    <label>角色：</label>
                    <select name="role" id="editRole" required>
                        <% if ("SYSTEM_ADMIN".equals(currentAdmin.getRole())) { %>
                            <option value="SYSTEM_ADMIN">系统管理员</option>
                            <option value="SCHOOL_ADMIN">学校管理员</option>
                            <option value="DEPT_ADMIN">部门管理员</option>
                            <option value="AUDIT_ADMIN">审计管理员</option>
                        <% } else if ("SCHOOL_ADMIN".equals(currentAdmin.getRole())) { %>
                            <option value="DEPT_ADMIN">部门管理员</option>
                        <% } %>
                    </select>
                </div>
                <div class="form-actions">
                    <button type="submit" class="add-btn" style="float:none;">保存</button>
                    <a href="#" onclick="closeEditModal();return false;" class="back-btn">取消</a>
                </div>
            </form>
        </div>
    </div>
    <script>
        function showAddModal() {
            document.getElementById('addModal').style.display = 'flex';
        }
        function closeAddModal() {
            document.getElementById('addModal').style.display = 'none';
        }
        function showEditModal(id) {
            // 这里可用AJAX请求管理员信息，或用JSP渲染时输出JS对象
            var admins = <%=
                admins != null ? new com.google.gson.Gson().toJson(admins) : "[]"
            %>;
            var adminList = typeof admins === 'string' ? JSON.parse(admins) : admins;
            var admin = adminList.find(function(a){return a.id==id});
            if (!admin) return;
            document.getElementById('editId').value = admin.id;
            document.getElementById('editLoginName').value = admin.loginName;
            document.getElementById('editFullName').value = admin.fullName;
            document.getElementById('editDeptId').value = admin.deptId;
            document.getElementById('editPhone').value = admin.phone;
            document.getElementById('editRole').value = admin.role;
            document.getElementById('editModal').style.display = 'flex';
        }
        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }
        function confirmDelete(id) {
            if (confirm('确定要删除该管理员吗？')) {
                window.location.href = '<%=request.getContextPath()%>/admin/users?action=delete&id=' + id;
            }
        }
        function resetPwd(id) {
            if (confirm('确定要重置该管理员的密码吗？')) {
                window.location.href = '<%=request.getContextPath()%>/admin/users?action=resetPassword&id=' + id;
            }
        }
    </script>
    <%!
    private String getRoleDisplayName(String role) {
        switch (role) {
            case "SYSTEM_ADMIN": return "系统管理员";
            case "SCHOOL_ADMIN": return "学校管理员";
            case "DEPT_ADMIN": return "部门管理员";
            case "AUDIT_ADMIN": return "审计管理员";
            default: return role;
        }
    }
    %>
</body>
</html> 