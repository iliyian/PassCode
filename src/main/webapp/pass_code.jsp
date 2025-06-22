<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>通行码 - 校园通行码系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 400px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 1.8em;
            margin-bottom: 10px;
        }
        
        .header p {
            opacity: 0.9;
            font-size: 1em;
        }
        
        .passcode-container {
            padding: 30px;
            text-align: center;
        }
        
        .status-indicator {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            font-size: 1.1em;
        }
        
        .status-valid {
            background: #d4edda;
            color: #155724;
            border: 2px solid #c3e6cb;
        }
        
        .status-invalid {
            background: #f8d7da;
            color: #721c24;
            border: 2px solid #f5c6cb;
        }
        
        .qr-code-container {
            margin: 20px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 15px;
        }
        
        .qr-code {
            width: 200px;
            height: 200px;
            margin: 0 auto 15px;
            border: 2px solid #dee2e6;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
        }
        
        .qr-code img {
            max-width: 100%;
            max-height: 100%;
        }
        
        .qr-placeholder {
            color: #6c757d;
            font-size: 0.9em;
            text-align: center;
        }
        
        .info-section {
            margin: 20px 0;
            text-align: left;
        }
        
        .info-title {
            font-size: 1.2em;
            color: #333;
            margin-bottom: 15px;
            font-weight: bold;
            border-bottom: 2px solid #667eea;
            padding-bottom: 5px;
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 8px 0;
            border-bottom: 1px solid #f1f3f4;
        }
        
        .info-label {
            color: #666;
            font-weight: 500;
        }
        
        .info-value {
            color: #333;
            font-weight: bold;
        }
        
        .btn-group {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        .warning {
            background: #fff3cd;
            color: #856404;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            border: 1px solid #ffeaa7;
        }
        
        .note {
            background: #e7f3ff;
            color: #0c5460;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            border: 1px solid #bee5eb;
            font-size: 0.9em;
        }
        
        @media (max-width: 480px) {
            .container {
                margin: 10px;
            }
            
            .header {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 1.5em;
            }
            
            .passcode-container {
                padding: 20px;
            }
            
            .qr-code {
                width: 180px;
                height: 180px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎫 校园通行码</h1>
            <p>请向门卫出示此通行码</p>
        </div>
        
        <div class="passcode-container">
            <!-- 状态指示器 -->
            <div class="status-indicator ${isValid ? 'status-valid' : 'status-invalid'}">
                ${isValid ? '✅ 有效通行码' : '❌ 无效通行码'}
            </div>
            
            <!-- 二维码 -->
            <div class="qr-code-container">
                <div class="qr-code">
                    <c:if test="${not empty qrCodeBase64}">
                        <img src="${qrCodeBase64}" alt="通行码二维码">
                    </c:if>
                    <c:if test="${empty qrCodeBase64}">
                        <div class="qr-placeholder">
                            📱 二维码<br>
                            200×200px
                        </div>
                    </c:if>
                </div>
                <p style="color: #666; font-size: 0.9em;">
                    ${isValid ? '扫描二维码验证通行信息' : '通行码已过期或无效'}
                </p>
            </div>
            
            <!-- 预约信息 -->
            <div class="info-section">
                <div class="info-title">📋 预约信息</div>
                <div class="info-item">
                    <span class="info-label">预约人：</span>
                    <span class="info-value">${maskedVisitorName}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">身份证：</span>
                    <span class="info-value">${maskedIdCard}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">手机号：</span>
                    <span class="info-value">${decryptedPhone}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">所在单位：</span>
                    <span class="info-value">${appointment.visitorUnit}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">预约校区：</span>
                    <span class="info-value">${appointment.campus}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">进校时间：</span>
                    <span class="info-value">
                        <fmt:formatDate value="${appointment.entryTime}" pattern="yyyy-MM-dd HH:mm"/>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">交通方式：</span>
                    <span class="info-value">${appointment.transportMode}</span>
                </div>
                <c:if test="${not empty appointment.licensePlate}">
                    <div class="info-item">
                        <span class="info-label">车牌号：</span>
                        <span class="info-value">${appointment.licensePlate}</span>
                    </div>
                </c:if>
                <div class="info-item">
                    <span class="info-label">预约类型：</span>
                    <span class="info-value">
                        ${appointment.appointmentType == 'OFFICIAL' ? '公务预约' : '社会公众预约'}
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">申请时间：</span>
                    <span class="info-value">
                        <fmt:formatDate value="${appointment.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </span>
                </div>
            </div>
            
            <!-- 公务预约特有信息 -->
            <c:if test="${appointment.appointmentType == 'OFFICIAL'}">
                <div class="info-section">
                    <div class="info-title">🏢 公务信息</div>
                    <div class="info-item">
                        <span class="info-label">访问部门：</span>
                        <span class="info-value">${appointment.officialDeptName}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">接待人：</span>
                        <span class="info-value">${appointment.officialContactPerson}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">来访事由：</span>
                        <span class="info-value">${appointment.officialReason}</span>
                    </div>
                    <c:if test="${not empty appointment.auditedByName}">
                        <div class="info-item">
                            <span class="info-label">审核人：</span>
                            <span class="info-value">${appointment.auditedByName}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">审核时间：</span>
                            <span class="info-value">
                                <fmt:formatDate value="${appointment.auditedAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </span>
                        </div>
                    </c:if>
                </div>
            </c:if>
            
            <!-- 状态说明 -->
            <c:if test="${!isValid}">
                <div class="warning">
                    ⚠️ 通行码已过期或无效，请重新申请预约
                </div>
            </c:if>
            
            <div class="note">
                💡 通行码在进校当天（0:00-23:59）内有效<br>
                🔒 个人信息已进行脱敏处理，保护隐私安全
            </div>
            
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/appointment/apply" class="btn btn-primary">
                    📝 重新预约
                </a>
                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                    🏠 返回首页
                </a>
            </div>
        </div>
    </div>
</body>
</html> 