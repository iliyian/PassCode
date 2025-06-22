package com.zjut.passcode.bean;

import java.sql.Timestamp;
import java.util.List;

public class Appointment {
    private long id;
    private String visitorName;
    private String visitorIdCard;
    private String visitorPhone;
    private String visitorUnit;
    private String campus;
    private Timestamp entryTime;
    private String transportMode;
    private String licensePlate;
    private String appointmentType;
    private Timestamp createdAt;
    private String status;
    private Integer officialDeptId;
    private String officialContactPerson;
    private String officialReason;
    private Integer auditedBy;
    private Timestamp auditedAt;
    private String officialDeptName; // 用于显示
    private String auditedByName; // 用于显示
    private List<AccompanyingPerson> accompanyingPersons; // 随行人员列表
    
    public Appointment() {}
    
    public Appointment(String visitorName, String visitorIdCard, String visitorPhone, 
                      String visitorUnit, String campus, Timestamp entryTime, 
                      String transportMode, String licensePlate, String appointmentType) {
        this.visitorName = visitorName;
        this.visitorIdCard = visitorIdCard;
        this.visitorPhone = visitorPhone;
        this.visitorUnit = visitorUnit;
        this.campus = campus;
        this.entryTime = entryTime;
        this.transportMode = transportMode;
        this.licensePlate = licensePlate;
        this.appointmentType = appointmentType;
        this.status = "PENDING";
    }
    
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public String getVisitorName() {
        return visitorName;
    }
    
    public void setVisitorName(String visitorName) {
        this.visitorName = visitorName;
    }
    
    public String getVisitorIdCard() {
        return visitorIdCard;
    }
    
    public void setVisitorIdCard(String visitorIdCard) {
        this.visitorIdCard = visitorIdCard;
    }
    
    public String getVisitorPhone() {
        return visitorPhone;
    }
    
    public void setVisitorPhone(String visitorPhone) {
        this.visitorPhone = visitorPhone;
    }
    
    public String getVisitorUnit() {
        return visitorUnit;
    }
    
    public void setVisitorUnit(String visitorUnit) {
        this.visitorUnit = visitorUnit;
    }
    
    public String getCampus() {
        return campus;
    }
    
    public void setCampus(String campus) {
        this.campus = campus;
    }
    
    public Timestamp getEntryTime() {
        return entryTime;
    }
    
    public void setEntryTime(Timestamp entryTime) {
        this.entryTime = entryTime;
    }
    
    public String getTransportMode() {
        return transportMode;
    }
    
    public void setTransportMode(String transportMode) {
        this.transportMode = transportMode;
    }
    
    public String getLicensePlate() {
        return licensePlate;
    }
    
    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }
    
    public String getAppointmentType() {
        return appointmentType;
    }
    
    public void setAppointmentType(String appointmentType) {
        this.appointmentType = appointmentType;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Integer getOfficialDeptId() {
        return officialDeptId;
    }
    
    public void setOfficialDeptId(Integer officialDeptId) {
        this.officialDeptId = officialDeptId;
    }
    
    public String getOfficialContactPerson() {
        return officialContactPerson;
    }
    
    public void setOfficialContactPerson(String officialContactPerson) {
        this.officialContactPerson = officialContactPerson;
    }
    
    public String getOfficialReason() {
        return officialReason;
    }
    
    public void setOfficialReason(String officialReason) {
        this.officialReason = officialReason;
    }
    
    public Integer getAuditedBy() {
        return auditedBy;
    }
    
    public void setAuditedBy(Integer auditedBy) {
        this.auditedBy = auditedBy;
    }
    
    public Timestamp getAuditedAt() {
        return auditedAt;
    }
    
    public void setAuditedAt(Timestamp auditedAt) {
        this.auditedAt = auditedAt;
    }
    
    public String getOfficialDeptName() {
        return officialDeptName;
    }
    
    public void setOfficialDeptName(String officialDeptName) {
        this.officialDeptName = officialDeptName;
    }
    
    public String getAuditedByName() {
        return auditedByName;
    }
    
    public void setAuditedByName(String auditedByName) {
        this.auditedByName = auditedByName;
    }
    
    public List<AccompanyingPerson> getAccompanyingPersons() {
        return accompanyingPersons;
    }
    
    public void setAccompanyingPersons(List<AccompanyingPerson> accompanyingPersons) {
        this.accompanyingPersons = accompanyingPersons;
    }
} 