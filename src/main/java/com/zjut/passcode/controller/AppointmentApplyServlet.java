package com.zjut.passcode.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.zjut.passcode.bean.Appointment;
import com.zjut.passcode.bean.AuditLog;
import com.zjut.passcode.dao.AppointmentDao;
import com.zjut.passcode.dao.AuditLogDao;
import com.zjut.passcode.util.CryptoUtil;

@WebServlet("/appointment/apply")
public class AppointmentApplyServlet extends HttpServlet {
    private AppointmentDao appointmentDao = new AppointmentDao();
    private AuditLogDao auditLogDao = new AuditLogDao();
    private static final String ENCRYPTION_KEY = "campus_pass_key_";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/appointment_form.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // 获取表单数据
        String visitorName = request.getParameter("visitorName");
        String visitorPhone = request.getParameter("visitorPhone");
        String visitorIdCard = request.getParameter("visitorIdCard");
        String visitorUnit = request.getParameter("visitorUnit");
        String campus = request.getParameter("campus");
        String entryTimeStr = request.getParameter("entryTime");
        String transportMode = request.getParameter("transportMode");
        String licensePlate = request.getParameter("licensePlate");
        String appointmentType = request.getParameter("appointmentType");
        String ipAddress = getClientIpAddress(request);
        
        // 验证必填字段
        if (visitorName == null || visitorName.trim().isEmpty() ||
            visitorPhone == null || visitorPhone.trim().isEmpty() ||
            visitorIdCard == null || visitorIdCard.trim().isEmpty() ||
            campus == null || campus.trim().isEmpty() ||
            entryTimeStr == null || entryTimeStr.trim().isEmpty() ||
            appointmentType == null || appointmentType.trim().isEmpty()) {
            
            request.setAttribute("error", "请填写所有必填字段");
            request.getRequestDispatcher("/appointment_form.jsp").forward(request, response);
            return;
        }
        
        // 验证手机号格式
        if (!visitorPhone.matches("^1[3-9]\\d{9}$")) {
            request.setAttribute("error", "请输入正确的手机号码");
            request.getRequestDispatcher("/appointment_form.jsp").forward(request, response);
            return;
        }
        
        // 验证身份证号格式
        if (!visitorIdCard.matches("^[1-9]\\d{5}(18|19|20)\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$")) {
            request.setAttribute("error", "请输入正确的身份证号码");
            request.getRequestDispatcher("/appointment_form.jsp").forward(request, response);
            return;
        }
        
        // 解析进校时间
        LocalDateTime entryTime;
        try {
            entryTime = LocalDateTime.parse(entryTimeStr, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
        } catch (Exception e) {
            request.setAttribute("error", "进校时间格式错误");
            request.getRequestDispatcher("/appointment_form.jsp").forward(request, response);
            return;
        }
        
        // 验证访问日期（不能是过去的日期）
        if (entryTime.isBefore(LocalDateTime.now())) {
            request.setAttribute("error", "进校时间不能是过去的日期");
            request.getRequestDispatcher("/appointment_form.jsp").forward(request, response);
            return;
        }
        
        try {
            // 创建预约对象
            Appointment appointment = new Appointment();
            appointment.setVisitorName(visitorName.trim());
            appointment.setVisitorPhone(CryptoUtil.sm4Encrypt(visitorPhone.trim(), ENCRYPTION_KEY));
            appointment.setVisitorIdCard(CryptoUtil.sm4Encrypt(visitorIdCard.trim(), ENCRYPTION_KEY));
            appointment.setVisitorUnit(visitorUnit != null ? visitorUnit.trim() : "");
            appointment.setCampus(campus.trim());
            appointment.setEntryTime(Timestamp.valueOf(entryTime));
            appointment.setTransportMode(transportMode != null ? transportMode : "");
            appointment.setLicensePlate(licensePlate != null ? licensePlate.trim() : "");
            appointment.setAppointmentType(appointmentType);
            appointment.setStatus("PENDING");
            appointment.setCreatedAt(Timestamp.valueOf(LocalDateTime.now()));
            
            // 保存预约
            long appointmentId = appointmentDao.addAppointment(appointment);
            if (appointmentId > 0) {
                // 记录审计日志
                AuditLog log = new AuditLog(1, visitorName, "预约申请",
                    "提交预约申请，预约ID: " + appointmentId, ipAddress);
                log.setHmacSignature(CryptoUtil.generateHmacSm3(log.toString()));
                auditLogDao.addAuditLog(log);
                
                // 设置成功信息并跳转
                request.setAttribute("appointmentId", appointmentId);
                request.setAttribute("visitorName", visitorName);
                request.setAttribute("entryTime", entryTimeStr);
                request.getRequestDispatcher("/pass_code.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "预约提交失败，请重试");
                request.getRequestDispatcher("/appointment_form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请稍后重试");
            request.getRequestDispatcher("/appointment_form.jsp").forward(request, response);
        }
    }
    
    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty() && !"unknown".equalsIgnoreCase(xForwardedFor)) {
            return xForwardedFor.split(",")[0];
        }
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty() && !"unknown".equalsIgnoreCase(xRealIp)) {
            return xRealIp;
        }
        return request.getRemoteAddr();
    }
} 