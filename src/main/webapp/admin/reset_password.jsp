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
        .btn:disabled { background: #6c757d; cursor: not-allowed; }
        .btn-cancel { background: #6c757d; margin-left: 10px; }
        .error { color: #dc3545; margin-bottom: 10px; }
        .message { color: #28a745; margin-bottom: 10px; }
        .password-hint { color:#888; font-size:0.9em; margin-bottom: 10px; }
        .password-status { font-size: 0.9em; margin-bottom: 10px; }
        .password-match { color: #28a745; }
        .password-mismatch { color: #dc3545; }
    </style>
</head>
<body>
    <div class="container">
        <h2>重置管理员密码</h2>
        <form method="post" action="<%=request.getContextPath()%>/admin/users" id="resetPasswordForm">
            <input type="hidden" name="action" value="resetPwd" />
            <input type="hidden" name="userId" value="<%= user.getId() %>" />
            <div>
                <label>管理员姓名：</label>
                <input type="text" value="<%= user.getFullName() %>" disabled />
            </div>
            <div>
                <label>新密码：</label>
                <input type="password" name="newPassword" id="newPassword" required />
                <div class="password-hint">密码需8位以上，含数字、大小写字母、特殊字符</div>
            </div>
            <div>
                <label>确认密码：</label>
                <input type="password" name="confirmPassword" id="confirmPassword" required />
                <div class="password-hint">请再次输入新密码</div>
                <div class="password-status" id="passwordStatus"></div>
            </div>
            <% if (request.getAttribute("error") != null) { %>
                <div class="error">错误：<%=request.getAttribute("error")%></div>
            <% } %>
            <% if (request.getAttribute("message") != null) { %>
                <div class="message">提示：<%=request.getAttribute("message")%></div>
            <% } %>
            <button type="submit" class="btn" id="submitBtn" disabled>重置密码</button>
            <a href="<%=request.getContextPath()%>/admin/users" class="btn btn-cancel">取消</a>
        </form>
    </div>

    <script>
        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');
        const passwordStatus = document.getElementById('passwordStatus');
        const submitBtn = document.getElementById('submitBtn');

        // 检查密码复杂度
        function validatePassword(password) {
            const hasNumber = /\d/.test(password);
            const hasLower = /[a-z]/.test(password);
            const hasUpper = /[A-Z]/.test(password);
            const hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);
            const isLongEnough = password.length >= 8;
            
            return hasNumber && hasLower && hasUpper && hasSpecial && isLongEnough;
        }

        // 实时检查密码匹配和复杂度
        function checkPasswords() {
            const newPwd = newPassword.value;
            const confirmPwd = confirmPassword.value;
            
            // 如果两个密码框都为空，不显示状态
            if (!newPwd && !confirmPwd) {
                passwordStatus.textContent = '';
                passwordStatus.className = 'password-status';
                submitBtn.disabled = true;
                return;
            }
            
            // 检查密码复杂度
            if (newPwd && !validatePassword(newPwd)) {
                passwordStatus.textContent = '密码复杂度不足';
                passwordStatus.className = 'password-status password-mismatch';
                submitBtn.disabled = true;
                return;
            }
            
            // 检查密码匹配
            if (newPwd && confirmPwd) {
                if (newPwd === confirmPwd) {
                    passwordStatus.textContent = '✓ 密码匹配且符合要求';
                    passwordStatus.className = 'password-status password-match';
                    submitBtn.disabled = false;
                } else {
                    passwordStatus.textContent = '✗ 两次输入的密码不一致';
                    passwordStatus.className = 'password-status password-mismatch';
                    submitBtn.disabled = true;
                }
            } else {
                passwordStatus.textContent = '请完成密码输入';
                passwordStatus.className = 'password-status password-mismatch';
                submitBtn.disabled = true;
            }
        }

        // 添加事件监听器
        newPassword.addEventListener('input', checkPasswords);
        confirmPassword.addEventListener('input', checkPasswords);

        // 表单提交验证（双重保险）
        document.getElementById('resetPasswordForm').addEventListener('submit', function(e) {
            const newPwd = newPassword.value;
            const confirmPwd = confirmPassword.value;
            
            if (newPwd !== confirmPwd) {
                e.preventDefault();
                alert('两次输入的密码不一致，请重新输入');
                return false;
            }
            
            if (!validatePassword(newPwd)) {
                e.preventDefault();
                alert('密码必须包含8位以上，包含数字、大小写字母、特殊字符');
                return false;
            }
        });
    </script>
</body>
</html> 