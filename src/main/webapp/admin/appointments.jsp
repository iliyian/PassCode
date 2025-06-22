<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.zjut.passcode.bean.Admin" %>
<%@ page import="com.zjut.passcode.bean.Appointment" %>
<%@ page import="java.util.List" %>
<%
    // Check if admin is logged in
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login");
        return;
    }
    
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预约管理 - 校园通行码系统</title>
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
        }
        
        .header {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 1.5em;
            font-weight: bold;
            color: #333;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-name {
            color: #333;
            font-weight: 500;
        }
        
        .back-btn {
            background: #6c757d;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9em;
        }
        
        .back-btn:hover {
            background: #5a6268;
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .page-title {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .title {
            font-size: 2em;
            color: #333;
            margin-bottom: 10px;
        }
        
        .subtitle {
            color: #666;
            font-size: 1.1em;
        }
        
        .appointments-content {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .appointments-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .appointments-table th,
        .appointments-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        .appointments-table th {
            background: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        
        .appointments-table tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
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
        
        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.8em;
            margin: 2px;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-approve {
            background: #28a745;
            color: white;
        }
        
        .btn-reject {
            background: #dc3545;
            color: white;
        }
        
        .btn-view {
            background: #17a2b8;
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .empty-state h3 {
            margin-bottom: 10px;
            color: #333;
        }
        
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
            }
            
            .user-info {
                flex-direction: column;
                gap: 10px;
            }
            
            .title {
                font-size: 1.5em;
            }
            
            .appointments-table {
                font-size: 0.9em;
            }
            
            .appointments-table th,
            .appointments-table td {
                padding: 8px 4px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">📋 预约管理系统</div>
        <div class="user-info">
            <div class="user-name">
                管理员：<%= admin.getFullName() %>
            </div>
            <a href="${pageContext.request.contextPath}/admin/index.jsp" class="back-btn">🔙 返回控制台</a>
        </div>
    </div>
    
    <div class="container">
        <div class="page-title">
            <div class="title">预约管理</div>
            <div class="subtitle">查看、审核和管理访客预约申请</div>
        </div>
        
        <div class="appointments-content">
            <% if (appointments != null && !appointments.isEmpty()) { %>
                <table class="appointments-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>访客姓名</th>
                            <th>预约类型</th>
                            <th>进校时间</th>
                            <th>校区</th>
                            <th>状态</th>
                            <th>申请时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Appointment appointment : appointments) { %>
                            <tr>
                                <td><%= appointment.getId() %></td>
                                <td><%= appointment.getVisitorName() %></td>
                                <td><%= getAppointmentTypeDisplay(appointment.getAppointmentType()) %></td>
                                <td><%= appointment.getEntryTime() %></td>
                                <td><%= appointment.getCampus() %></td>
                                <td>
                                    <span class="status-badge status-<%= appointment.getStatus().toLowerCase() %>">
                                        <%= getStatusDisplay(appointment.getStatus()) %>
                                    </span>
                                </td>
                                <td><%= appointment.getCreatedAt() %></td>
                                <td>
                                    <a href="<%=request.getContextPath()%>/passcode/view?id=<%= appointment.getId() %>" class="action-btn btn-view" target="_blank">查看</a>
                                    <% if ("PENDING".equals(appointment.getStatus())) { %>
                                        <form method="post" action="<%=request.getContextPath()%>/admin/appointments" style="display:inline;" onsubmit="return confirmApprove();">
                                            <input type="hidden" name="action" value="approve" />
                                            <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>" />
                                            <button type="submit" class="action-btn btn-approve">通过</button>
                                        </form>
                                        <form method="post" action="<%=request.getContextPath()%>/admin/appointments" style="display:inline;" onsubmit="return confirmReject();">
                                            <input type="hidden" name="action" value="reject" />
                                            <input type="hidden" name="appointmentId" value="<%= appointment.getId() %>" />
                                            <button type="submit" class="action-btn btn-reject">拒绝</button>
                                        </form>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <h3>暂无预约记录</h3>
                    <p>当前系统中没有预约申请记录</p>
                </div>
            <% } %>
        </div>
    </div>
    
    <%!
    private String getAppointmentTypeDisplay(String type) {
        switch (type) {
            case "PUBLIC":
                return "个人访问";
            case "OFFICIAL":
                return "公务访问";
            default:
                return type;
        }
    }
    
    private String getStatusDisplay(String status) {
        switch (status) {
            case "PENDING":
                return "待审核";
            case "APPROVED":
                return "已通过";
            case "REJECTED":
                return "已拒绝";
            default:
                return status;
        }
    }
    %>
    <script>
    function confirmApprove() {
        return confirm('确定要通过该预约吗？');
    }
    function confirmReject() {
        return confirm('确定要拒绝该预约吗？');
    }
    </script>
</body>
</html> 