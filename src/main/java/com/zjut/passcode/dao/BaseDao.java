package com.zjut.passcode.dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class BaseDao {
    private static String DB_URL;
    private static String DB_USER;
    private static String DB_PASSWORD;
    private static String DB_DRIVER;

    static {
        loadDatabaseConfig();
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     * 加载数据库配置文件
     */
    private static void loadDatabaseConfig() {
        Properties props = new Properties();
        InputStream input = null;
        
        try {
            // 方法1: 尝试从classpath加载（WEB-INF/classes目录）
            input = BaseDao.class.getClassLoader().getResourceAsStream("db.properties");
            if (input != null) {
                System.out.println("成功从classpath加载配置文件");
            }
            
            // 方法2: 如果classpath没有，尝试从当前工作目录加载
            if (input == null) {
                try {
                    input = new java.io.FileInputStream("db.properties");
                    System.out.println("成功从当前工作目录加载配置文件");
                } catch (IOException e) {
                    // 继续尝试其他方法
                }
            }
            
            // 方法3: 尝试从上级目录加载
            if (input == null) {
                try {
                    input = new java.io.FileInputStream("../db.properties");
                    System.out.println("成功从上级目录加载配置文件");
                } catch (IOException e) {
                    // 继续尝试其他方法
                }
            }
            
            if (input == null) {
                throw new RuntimeException("无法找到数据库配置文件 db.properties");
            }
            
            props.load(input);
            
            DB_URL = props.getProperty("db.url");
            DB_USER = props.getProperty("db.username");
            DB_PASSWORD = props.getProperty("db.password");
            DB_DRIVER = props.getProperty("db.driver");
            
            // 验证必要的配置项
            if (DB_URL == null || DB_USER == null || DB_PASSWORD == null || DB_DRIVER == null) {
                throw new RuntimeException("数据库配置文件缺少必要的配置项");
            }
            
            System.out.println("数据库配置加载成功");
            
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("无法加载数据库配置文件: " + e.getMessage());
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    public void close(Connection conn, Statement stmt, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (Exception e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }

    public void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }

    public void close(Connection conn) {
        close(conn, null, null);
    }
} 