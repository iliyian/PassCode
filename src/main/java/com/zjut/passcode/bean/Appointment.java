package com.zjut.passcode.bean;

import java.sql.Timestamp;
import java.util.List;

/**
 * 预约实体类，封装预约相关信息。
 */
public class Appointment {
    /** 预约ID */
    private long id;
    /** 访客姓名 */
    private String visitorName;
    /** 访客身份证号 */
    private String visitorIdCard;
    /** 访客手机号 */
    private String visitorPhone;
    /** 访客单位 */
    private String visitorUnit;
    /** 校区 */
    private String campus;
    /** 进校时间 */
    private Timestamp entryTime;
    /** 交通方式 */
    private String transportMode;
    /** 车牌号 */
    private String licensePlate;
    /** 预约类型 */
    private String appointmentType;
    /** 创建时间 */
    private Timestamp createdAt;
    /** 预约状态 */
    private String status;
    /** 公务访问部门ID */
    private Integer officialDeptId;
    /** 公务联系人 */
    private String officialContactPerson;
    /** 公务事由 */
    private String officialReason;
    /** 审核人ID */
    private Integer auditedBy;
    /** 审核时间 */
    private Timestamp auditedAt;
    /** 公务访问部门名称 */
    private String officialDeptName;
    /** 审核人姓名 */
    private String auditedByName;
    /** 公务访问部门编号 */
    private String officialDeptNo;
    /** 随行人员列表 */
    private List<AccompanyingPerson> accompanyingPersons;
    
    /**
     * 无参构造方法。
     */
    public Appointment() {}
    
    /**
     * 带参数构造方法。
     * @param visitorName 访客姓名
     * @param visitorIdCard 访客身份证号
     * @param visitorPhone 访客手机号
     * @param visitorUnit 访客单位
     * @param campus 校区
     * @param entryTime 进校时间
     * @param transportMode 交通方式
     * @param licensePlate 车牌号
     * @param appointmentType 预约类型
     */
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
    
    public String getOfficialDeptNo() {
        return officialDeptNo;
    }
    
    public void setOfficialDeptNo(String officialDeptNo) {
        this.officialDeptNo = officialDeptNo;
    }
    
    public List<AccompanyingPerson> getAccompanyingPersons() {
        return accompanyingPersons;
    }
    
    public void setAccompanyingPersons(List<AccompanyingPerson> accompanyingPersons) {
        this.accompanyingPersons = accompanyingPersons;
    }
} 