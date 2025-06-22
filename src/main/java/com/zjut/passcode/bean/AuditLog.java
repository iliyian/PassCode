package com.zjut.passcode.bean;

import java.sql.Timestamp;

public class AuditLog {
    private long id;
    private int adminId;
    private String adminName;
    private String action;
    private String details;
    private String ipAddress;
    private Timestamp createdAt;
    private String hmacSignature;
    
    public AuditLog() {}
    
    public AuditLog(int adminId, String adminName, String action, String details, String ipAddress) {
        this.adminId = adminId;
        this.adminName = adminName;
        this.action = action;
        this.details = details;
        this.ipAddress = ipAddress;
    }
    
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public int getAdminId() {
        return adminId;
    }
    
    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }
    
    public String getAdminName() {
        return adminName;
    }
    
    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }
    
    public String getAction() {
        return action;
    }
    
    public void setAction(String action) {
        this.action = action;
    }
    
    public String getDetails() {
        return details;
    }
    
    public void setDetails(String details) {
        this.details = details;
    }
    
    public String getIpAddress() {
        return ipAddress;
    }
    
    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getHmacSignature() {
        return hmacSignature;
    }
    
    public void setHmacSignature(String hmacSignature) {
        this.hmacSignature = hmacSignature;
    }
} 