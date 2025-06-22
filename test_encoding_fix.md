# 编码问题修复说明

## 问题描述
1. 添加部门时，部门名称提交后变成乱码
2. 编辑部门后，页面没有更新显示

## 修复内容

### 1. Servlet编码设置
在 `DepartmentOperationServlet.java` 中添加了编码设置：
```java
// Set character encoding to handle Chinese characters
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
```

### 2. 数据库连接编码设置
在 `BaseDao.java` 中修改了数据库连接URL：
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/campus_pass?useSSL=false&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8";
```

### 3. 调试信息添加
在关键方法中添加了调试输出，帮助诊断问题：
- `addDepartment()` 方法
- `editDepartment()` 方法  
- `updateDepartment()` 方法

## 测试步骤

### 1. 重新编译和启动
```bash
mvn clean compile
mvn tomcat7:run
```

### 2. 测试添加部门功能
1. 访问：`http://localhost:8080/PassCode/admin/login`
2. 登录：用户名 `admin`，密码 `Admin@123`
3. 点击"部门管理"
4. 点击"➕ 添加新部门"
5. 填写表单：
   - 部门编号：TEST001
   - 部门名称：测试部门
   - 部门类型：行政部门
6. 点击"✅ 添加部门"
7. 检查控制台输出，确认参数正确接收
8. 验证部门是否成功添加且名称正确显示

### 3. 测试编辑部门功能
1. 在部门列表中找到刚添加的部门
2. 点击"✏️ 编辑"
3. 修改部门名称：测试部门（已修改）
4. 点击"✅ 保存修改"
5. 检查控制台输出，确认参数正确接收
6. 验证部门信息是否正确更新

## 预期结果

### 修复前的问题
- 添加部门时名称变成乱码
- 编辑部门后页面不更新

### 修复后的预期
- 添加部门时名称正确显示
- 编辑部门后页面正确更新
- 控制台显示正确的调试信息

## 如果问题仍然存在

如果修复后问题仍然存在，请检查：

1. **数据库字符集设置**
   ```sql
   SHOW VARIABLES LIKE 'character_set%';
   SHOW VARIABLES LIKE 'collation%';
   ```

2. **表字符集设置**
   ```sql
   SHOW CREATE TABLE department;
   ```

3. **Tomcat配置**
   检查 `server.xml` 中的编码设置

4. **浏览器编码**
   确保浏览器使用UTF-8编码

## 调试信息说明

控制台会显示以下调试信息：
```
DEBUG: Received parameters:
  deptNo: TEST001
  deptName: 测试部门
  deptType: 行政部门

DEBUG: Updating department:
  ID: 1
  deptNo: TEST001
  deptName: 测试部门（已修改）
  deptType: 行政部门
DEBUG: Update result: 1 rows affected
```

如果看到这些信息，说明编码问题已经解决。 