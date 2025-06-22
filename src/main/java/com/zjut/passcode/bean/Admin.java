package com.zjut.passcode.bean;

import java.sql.Timestamp;

public class Admin {
    private int id;
    private String loginName;
    private String passwordHash;
    private String fullName;
    private int deptId;
    private String phone;
    private String role;
    private Timestamp passwordLastChanged;
    private int failedLoginAttempts;
    private Timestamp lockoutUntil;
    private String deptName; // 用于显示
    
    public Admin() {}
    
    public Admin(String loginName, String passwordHash, String fullName, int deptId, String phone, String role) {
        this.loginName = loginName;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.deptId = deptId;
        this.phone = phone;
        this.role = role;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getLoginName() {
        return loginName;
    }
    
    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }
    
    public String getPasswordHash() {
        return passwordHash;
    }
    
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public int getDeptId() {
        return deptId;
    }
    
    public void setDeptId(int deptId) {
        this.deptId = deptId;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public Timestamp getPasswordLastChanged() {
        return passwordLastChanged;
    }
    
    public void setPasswordLastChanged(Timestamp passwordLastChanged) {
        this.passwordLastChanged = passwordLastChanged;
    }
    
    public int getFailedLoginAttempts() {
        return failedLoginAttempts;
    }
    
    public void setFailedLoginAttempts(int failedLoginAttempts) {
        this.failedLoginAttempts = failedLoginAttempts;
    }
    
    public Timestamp getLockoutUntil() {
        return lockoutUntil;
    }
    
    public void setLockoutUntil(Timestamp lockoutUntil) {
        this.lockoutUntil = lockoutUntil;
    }
    
    public String getDeptName() {
        return deptName;
    }
    
    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }
} 