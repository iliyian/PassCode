<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的预约 - 校园通行码系统</title>
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
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
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
            font-size: 2em;
            margin-bottom: 10px;
        }
        
        .header p {
            opacity: 0.9;
            font-size: 1.1em;
        }
        
        .content {
            padding: 40px;
        }
        
        .search-form {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .form-title {
            font-size: 1.3em;
            color: #333;
            margin-bottom: 20px;
            font-weight: bold;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            flex: 1;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s ease;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
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
        
        .btn-small {
            padding: 8px 15px;
            font-size: 0.9em;
        }
        
        .results-section {
            margin-top: 30px;
        }
        
        .results-title {
            font-size: 1.3em;
            color: #333;
            margin-bottom: 20px;
            font-weight: bold;
        }
        
        .appointment-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }
        
        .appointment-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #f1f3f4;
        }
        
        .card-title {
            font-size: 1.2em;
            color: #333;
            font-weight: bold;
        }
        
        .status-badge {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-approved {
            background: #d4edda;
            color: #155724;
        }
        
        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }
        
        .card-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
        }
        
        .info-label {
            color: #666;
            font-size: 0.9em;
            margin-bottom: 5px;
        }
        
        .info-value {
            color: #333;
            font-weight: 500;
        }
        
        .card-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        
        .message {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .message-info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        
        .message-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .no-results {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .no-results-icon {
            font-size: 3em;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
                gap: 15px;
            }
            
            .content {
                padding: 20px;
            }
            
            .header {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 1.5em;
            }
            
            .card-content {
                grid-template-columns: 1fr;
            }
            
            .card-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📋 我的预约</h1>
            <p>查询您的预约记录和通行码</p>
        </div>
        
        <div class="content">
            <!-- 查询表单 -->
            <div class="search-form">
                <div class="form-title">🔍 查询预约</div>
                <form action="${pageContext.request.contextPath}/appointment/query" method="post">
                    <div class="form-row">
                        <div class="form-group">
                            <label>姓名 <span style="color: #e74c3c;">*</span></label>
                            <input type="text" name="visitorName" value="${visitorName}" required>
                        </div>
                        <div class="form-group">
                            <label>身份证号 <span style="color: #e74c3c;">*</span></label>
                            <input type="text" name="visitorIdCard" value="${visitorIdCard}" required pattern="[0-9Xx]{18}">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>手机号 <span style="color: #e74c3c;">*</span></label>
                            <input type="tel" name="visitorPhone" value="${visitorPhone}" required pattern="[0-9]{11}">
                        </div>
                    </div>
                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">🔍 查询预约</button>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">🏠 返回首页</a>
                    </div>
                </form>
            </div>
            
            <!-- 消息提示 -->
            <c:if test="${not empty error}">
                <div class="message message-error">
                    ❌ ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty message}">
                <div class="message message-info">
                    ℹ️ ${message}
                </div>
            </c:if>
            
            <!-- 查询结果 -->
            <c:if test="${not empty appointments}">
                <div class="results-section">
                    <div class="results-title">📊 查询结果 (${appointments.size()} 条记录)</div>
                    
                    <c:forEach var="appointment" items="${appointments}">
                        <div class="appointment-card">
                            <div class="card-header">
                                <div class="card-title">
                                    ${appointment.visitorName} - ${appointment.campus}
                                </div>
                                <div class="status-badge status-${appointment.status.toLowerCase()}">
                                    <c:choose>
                                        <c:when test="${appointment.status == 'PENDING'}">⏳ 待审核</c:when>
                                        <c:when test="${appointment.status == 'APPROVED'}">✅ 已通过</c:when>
                                        <c:when test="${appointment.status == 'REJECTED'}">❌ 已拒绝</c:when>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="card-content">
                                <div class="info-item">
                                    <span class="info-label">身份证号</span>
                                    <span class="info-value">${appointment.visitorIdCard}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">手机号</span>
                                    <span class="info-value">${appointment.visitorPhone}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">所在单位</span>
                                    <span class="info-value">${appointment.visitorUnit}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">进校时间</span>
                                    <span class="info-value">
                                        <fmt:formatDate value="${appointment.entryTime}" pattern="yyyy-MM-dd HH:mm"/>
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">交通方式</span>
                                    <span class="info-value">${appointment.transportMode}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">预约类型</span>
                                    <span class="info-value">
                                        ${appointment.appointmentType == 'OFFICIAL' ? '公务预约' : '社会公众预约'}
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">申请时间</span>
                                    <span class="info-value">
                                        <fmt:formatDate value="${appointment.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                    </span>
                                </div>
                                <c:if test="${appointment.appointmentType == 'OFFICIAL'}">
                                    <div class="info-item">
                                        <span class="info-label">访问部门</span>
                                        <span class="info-value">${appointment.officialDeptName}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">接待人</span>
                                        <span class="info-value">${appointment.officialContactPerson}</span>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="card-actions">
                                <a href="${pageContext.request.contextPath}/passcode/view?id=${appointment.id}" 
                                   class="btn btn-primary btn-small">
                                    👁️ 查看通行码
                                </a>
                                <c:if test="${appointment.status == 'PENDING'}">
                                    <span class="btn btn-secondary btn-small" style="cursor: default;">
                                        ⏳ 等待审核
                                    </span>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            
            <!-- 无结果提示 -->
            <c:if test="${empty appointments && not empty visitorName}">
                <div class="no-results">
                    <div class="no-results-icon">📭</div>
                    <h3>未找到预约记录</h3>
                    <p>请检查您输入的信息是否正确，或尝试重新申请预约。</p>
                    <a href="${pageContext.request.contextPath}/appointment/apply" class="btn btn-primary" style="margin-top: 20px;">
                        📝 申请新预约
                    </a>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html> 