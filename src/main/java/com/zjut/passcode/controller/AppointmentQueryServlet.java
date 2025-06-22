package com.zjut.passcode.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.zjut.passcode.bean.Appointment;
import com.zjut.passcode.dao.AppointmentDao;
import com.zjut.passcode.util.CryptoUtil;

@WebServlet("/appointment/query")
public class AppointmentQueryServlet extends HttpServlet {
    private AppointmentDao appointmentDao = new AppointmentDao();
    private static final String ENCRYPTION_KEY = "campus_pass_key_2024";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/my_appointments.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String visitorName = request.getParameter("visitorName");
        String visitorPhone = request.getParameter("visitorPhone");
        String visitorIdCard = request.getParameter("visitorIdCard");
        
        // 验证至少提供一个查询条件
        if ((visitorName == null || visitorName.trim().isEmpty()) &&
            (visitorPhone == null || visitorPhone.trim().isEmpty()) &&
            (visitorIdCard == null || visitorIdCard.trim().isEmpty())) {
            request.setAttribute("error", "请至少提供一个查询条件");
            request.getRequestDispatcher("/my_appointments.jsp").forward(request, response);
            return;
        }
        
        try {
            // 加密查询条件
            String encryptedPhone = null;
            String encryptedIdCard = null;
            
            if (visitorPhone != null && !visitorPhone.trim().isEmpty()) {
                encryptedPhone = CryptoUtil.sm4Encrypt(visitorPhone.trim(), ENCRYPTION_KEY);
            }
            if (visitorIdCard != null && !visitorIdCard.trim().isEmpty()) {
                encryptedIdCard = CryptoUtil.sm4Encrypt(visitorIdCard.trim(), ENCRYPTION_KEY);
            }
            
            // 查询预约记录 - 使用现有的方法
            List<Appointment> appointments = appointmentDao.getAppointmentsByVisitor(
                visitorName != null ? visitorName.trim() : "",
                encryptedIdCard != null ? encryptedIdCard : "",
                encryptedPhone != null ? encryptedPhone : ""
            );
            
            // 解密敏感信息用于显示
            for (Appointment appointment : appointments) {
                if (appointment.getVisitorPhone() != null) {
                    appointment.setVisitorPhone(CryptoUtil.sm4Decrypt(appointment.getVisitorPhone(), ENCRYPTION_KEY));
                }
                if (appointment.getVisitorIdCard() != null) {
                    appointment.setVisitorIdCard(CryptoUtil.sm4Decrypt(appointment.getVisitorIdCard(), ENCRYPTION_KEY));
                }
            }
            
            request.setAttribute("appointments", appointments);
            request.setAttribute("queryName", visitorName);
            request.setAttribute("queryPhone", visitorPhone);
            request.setAttribute("queryIdCard", visitorIdCard);
            
            if (appointments.isEmpty()) {
                request.setAttribute("message", "未找到相关预约记录");
            }
            
            request.getRequestDispatcher("/my_appointments.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "查询失败，请重试");
            request.getRequestDispatcher("/my_appointments.jsp").forward(request, response);
        }
    }
} 