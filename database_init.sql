-- 校园通行码预约管理系统数据库初始化脚本
-- 创建数据库
CREATE DATABASE IF NOT EXISTS campus_pass DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE campus_pass;

-- 1. 部门表
CREATE TABLE `department` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '部门主键ID',
  `dept_no` VARCHAR(50) NOT NULL UNIQUE COMMENT '部门编号',
  `dept_name` VARCHAR(100) NOT NULL COMMENT '部门名称',
  `dept_type` ENUM('行政部门', '直属部门', '学院') NOT NULL COMMENT '部门类型',
  PRIMARY KEY (`id`)
) COMMENT='部门信息表';

-- 2. 管理员表
CREATE TABLE `admin` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '管理员主键ID',
  `login_name` VARCHAR(50) NOT NULL UNIQUE COMMENT '登录名',
  `password_hash` VARCHAR(255) NOT NULL COMMENT '密码（SM3加密）',
  `full_name` VARCHAR(50) NOT NULL COMMENT '姓名',
  `dept_id` INT COMMENT '所在部门ID',
  `phone` VARCHAR(255) NOT NULL COMMENT '联系电话（SM4加密）',
  `role` ENUM('SYSTEM_ADMIN', 'SCHOOL_ADMIN', 'DEPT_ADMIN', 'AUDIT_ADMIN') NOT NULL COMMENT '角色',
  `password_last_changed` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '密码最后修改时间',
  `failed_login_attempts` INT DEFAULT 0 COMMENT '连续登录失败次数',
  `lockout_until` TIMESTAMP NULL COMMENT '账户锁定截止时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`dept_id`) REFERENCES `department`(`id`)
) COMMENT='管理员信息表';

-- 3. 预约记录表
CREATE TABLE `appointment` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '预约主键ID',
  `visitor_name` VARCHAR(50) NOT NULL COMMENT '预约人姓名',
  `visitor_id_card` VARCHAR(255) NOT NULL COMMENT '预约人身份证号（SM4加密）',
  `visitor_phone` VARCHAR(255) NOT NULL COMMENT '预约人手机号（SM4加密）',
  `visitor_unit` VARCHAR(200) COMMENT '所在单位',
  `campus` VARCHAR(50) NOT NULL COMMENT '预约校区',
  `entry_time` TIMESTAMP NOT NULL COMMENT '预约进校时间',
  `transport_mode` VARCHAR(50) COMMENT '交通方式',
  `license_plate` VARCHAR(20) NULL COMMENT '车牌号',
  `appointment_type` ENUM('PUBLIC', 'OFFICIAL') NOT NULL COMMENT '预约类型',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  `status` ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL COMMENT '审核状态',
  `official_dept_id` INT NULL COMMENT '公务访问部门ID',
  `official_contact_person` VARCHAR(50) NULL COMMENT '公务访问接待人',
  `official_reason` TEXT NULL COMMENT '来访事由',
  `audited_by` INT NULL COMMENT '审核人ID',
  `audited_at` TIMESTAMP NULL COMMENT '审核时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`official_dept_id`) REFERENCES `department`(`id`),
  FOREIGN KEY (`audited_by`) REFERENCES `admin`(`id`)
) COMMENT='访客预约记录表';

-- 4. 随行人员表
CREATE TABLE `accompanying_person` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `appointment_id` BIGINT NOT NULL COMMENT '关联的预约ID',
  `full_name` VARCHAR(50) NOT NULL COMMENT '姓名',
  `id_card` VARCHAR(255) NOT NULL COMMENT '身份证号（SM4加密）',
  `phone` VARCHAR(255) NOT NULL COMMENT '手机号（SM4加密）',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`appointment_id`) REFERENCES `appointment`(`id`) ON DELETE CASCADE
) COMMENT='随行人员信息表';

-- 5. 安全审计日志表
CREATE TABLE `audit_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志主键ID',
  `admin_id` INT NOT NULL COMMENT '操作管理员ID',
  `admin_name` VARCHAR(50) COMMENT '操作管理员姓名（冗余）',
  `action` VARCHAR(255) NOT NULL COMMENT '操作类型（如登录、查询、审核）',
  `details` TEXT COMMENT '操作详情',
  `ip_address` VARCHAR(50) COMMENT '操作者IP地址',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `hmac_signature` VARCHAR(255) NULL COMMENT '日志完整性校验值（HMAC-SM3）',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`admin_id`) REFERENCES `admin`(`id`)
) COMMENT='安全审计日志表';

-- 插入初始数据

-- 插入部门数据
INSERT INTO `department` (`dept_no`, `dept_name`, `dept_type`) VALUES
('D001', '计算机学院', '学院'),
('D002', '机械工程学院', '学院'),
('D003', '化学工程学院', '学院'),
('D004', '信息工程学院', '学院'),
('D005', '经济学院', '学院'),
('D006', '管理学院', '学院'),
('D007', '理学院', '学院'),
('D008', '外国语学院', '学院'),
('D009', '人文学院', '学院'),
('D010', '艺术学院', '学院'),
('D101', '校长办公室', '行政部门'),
('D102', '教务处', '行政部门'),
('D103', '学生处', '行政部门'),
('D104', '人事处', '行政部门'),
('D105', '财务处', '行政部门'),
('D201', '图书馆', '直属部门'),
('D202', '信息中心', '直属部门'),
('D203', '后勤集团', '直属部门');

-- 插入系统管理员（密码：Admin@123，使用SHA-256哈希）
INSERT INTO `admin` (`login_name`, `password_hash`, `full_name`, `dept_id`, `phone`, `role`) VALUES
('admin', 'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', '系统管理员', 1, 'encrypted_phone_1', 'SYSTEM_ADMIN'),
('school_admin', 'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', '学校管理员', 1, 'encrypted_phone_2', 'SCHOOL_ADMIN'),
('dept_admin', 'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', '部门管理员', 1, 'encrypted_phone_3', 'DEPT_ADMIN'),
('audit_admin', 'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', '审计管理员', 1, 'encrypted_phone_4', 'AUDIT_ADMIN');

-- 创建索引
CREATE INDEX idx_appointment_visitor ON `appointment` (`visitor_name`, `visitor_id_card`, `visitor_phone`);
CREATE INDEX idx_appointment_status ON `appointment` (`status`);
CREATE INDEX idx_appointment_type ON `appointment` (`appointment_type`);
CREATE INDEX idx_appointment_entry_time ON `appointment` (`entry_time`);
CREATE INDEX idx_appointment_created_at ON `appointment` (`created_at`);
CREATE INDEX idx_audit_log_admin ON `audit_log` (`admin_id`);
CREATE INDEX idx_audit_log_created_at ON `audit_log` (`created_at`);
CREATE INDEX idx_admin_login_name ON `admin` (`login_name`);
CREATE INDEX idx_admin_role ON `admin` (`role`);

-- 创建视图
CREATE VIEW v_appointment_detail AS
SELECT 
    a.*,
    d.dept_name as official_dept_name,
    adm.full_name as audited_by_name
FROM appointment a
LEFT JOIN department d ON a.official_dept_id = d.id
LEFT JOIN admin adm ON a.audited_by = adm.id;

-- 创建存储过程：清理过期日志
DELIMITER //
CREATE PROCEDURE CleanOldAuditLogs(IN daysToKeep INT)
BEGIN
    DELETE FROM audit_log 
    WHERE created_at < DATE_SUB(NOW(), INTERVAL daysToKeep DAY);
END //
DELIMITER ;

-- 创建事件：自动清理180天前的日志
CREATE EVENT IF NOT EXISTS clean_audit_logs_event
ON SCHEDULE EVERY 1 DAY
DO CALL CleanOldAuditLogs(180);

-- 启用事件调度器
SET GLOBAL event_scheduler = ON;

-- 创建触发器：更新管理员密码修改时间
DELIMITER //
CREATE TRIGGER update_password_changed
BEFORE UPDATE ON admin
FOR EACH ROW
BEGIN
    IF NEW.password_hash != OLD.password_hash THEN
        SET NEW.password_last_changed = CURRENT_TIMESTAMP;
    END IF;
END //
DELIMITER ;

-- 显示创建结果
SELECT 'Database initialization completed successfully!' as message;
SELECT COUNT(*) as department_count FROM department;
SELECT COUNT(*) as admin_count FROM admin; 