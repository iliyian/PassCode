@echo off
echo ========================================
echo 编码问题修复测试
echo ========================================
echo.

echo 正在重新编译项目...
mvn clean compile

if errorlevel 1 (
    echo 编译失败，请检查代码错误
    pause
    exit /b 1
)

echo 编译成功！
echo.

echo 正在启动Tomcat服务器...
echo 请等待服务器启动完成...
echo.

echo 测试步骤：
echo 1. 访问 http://localhost:8080/PassCode/admin/login
echo 2. 登录：用户名 admin，密码 Admin@123
echo 3. 点击"部门管理"
echo 4. 测试添加部门功能（检查中文是否正常）
echo 5. 测试编辑部门功能（检查更新是否生效）
echo 6. 查看控制台输出，确认调试信息正确
echo.

mvn tomcat7:run

pause 