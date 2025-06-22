package com.zjut.passcode.bean;

public class Department {
    private int id;
    private String deptNo;
    private String deptName;
    private String deptType;
    
    public Department() {}
    
    public Department(String deptNo, String deptName, String deptType) {
        this.deptNo = deptNo;
        this.deptName = deptName;
        this.deptType = deptType;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getDeptNo() {
        return deptNo;
    }
    
    public void setDeptNo(String deptNo) {
        this.deptNo = deptNo;
    }
    
    public String getDeptName() {
        return deptName;
    }
    
    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }
    
    public String getDeptType() {
        return deptType;
    }
    
    public void setDeptType(String deptType) {
        this.deptType = deptType;
    }
} 