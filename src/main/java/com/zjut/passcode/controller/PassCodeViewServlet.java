package com.zjut.passcode.controller;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.zjut.passcode.bean.Appointment;
import com.zjut.passcode.dao.AppointmentDao;
import com.zjut.passcode.util.CryptoUtil;

@WebServlet("/passcode/view")
public class PassCodeViewServlet extends HttpServlet {
    private AppointmentDao appointmentDao = new AppointmentDao();
    private static final String ENCRYPTION_KEY = "campus_pass_key_";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "预约ID不能为空");
            return;
        }
        
        try {
            long appointmentId = Long.parseLong(appointmentIdStr);
            Appointment appointment = appointmentDao.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "预约不存在");
                return;
            }
            
            // 解密敏感信息用于显示
            if (appointment.getVisitorPhone() != null) {
                appointment.setVisitorPhone(CryptoUtil.sm4Decrypt(appointment.getVisitorPhone(), ENCRYPTION_KEY));
            }
            if (appointment.getVisitorIdCard() != null) {
                appointment.setVisitorIdCard(CryptoUtil.sm4Decrypt(appointment.getVisitorIdCard(), ENCRYPTION_KEY));
            }
            
            // 检查通行码是否有效
            boolean isValid = isPassCodeValid(appointment);
            
            // 生成二维码内容
            String qrContent = generateQRContent(appointment, appointment.getVisitorIdCard());
            
            // 生成二维码图片
            String qrCodeBase64 = generateQRCode(qrContent);
            
            // 设置请求属性
            request.setAttribute("appointment", appointment);
            request.setAttribute("isValid", isValid);
            request.setAttribute("qrCodeBase64", qrCodeBase64);
            request.setAttribute("qrContent", qrContent);
            
            // 转发到通行码页面
            request.getRequestDispatcher("/pass_code.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的预约ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "系统错误");
        }
    }
    
    private boolean isPassCodeValid(Appointment appointment) {
        if (!"APPROVED".equals(appointment.getStatus())) {
            return false;
        }
        
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime entryTime = appointment.getEntryTime().toLocalDateTime();
        
        // 通行码在进校当天0点到23:59:59都有效
        LocalDateTime validStart = entryTime.toLocalDate().atStartOfDay();
        LocalDateTime validEnd = entryTime.toLocalDate().atTime(23, 59, 59);
        
        return !now.isBefore(validStart) && !now.isAfter(validEnd);
    }
    
    private String generateQRContent(Appointment appointment, String decryptedIdCard) {
        StringBuilder content = new StringBuilder();
        content.append("姓名:").append(CryptoUtil.maskName(appointment.getVisitorName())).append("\n");
        content.append("身份证:").append(CryptoUtil.maskIdCard(decryptedIdCard)).append("\n");
        content.append("校区:").append(appointment.getCampus()).append("\n");
        content.append("进校时间:").append(appointment.getEntryTime().toLocalDateTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))).append("\n");
        content.append("预约类型:").append("OFFICIAL".equals(appointment.getAppointmentType()) ? "公务预约" : "社会公众预约").append("\n");
        content.append("状态:").append(appointment.getStatus()).append("\n");
        content.append("生成时间:").append(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        
        return content.toString();
    }
    
    private String generateQRCode(String content) {
        try {
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(content, BarcodeFormat.QR_CODE, 200, 200);
            BufferedImage image = new BufferedImage(200, 200, BufferedImage.TYPE_INT_RGB);
            for (int x = 0; x < 200; x++) {
                for (int y = 0; y < 200; y++) {
                    image.setRGB(x, y, bitMatrix.get(x, y) ? 0xFF000000 : 0xFFFFFFFF);
                }
            }
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(image, "png", baos);
            String base64 = java.util.Base64.getEncoder().encodeToString(baos.toByteArray());
            return "data:image/png;base64," + base64;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
} 