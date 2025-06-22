<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.zjut.passcode.bean.Admin" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if admin is logged in
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>统计报告 - 校园通行码系统</title>
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
        
        .reports-content {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .stat-icon {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 1em;
            opacity: 0.9;
        }
        
        .report-section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #e9ecef;
            border-radius: 10px;
        }
        
        .section-title {
            font-size: 1.3em;
            color: #333;
            margin-bottom: 15px;
            font-weight: bold;
        }
        
        .report-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        
        .report-table th,
        .report-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        .report-table th {
            background: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        
        .report-table tr:hover {
            background: #f8f9fa;
        }
        
        .export-btn {
            background: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            margin-top: 20px;
            text-decoration: none;
            display: inline-block;
        }
        
        .export-btn:hover {
            background: #218838;
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
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .report-table {
                font-size: 0.9em;
            }
            
            .report-table th,
            .report-table td {
                padding: 8px 4px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">📈 统计报告系统</div>
        <div class="user-info">
            <div class="user-name">
                管理员：<%= admin.getFullName() %>
            </div>
            <a href="${pageContext.request.contextPath}/admin/index.jsp" class="back-btn">🔙 返回控制台</a>
        </div>
    </div>
    
    <div class="container">
        <div class="page-title">
            <div class="title">统计报告</div>
            <div class="subtitle">查看系统使用统计和报告</div>
        </div>
        
        <div class="reports-content">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">📋</div>
                    <div class="stat-number">0</div>
                    <div class="stat-label">总预约数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">✅</div>
                    <div class="stat-number">0</div>
                    <div class="stat-label">已通过预约</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">❌</div>
                    <div class="stat-number">0</div>
                    <div class="stat-label">已拒绝预约</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">⏳</div>
                    <div class="stat-number">0</div>
                    <div class="stat-label">待审核预约</div>
                </div>
            </div>
            
            <div class="report-section">
                <div class="section-title">预约统计</div>
                <table class="report-table">
                    <thead>
                        <tr>
                            <th>日期</th>
                            <th>预约总数</th>
                            <th>通过数</th>
                            <th>拒绝数</th>
                            <th>通过率</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="5" style="text-align: center; color: #666;">暂无数据</td>
                        </tr>
                    </tbody>
                </table>
                <a href="#" class="export-btn">📊 导出报告</a>
            </div>
            
            <div class="report-section">
                <div class="section-title">用户活跃度</div>
                <table class="report-table">
                    <thead>
                        <tr>
                            <th>管理员</th>
                            <th>登录次数</th>
                            <th>最后登录时间</th>
                            <th>操作次数</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="4" style="text-align: center; color: #666;">暂无数据</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <div class="report-section">
                <div class="section-title">系统性能</div>
                <table class="report-table">
                    <thead>
                        <tr>
                            <th>指标</th>
                            <th>当前值</th>
                            <th>状态</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>数据库连接</td>
                            <td>正常</td>
                            <td style="color: #28a745;">✅ 正常</td>
                        </tr>
                        <tr>
                            <td>系统运行时间</td>
                            <td>0 天 0 小时</td>
                            <td style="color: #28a745;">✅ 正常</td>
                        </tr>
                        <tr>
                            <td>内存使用率</td>
                            <td>0%</td>
                            <td style="color: #28a745;">✅ 正常</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <!-- 申请月度统计 -->
            <div class="report-section">
                <div class="section-title">按申请月度统计</div>
                <table class="report-table">
                    <thead>
                        <tr>
                            <th>申请月份</th>
                            <th>预约次数</th>
                            <th>预约人次</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="row" items="${applyMonthStats}">
                            <tr>
                                <td>${row.month}</td>
                                <td>${row.count}</td>
                                <td>${row.personCount}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty applyMonthStats}">
                            <tr><td colspan="3" style="text-align:center;color:#666;">暂无数据</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <!-- 预约月度统计 -->
            <div class="report-section">
                <div class="section-title">按预约月度统计</div>
                <table class="report-table">
                    <thead>
                        <tr>
                            <th>预约月份</th>
                            <th>预约次数</th>
                            <th>预约人次</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="row" items="${entryMonthStats}">
                            <tr>
                                <td>${row.month}</td>
                                <td>${row.count}</td>
                                <td>${row.personCount}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty entryMonthStats}">
                            <tr><td colspan="3" style="text-align:center;color:#666;">暂无数据</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <!-- 校区统计 -->
            <div class="report-section">
                <div class="section-title">按校区统计</div>
                <table class="report-table">
                    <thead>
                        <tr>
                            <th>校区</th>
                            <th>预约次数</th>
                            <th>预约人次</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="row" items="${campusStats}">
                            <tr>
                                <td>${row.campus}</td>
                                <td>${row.count}</td>
                                <td>${row.personCount}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty campusStats}">
                            <tr><td colspan="3" style="text-align:center;color:#666;">暂无数据</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <!-- 公务访问部门统计 -->
            <div class="report-section">
                <div class="section-title">按公务访问部门统计</div>
                <table class="report-table">
                    <thead>
                        <tr>
                            <th>部门</th>
                            <th>预约次数</th>
                            <th>预约人次</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="row" items="${deptStats}">
                            <tr>
                                <td>${row.deptName}</td>
                                <td>${row.count}</td>
                                <td>${row.personCount}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty deptStats}">
                            <tr><td colspan="3" style="text-align:center;color:#666;">暂无数据</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html> 