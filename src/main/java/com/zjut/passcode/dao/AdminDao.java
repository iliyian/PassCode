package com.zjut.passcode.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.zjut.passcode.bean.Admin;

public class AdminDao {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/campus_pass?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "password";
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    public boolean addAdmin(Admin admin) {
        String sql = "INSERT INTO admin (login_name, password_hash, full_name, dept_id, phone, role) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, admin.getLoginName());
            pstmt.setString(2, admin.getPasswordHash());
            pstmt.setString(3, admin.getFullName());
            pstmt.setInt(4, admin.getDeptId());
            pstmt.setString(5, admin.getPhone());
            pstmt.setString(6, admin.getRole());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateAdmin(Admin admin) {
        String sql = "UPDATE admin SET login_name=?, full_name=?, dept_id=?, phone=?, role=? WHERE id=?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, admin.getLoginName());
            pstmt.setString(2, admin.getFullName());
            pstmt.setInt(3, admin.getDeptId());
            pstmt.setString(4, admin.getPhone());
            pstmt.setString(5, admin.getRole());
            pstmt.setInt(6, admin.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updatePassword(int adminId, String newPasswordHash) {
        String sql = "UPDATE admin SET password_hash=?, password_last_changed=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newPasswordHash);
            pstmt.setInt(2, adminId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteAdmin(int id) {
        String sql = "DELETE FROM admin WHERE id=?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Admin getAdminById(int id) {
        String sql = "SELECT a.*, d.dept_name FROM admin a LEFT JOIN department d ON a.dept_id = d.id WHERE a.id=?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setLoginName(rs.getString("login_name"));
                admin.setPasswordHash(rs.getString("password_hash"));
                admin.setFullName(rs.getString("full_name"));
                admin.setDeptId(rs.getInt("dept_id"));
                admin.setPhone(rs.getString("phone"));
                admin.setRole(rs.getString("role"));
                admin.setPasswordLastChanged(rs.getTimestamp("password_last_changed"));
                admin.setFailedLoginAttempts(rs.getInt("failed_login_attempts"));
                admin.setLockoutUntil(rs.getTimestamp("lockout_until"));
                admin.setDeptName(rs.getString("dept_name"));
                return admin;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Admin getAdminByLoginName(String loginName) {
        String sql = "SELECT a.*, d.dept_name FROM admin a LEFT JOIN department d ON a.dept_id = d.id WHERE a.login_name=?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, loginName);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setLoginName(rs.getString("login_name"));
                admin.setPasswordHash(rs.getString("password_hash"));
                admin.setFullName(rs.getString("full_name"));
                admin.setDeptId(rs.getInt("dept_id"));
                admin.setPhone(rs.getString("phone"));
                admin.setRole(rs.getString("role"));
                admin.setPasswordLastChanged(rs.getTimestamp("password_last_changed"));
                admin.setFailedLoginAttempts(rs.getInt("failed_login_attempts"));
                admin.setLockoutUntil(rs.getTimestamp("lockout_until"));
                admin.setDeptName(rs.getString("dept_name"));
                return admin;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Admin> getAllAdmins() {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT a.*, d.dept_name FROM admin a LEFT JOIN department d ON a.dept_id = d.id ORDER BY a.id";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setLoginName(rs.getString("login_name"));
                admin.setPasswordHash(rs.getString("password_hash"));
                admin.setFullName(rs.getString("full_name"));
                admin.setDeptId(rs.getInt("dept_id"));
                admin.setPhone(rs.getString("phone"));
                admin.setRole(rs.getString("role"));
                admin.setPasswordLastChanged(rs.getTimestamp("password_last_changed"));
                admin.setFailedLoginAttempts(rs.getInt("failed_login_attempts"));
                admin.setLockoutUntil(rs.getTimestamp("lockout_until"));
                admin.setDeptName(rs.getString("dept_name"));
                admins.add(admin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return admins;
    }
    
    public boolean updateFailedLoginAttempts(int adminId, int attempts) {
        String sql = "UPDATE admin SET failed_login_attempts=? WHERE id=?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, attempts);
            pstmt.setInt(2, adminId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean setLockoutUntil(int adminId, Timestamp lockoutUntil) {
        String sql = "UPDATE admin SET lockout_until=? WHERE id=?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setTimestamp(1, lockoutUntil);
            pstmt.setInt(2, adminId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean resetFailedLoginAttempts(int adminId) {
        String sql = "UPDATE admin SET failed_login_attempts=0, lockout_until=NULL WHERE id=?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, adminId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
} 