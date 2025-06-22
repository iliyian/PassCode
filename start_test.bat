@echo off
echo ========================================
echo 校园通行码系统 - 错误处理测试
echo ========================================
echo.

echo 正在启动系统...
echo.

echo 1. 确保MySQL数据库已启动
echo 2. 确保数据库 'campus_pass' 已创建
echo 3. 确保数据库表已初始化
echo.

echo 启动Tomcat服务器...
echo.

REM 检查Maven是否可用
mvn --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: Maven未安装或未配置到PATH中
    echo 请先安装Maven并配置环境变量
    pause
    exit /b 1
)

REM 清理并编译项目
echo 正在清理和编译项目...
mvn clean compile

REM 启动Tomcat
echo 正在启动Tomcat服务器...
mvn tomcat7:run

echo.
echo 系统启动完成！
echo.
echo 访问地址:
echo - 首页: http://localhost:8080/PassCode/
echo - 登录测试页面: http://localhost:8080/PassCode/login_test.jsp
echo - 管理员登录: http://localhost:8080/PassCode/admin/login
echo - 错误测试页面: http://localhost:8080/PassCode/test_error.jsp
echo.
echo 测试账号:
echo - 用户名: admin
echo - 密码: Admin@123
echo.
echo 其他测试账号:
echo - school_admin / Admin@123
echo - dept_admin / Admin@123  
echo - audit_admin / Admin@123
echo.
pause 