-- 校园通行码预约管理系统数据库初始化脚本
-- 创建数据库
DROP DATABASE IF EXISTS campus_pass;
CREATE DATABASE IF NOT EXISTS campus_pass DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE campus_pass;

-- 1. 部门表
CREATE TABLE `department` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '部门主键ID',
  `dept_no` VARCHAR(50) NOT NULL UNIQUE COMMENT '部门编号',
  `dept_name` VARCHAR(100) NOT NULL COMMENT '部门名称',
  `dept_type` ENUM('行政部门', '直属部门', '学院') NOT NULL COMMENT '部门类型',
  PRIMARY KEY (`id`, `dept_no`, `dept_name`)
) COMMENT='部门信息表';

-- 2. 管理员表
CREATE TABLE `admin` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '管理员主键ID',
  `login_name` VARCHAR(50) NOT NULL UNIQUE COMMENT '登录名',
  `password_hash` VARCHAR(255) NOT NULL COMMENT '密码（SM3加密）',
  `full_name` VARCHAR(50) NOT NULL COMMENT '姓名',
  `dept_id` INT COMMENT '所在部门ID',
  `dept_no` VARCHAR(50) COMMENT '所在部门编号',
  `dept_name` VARCHAR(100) COMMENT '所在部门名称',
  `phone` VARCHAR(255) NOT NULL COMMENT '联系电话（SM4加密）',
  `role` ENUM('SYSTEM_ADMIN', 'SCHOOL_ADMIN', 'DEPT_ADMIN', 'AUDIT_ADMIN') NOT NULL COMMENT '角色',
  `password_last_changed` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '密码最后修改时间',
  `failed_login_attempts` INT DEFAULT 0 COMMENT '连续登录失败次数',
  `lockout_until` TIMESTAMP NULL COMMENT '账户锁定截止时间',
  `can_manage_public_appointment` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '能否管理社会公众预约',
  `can_report_public_appointment` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '能否统计社会公众预约',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`dept_id`, `dept_no`, `dept_name`) REFERENCES `department`(`id`, `dept_no`, `dept_name`)
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
  `official_dept_no` VARCHAR(50) NULL COMMENT '公务访问部门编号',
  `official_dept_name` VARCHAR(100) NULL COMMENT '公务访问部门名称',
  `official_contact_person` VARCHAR(50) NULL COMMENT '公务访问接待人',
  `official_reason` TEXT NULL COMMENT '来访事由',
  `audited_by` INT NULL COMMENT '审核人ID',
  `audited_at` TIMESTAMP NULL COMMENT '审核时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`official_dept_id`, `official_dept_no`, `official_dept_name`) REFERENCES `department`(`id`, `dept_no`, `dept_name`),
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

-- 先清空表，避免重复插入导致外键冲突
# DELETE FROM admin;
# DELETE FROM department;

-- 先插入 department
INSERT INTO `department` (`id`, `dept_no`, `dept_name`, `dept_type`) VALUES
(1, 'D001', '计算机学院', '学院'),
(2, 'D002', '机械工程学院', '学院'),
(14, 'D104', '人事处', '行政部门'),
(17, 'D201', '图书馆', '直属部门'),
(100, 'SYS', '系统', '直属部门'),
(101, 'AUD', '审计', '直属部门'),
(102, 'SCH', '学校', '直属部门');

-- 再插入 admin
INSERT INTO `admin` (`login_name`, `password_hash`, `full_name`, `dept_id`, `dept_no`, `dept_name`, `phone`, `role`, `can_manage_public_appointment`, `can_report_public_appointment`)
VALUES
('admin_cs', 'c4039a5810e67a8b1eb72cc2b9d9f2e55ca0e2fd2b84f55e212ad3a23aec89bc', '计算机学院管理员', 1, 'D001', '计算机学院', '13812345678', 'DEPT_ADMIN', 1, 1),
('admin_me', 'c4039a5810e67a8b1eb72cc2b9d9f2e55ca0e2fd2b84f55e212ad3a23aec89bc', '机械工程学院管理员', 2, 'D002', '机械工程学院', '13987654321', 'DEPT_ADMIN', 0, 1),
('admin_hr', 'c4039a5810e67a8b1eb72cc2b9d9f2e55ca0e2fd2b84f55e212ad3a23aec89bc', '人事处管理员', 14, 'D104', '人事处', '15012345678', 'DEPT_ADMIN', 1, 0),
('admin_lib', 'c4039a5810e67a8b1eb72cc2b9d9f2e55ca0e2fd2b84f55e212ad3a23aec89bc', '图书馆管理员', 17, 'D201', '图书馆', '15187654321', 'DEPT_ADMIN', 0, 0),
('admin_sys', 'c4039a5810e67a8b1eb72cc2b9d9f2e55ca0e2fd2b84f55e212ad3a23aec89bc', '系统管理员', 100, 'SYS', '系统', '18612345678', 'SYSTEM_ADMIN', 1, 1),
('admin_audit', 'c4039a5810e67a8b1eb72cc2b9d9f2e55ca0e2fd2b84f55e212ad3a23aec89bc', '审计管理员', 101, 'AUD', '审计', '18787654321', 'AUDIT_ADMIN', 0, 0),
('admin_school', 'c4039a5810e67a8b1eb72cc2b9d9f2e55ca0e2fd2b84f55e212ad3a23aec89bc', '学校管理员', 102, 'SCH', '学校', '18912345678', 'SCHOOL_ADMIN', 1, 1);

-- 插入预约数据（示例，含多种类型和状态）
INSERT INTO `appointment` (
  `visitor_name`, `visitor_id_card`, `visitor_phone`, `visitor_unit`, `campus`, `entry_time`, `transport_mode`, `license_plate`, `appointment_type`, `created_at`, `status`, `official_dept_id`, `official_dept_no`, `official_dept_name`, `official_contact_person`, `official_reason`, `audited_by`, `audited_at`
) VALUES
-- 公共预约，待审核
('陈志强', 'qMsvTckQwkVUWhPm8Ez1r79dP2gZhVPtZTWcbvfPEiM', 'B+kngiBQ87qa+q3sW4Bmaw==', '杭州科技有限公司', '朝晖校区', '2024-06-28 09:00:00', '步行', NULL, 'PUBLIC', '2024-06-26 10:00:00', 'PENDING', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
-- 公共预约，已通过
('李美玲', 'cozGzEm9Fi4oREQFxkkLzb9dP2gZhVPtZTWcbvfPEiM', 'jJVWFYEeCCzICaweBuQIGA==', '浙江省研究院', '屏峰校区', '2024-06-29 10:00:00', '自行车', NULL, 'PUBLIC', '2024-06-26 11:00:00', 'APPROVED', NULL, NULL, NULL, NULL, NULL, 1, '2024-06-27 09:00:00'),
-- 公共预约，已拒绝
('王建国', 'aaUR1xqrEwZ8ixmd2bkpjL9dP2gZhVPtZTWcbvfPEiM', '6+3PvkGMcYI4ztTbFiit4w==', '杭州企业集团', '莫干山校区', '2024-06-30 14:00:00', '公交', NULL, 'PUBLIC', '2024-06-26 12:00:00', 'REJECTED', NULL, NULL, NULL, NULL, NULL, 2, '2024-06-27 10:00:00'),
-- 公务预约，待审核
('张丽华', 'Bz0jqq14UQatAHAHxEJPb9dP2gZhVPtZTWcbvfPEiM', 'j9M5eJMTvghvWEj+n51qMg==', '杭州市政府', '朝晖校区', '2024-06-28 09:30:00', '小汽车', '浙A12345', 'OFFICIAL', '2024-06-26 13:00:00', 'PENDING', 1, 'D001', '计算机学院', '王老师', '业务交流', NULL, NULL),
-- 公务预约，已通过
('刘伟', 'VnXeFL9dP2gZhVPtZTWcbvfPEiM', 'G1pXA69Lp9h8dIsSmGTDgw==', '浙江省教育厅', '屏峰校区', '2024-06-29 15:00:00', '出租车', NULL, 'OFFICIAL', '2024-06-26 14:00:00', 'APPROVED', 2, 'D002', '机械工程学院', '李主任', '调研指导', 2, '2024-06-27 10:00:00'),
-- 公务预约，已拒绝
('孙小红', 'mKAZQQURBmGFZojEALn3Jb9dP2gZhVPtZTWcbvfPEiM', 'meji6KEU0Tl2qIn4nyISNQ==', '浙江大学', '莫干山校区', '2024-06-30 16:00:00', '步行', NULL, 'OFFICIAL', '2024-06-26 15:00:00', 'REJECTED', 14, 'D104', '人事处', '张处长', '合作洽谈', 1, '2024-06-27 11:00:00');

-- 补充：插入已过期和当前有效的预约数据
-- 已过期预约（entry_time早于2024-06-27）
INSERT INTO `appointment` (
  `visitor_name`, `visitor_id_card`, `visitor_phone`, `visitor_unit`, `campus`, `entry_time`, `transport_mode`, `license_plate`, `appointment_type`, `created_at`, `status`, `official_dept_id`, `official_dept_no`, `official_dept_name`, `official_contact_person`, `official_reason`, `audited_by`, `audited_at`
) VALUES
('赵明', 'crwLVKObrXEyPprOIxraOb9dP2gZhVPtZTWcbvfPEiM=', 'DJV4EvNNgHgxZ/utkm9CuQ==', '杭州软件公司', '朝晖校区', '2024-06-25 09:00:00', '步行', NULL, 'PUBLIC', '2024-06-20 10:00:00', 'APPROVED', NULL, NULL, NULL, NULL, NULL, 1, '2024-06-21 09:00:00'),
('周丽娜', 'ix6v+ri33TGFeQoQfNgfLr9dP2gZhVPtZTWcbvfPEiM=', 'DmogjfT/qQdChd/TvWyhqA==', '浙江省设计院', '屏峰校区', '2024-06-24 14:00:00', '公交', NULL, 'OFFICIAL', '2024-06-19 12:00:00', 'APPROVED', 2, 'D002', '机械工程学院', '李主任', '技术交流', 2, '2024-06-20 10:00:00');

-- 当前有效预约（entry_time为2024-06-27，状态APPROVED）
INSERT INTO `appointment` (
  `visitor_name`, `visitor_id_card`, `visitor_phone`, `visitor_unit`, `campus`, `entry_time`, `transport_mode`, `license_plate`, `appointment_type`, `created_at`, `status`, `official_dept_id`, `official_dept_no`, `official_dept_name`, `official_contact_person`, `official_reason`, `audited_by`, `audited_at`
) VALUES
('吴建华', 'MPwQbeo7XRLdQx9vC0RHCL9dP2gZhVPtZTWcbvfPEiM=', 'GVFbko5H5fmGqVfDHDwlVw==', '杭州网络科技', '朝晖校区', '2024-06-27 10:00:00', '小汽车', '浙A88888', 'PUBLIC', '2024-06-26 09:00:00', 'APPROVED', NULL, NULL, NULL, NULL, NULL, 1, '2024-06-26 12:00:00'),
('林小芳', '4zzQlm9l/aaz5k9U4PeoVKuO9S0dlz/aaZvGtD1nndM=', 'mePycgUWny8Y0ofqHnFUnw==', '浙江省科技厅', '莫干山校区', '2024-06-27 15:00:00', '出租车', NULL, 'OFFICIAL', '2024-06-26 10:00:00', 'APPROVED', 14, 'D104', '人事处', '张处长', '项目合作', 2, '2024-06-26 13:00:00');

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

-- 1. 先ALTER TABLE appointment DROP COLUMN official_dept_name;
# ALTER TABLE appointment DROP COLUMN official_dept_name;

-- 2. 再创建视图
-- CREATE VIEW v_appointment_detail AS
-- SELECT 
--     a.*,
--     d.dept_name as official_dept_name,
--     adm.full_name as audited_by_name
-- FROM appointment a
-- LEFT JOIN department d ON a.official_dept_id = d.id
-- LEFT JOIN admin adm ON a.audited_by = adm.id;

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