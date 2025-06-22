#!/bin/bash

echo "========================================"
echo "校园通行码系统 - 部门管理功能测试"
echo "========================================"
echo

echo "正在启动系统..."
echo

# 检查Java是否安装
if ! command -v java &> /dev/null; then
    echo "错误：未找到Java环境，请先安装Java JDK"
    exit 1
fi

# 检查Maven是否安装
if ! command -v mvn &> /dev/null; then
    echo "错误：未找到Maven，请先安装Maven"
    exit 1
fi

echo "正在编译项目..."
mvn clean compile

if [ $? -ne 0 ]; then
    echo "编译失败，请检查代码错误"
    exit 1
fi

echo "编译成功！"
echo

echo "正在启动Tomcat服务器..."
echo "请等待服务器启动完成..."
echo

mvn tomcat7:run

echo
echo "服务器已启动！"
echo "请访问：http://localhost:8080/PassCode"
echo
echo "测试步骤："
echo "1. 访问 http://localhost:8080/PassCode/admin/login"
echo "2. 使用管理员账户登录（admin/Admin@123）"
echo "3. 点击'部门管理'菜单"
echo "4. 测试添加、编辑、删除功能"
echo 