# 校园通行码预约管理系统 - 部署指南

## 系统要求

### 硬件要求
- **CPU**: 2核心以上
- **内存**: 4GB以上
- **存储**: 10GB以上可用空间

### 软件要求
- **操作系统**: Windows 10/11, Linux, macOS
- **JDK**: 21或更高版本
- **MySQL**: 8.0或更高版本
- **Tomcat**: 10.0或更高版本
- **Maven**: 3.6或更高版本

## 安装步骤

### 1. 环境准备

#### 安装JDK 21
```bash
# 下载并安装JDK 21
# 设置JAVA_HOME环境变量
export JAVA_HOME=/path/to/jdk-21
export PATH=$JAVA_HOME/bin:$PATH
```

#### 安装MySQL 8.0
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install mysql-server

# CentOS/RHEL
sudo yum install mysql-server

# Windows
# 下载MySQL Installer并安装
```

#### 安装Tomcat 10
```bash
# 下载Tomcat 10
wget https://downloads.apache.org/tomcat/tomcat-10/v10.1.0/bin/apache-tomcat-10.1.0.tar.gz
tar -xzf apache-tomcat-10.1.0.tar.gz
sudo mv apache-tomcat-10.1.0 /opt/tomcat
```

### 2. 数据库配置

#### 创建数据库
```bash
# 登录MySQL
mysql -u root -p

# 执行初始化脚本
source database_init.sql
```

#### 配置数据库连接
修改所有DAO类中的数据库连接信息：
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/campus_pass?useSSL=false&serverTimezone=UTC";
private static final String DB_USER = "your_username";
private static final String DB_PASSWORD = "your_password";
```

### 3. 项目编译

#### 克隆项目
```bash
git clone <repository-url>
cd PassCode
```

#### 编译项目
```bash
mvn clean package
```

### 4. 部署到Tomcat

#### 方法一：直接部署WAR包
```bash
# 将生成的WAR包复制到Tomcat的webapps目录
cp target/PassCode-1.0-SNAPSHOT.war /opt/tomcat/webapps/PassCode.war

# 启动Tomcat
/opt/tomcat/bin/startup.sh
```

#### 方法二：使用Maven插件
```bash
# 配置Tomcat插件
mvn tomcat7:deploy -Dmaven.tomcat.url=http://localhost:8080/manager/text -Dmaven.tomcat.username=admin -Dmaven.tomcat.password=admin
```

### 5. 配置Tomcat

#### 修改server.xml
```xml
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443"
           URIEncoding="UTF-8" />
```

#### 配置内存参数
```bash
# 编辑catalina.sh或catalina.bat
export CATALINA_OPTS="-Xms512m -Xmx1024m -XX:MaxPermSize=256m"
```

### 6. 安全配置

#### 配置HTTPS（可选）
```xml
<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
           maxThreads="150" SSLEnabled="true">
    <SSLHostConfig>
        <Certificate certificateKeystoreFile="conf/localhost-rsa.jks"
                     type="RSA" />
    </SSLHostConfig>
</Connector>
```

#### 配置防火墙
```bash
# 开放必要端口
sudo ufw allow 8080
sudo ufw allow 8443
```

## 验证部署

### 1. 访问系统
- **首页**: http://localhost:8080/PassCode/
- **管理员登录**: http://localhost:8080/PassCode/admin/login

### 2. 测试功能
1. **预约功能测试**
   - 访问首页，点击"我要预约"
   - 填写预约信息并提交
   - 查看生成的通行码

2. **管理功能测试**
   - 使用默认管理员账户登录
   - 用户名: admin
   - 密码: Admin@123

### 3. 检查日志
```bash
# 查看Tomcat日志
tail -f /opt/tomcat/logs/catalina.out

# 查看应用日志
tail -f /opt/tomcat/logs/PassCode.log
```

## 生产环境配置

### 1. 数据库优化
```sql
-- 创建数据库用户
CREATE USER 'campus_pass'@'localhost' IDENTIFIED BY 'strong_password';
GRANT ALL PRIVILEGES ON campus_pass.* TO 'campus_pass'@'localhost';
FLUSH PRIVILEGES;

-- 优化数据库配置
SET GLOBAL innodb_buffer_pool_size = 1G;
SET GLOBAL max_connections = 200;
```

### 2. JVM优化
```bash
export CATALINA_OPTS="-server -Xms2g -Xmx4g -XX:NewRatio=3 -XX:SurvivorRatio=4 -XX:MaxMetaspaceSize=512m -XX:+UseG1GC"
```

### 3. 连接池配置
```xml
<Resource name="jdbc/campus_pass" auth="Container"
          type="javax.sql.DataSource"
          maxTotal="100" maxIdle="30" maxWaitMillis="10000"
          username="campus_pass" password="strong_password"
          driverClassName="com.mysql.cj.jdbc.Driver"
          url="jdbc:mysql://localhost:3306/campus_pass?useSSL=false&amp;serverTimezone=UTC"/>
```

## 监控和维护

### 1. 日志管理
```bash
# 配置日志轮转
logrotate /etc/logrotate.d/tomcat

# 清理旧日志
find /opt/tomcat/logs -name "*.log" -mtime +30 -delete
```

### 2. 备份策略
```bash
# 数据库备份
mysqldump -u campus_pass -p campus_pass > backup_$(date +%Y%m%d).sql

# 应用备份
tar -czf PassCode_backup_$(date +%Y%m%d).tar.gz /opt/tomcat/webapps/PassCode
```

### 3. 性能监控
```bash
# 监控系统资源
htop
iostat -x 1
netstat -tulpn | grep :8080
```

## 故障排除

### 常见问题

#### 1. 数据库连接失败
```bash
# 检查MySQL服务状态
sudo systemctl status mysql

# 检查数据库连接
mysql -u campus_pass -p -h localhost
```

#### 2. 应用启动失败
```bash
# 检查Java版本
java -version

# 检查端口占用
netstat -tulpn | grep :8080

# 查看详细错误日志
tail -f /opt/tomcat/logs/catalina.out
```

#### 3. 内存不足
```bash
# 增加JVM内存
export CATALINA_OPTS="-Xms1g -Xmx2g"

# 重启Tomcat
/opt/tomcat/bin/shutdown.sh
/opt/tomcat/bin/startup.sh
```

## 更新部署

### 1. 备份当前版本
```bash
cp /opt/tomcat/webapps/PassCode.war /opt/tomcat/webapps/PassCode.war.backup
```

### 2. 部署新版本
```bash
# 停止应用
/opt/tomcat/bin/shutdown.sh

# 删除旧版本
rm -rf /opt/tomcat/webapps/PassCode

# 部署新版本
cp target/PassCode-1.0-SNAPSHOT.war /opt/tomcat/webapps/PassCode.war

# 启动应用
/opt/tomcat/bin/startup.sh
```

### 3. 验证更新
```bash
# 检查应用状态
curl -I http://localhost:8080/PassCode/

# 查看启动日志
tail -f /opt/tomcat/logs/catalina.out
```

## 联系支持

如遇到部署问题，请联系技术支持团队：
- 邮箱: support@campus-pass.com
- 电话: (021) 1234-5678
- 工作时间: 周一至周五 9:00-18:00 