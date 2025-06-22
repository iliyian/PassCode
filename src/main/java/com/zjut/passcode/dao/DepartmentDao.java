package com.zjut.passcode.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.zjut.passcode.bean.Department;

public class DepartmentDao {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/campus_pass?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "351415341";
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    public boolean addDepartment(Department department) {
        String sql = "INSERT INTO department (dept_no, dept_name, dept_type) VALUES (?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, department.getDeptNo());
            pstmt.setString(2, department.getDeptName());
            pstmt.setString(3, department.getDeptType());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateDepartment(Department department) {
        String sql = "UPDATE department SET dept_no=?, dept_name=?, dept_type=? WHERE id=?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, department.getDeptNo());
            pstmt.setString(2, department.getDeptName());
            pstmt.setString(3, department.getDeptType());
            pstmt.setInt(4, department.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteDepartment(int id) {
        String sql = "DELETE FROM department WHERE id=?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Department getDepartmentById(int id) {
        String sql = "SELECT * FROM department WHERE id=?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Department dept = new Department();
                dept.setId(rs.getInt("id"));
                dept.setDeptNo(rs.getString("dept_no"));
                dept.setDeptName(rs.getString("dept_name"));
                dept.setDeptType(rs.getString("dept_type"));
                return dept;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Department> getAllDepartments() {
        List<Department> departments = new ArrayList<>();
        String sql = "SELECT * FROM department ORDER BY dept_no";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Department dept = new Department();
                dept.setId(rs.getInt("id"));
                dept.setDeptNo(rs.getString("dept_no"));
                dept.setDeptName(rs.getString("dept_name"));
                dept.setDeptType(rs.getString("dept_type"));
                departments.add(dept);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return departments;
    }
    
    public List<Department> getDepartmentsByType(String deptType) {
        List<Department> departments = new ArrayList<>();
        String sql = "SELECT * FROM department WHERE dept_type=? ORDER BY dept_no";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, deptType);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Department dept = new Department();
                dept.setId(rs.getInt("id"));
                dept.setDeptNo(rs.getString("dept_no"));
                dept.setDeptName(rs.getString("dept_name"));
                dept.setDeptType(rs.getString("dept_type"));
                departments.add(dept);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return departments;
    }
} 