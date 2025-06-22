package com.zjut.passcode.bean;

public class AccompanyingPerson {
    private long id;
    private long appointmentId;
    private String fullName;
    private String idCard;
    private String phone;
    
    public AccompanyingPerson() {}
    
    public AccompanyingPerson(long appointmentId, String fullName, String idCard, String phone) {
        this.appointmentId = appointmentId;
        this.fullName = fullName;
        this.idCard = idCard;
        this.phone = phone;
    }
    
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public long getAppointmentId() {
        return appointmentId;
    }
    
    public void setAppointmentId(long appointmentId) {
        this.appointmentId = appointmentId;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getIdCard() {
        return idCard;
    }
    
    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
} 