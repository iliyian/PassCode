@echo off
echo ========================================
echo 部门管理功能完整测试
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

echo ========================================
echo 测试步骤：
echo ========================================
echo 1. 访问 http://localhost:8080/PassCode/admin/login
echo 2. 登录：用户名 admin，密码 Admin@123
echo 3. 点击"部门管理"菜单
echo.
echo 测试项目：
echo - 添加新部门（检查是否白屏）
echo - 编辑部门（检查是否更新）
echo - 删除部门（检查确认对话框）
echo - 检查中文显示是否正常
echo - 查看控制台调试信息
echo.

mvn tomcat7:run

pause 