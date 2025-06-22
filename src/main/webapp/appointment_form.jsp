<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>进校预约申请 - 校园通行码系统</title>
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
            max-width: 800px;
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
        
        .form-container {
            padding: 40px;
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 1.3em;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            flex: 1;
        }
        
        .form-group.full-width {
            flex: 1;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s ease;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .required {
            color: #e74c3c;
        }
        
        .accompanying-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }
        
        .accompanying-item {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            background: white;
        }
        
        .accompanying-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .remove-accompanying {
            background: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.9em;
        }
        
        .add-accompanying {
            background: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1em;
            margin-top: 10px;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
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
        
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        
        .official-fields {
            display: none;
        }
        
        .official-fields.show {
            display: block;
        }
        
        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
                gap: 15px;
            }
            
            .form-container {
                padding: 20px;
            }
            
            .header {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 1.5em;
            }
        }
    </style>
</head>
<body>
    <%-- 预约申请页面，用户填写进校预约信息 --%>
    <div class="container">
        <div class="header">
            <h1>📝 进校预约申请</h1>
            <p>请如实填写以下信息，带*为必填项</p>
        </div>
        
        <div class="form-container">
            <% if (request.getAttribute("error") != null) { %>
                <div class="error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/appointment/apply" method="post">
                <!-- 基本信息 -->
                <div class="form-section">
                    <div class="section-title">📋 基本信息</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>预约人姓名 <span class="required">*</span></label>
                            <input type="text" name="visitorName" required>
                        </div>
                        <div class="form-group">
                            <label>身份证号 <span class="required">*</span></label>
                            <input type="text" name="visitorIdCard" required pattern="[0-9Xx]{18}">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>手机号 <span class="required">*</span></label>
                            <input type="tel" name="visitorPhone" required pattern="[0-9]{11}">
                        </div>
                        <div class="form-group">
                            <label>所在单位</label>
                            <input type="text" name="visitorUnit">
                        </div>
                    </div>
                </div>
                
                <!-- 预约信息 -->
                <div class="form-section">
                    <div class="section-title">📅 预约信息</div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>预约校区 <span class="required">*</span></label>
                            <select name="campus" required>
                                <option value="">请选择校区</option>
                                <option value="朝晖校区">朝晖校区</option>
                                <option value="屏峰校区">屏峰校区</option>
                                <option value="莫干山校区">莫干山校区</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>预约进校时间 <span class="required">*</span></label>
                            <input type="datetime-local" name="entryTime" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>交通方式</label>
                            <select name="transportMode">
                                <option value="">请选择交通方式</option>
                                <option value="步行">步行</option>
                                <option value="自行车">自行车</option>
                                <option value="电动车">电动车</option>
                                <option value="汽车">汽车</option>
                                <option value="公共交通">公共交通</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>车牌号</label>
                            <input type="text" name="licensePlate" placeholder="如开车进校请填写">
                        </div>
                    </div>
                </div>
                
                <!-- 预约类型 -->
                <div class="form-section">
                    <div class="section-title">🏢 预约类型</div>
                    <div class="form-row">
                        <div class="form-group full-width">
                            <label>预约类型 <span class="required">*</span></label>
                            <select name="appointmentType" id="appointmentType" required onchange="toggleOfficialFields()">
                                <option value="">请选择预约类型</option>
                                <option value="PUBLIC">社会公众预约</option>
                                <option value="OFFICIAL">公务预约</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- 公务预约特有字段 -->
                    <div class="official-fields" id="officialFields">
                        <div class="form-row">
                            <div class="form-group">
                                <label>公务访问部门 <span class="required">*</span></label>
                                <select name="officialDeptId" required>
                                    <option value="">请选择部门</option>
                                    <option value="1">计算机学院</option>
                                    <option value="2">机械工程学院</option>
                                    <option value="3">化学工程学院</option>
                                    <option value="4">信息工程学院</option>
                                    <option value="5">经济学院</option>
                                    <option value="6">管理学院</option>
                                    <option value="7">理学院</option>
                                    <option value="8">外国语学院</option>
                                    <option value="9">人文学院</option>
                                    <option value="10">艺术学院</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>公务访问接待人 <span class="required">*</span></label>
                                <input type="text" name="officialContactPerson" placeholder="接待老师姓名">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group full-width">
                                <label>来访事由 <span class="required">*</span></label>
                                <textarea name="officialReason" placeholder="请详细说明来访事由"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 随行人员 -->
                <div class="form-section">
                    <div class="section-title">👥 随行人员（可选）</div>
                    <div class="accompanying-section">
                        <div id="accompanyingList">
                            <!-- 随行人员列表将在这里动态生成 -->
                        </div>
                        <button type="button" class="add-accompanying" onclick="addAccompanying()">
                            ➕ 添加随行人员
                        </button>
                    </div>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">📤 提交预约</button>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">🔙 返回首页</a>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        let accompanyingCount = 0;
        
        function toggleOfficialFields() {
            const appointmentType = document.getElementById('appointmentType').value;
            const officialFields = document.getElementById('officialFields');
            
            if (appointmentType === 'OFFICIAL') {
                officialFields.classList.add('show');
                // 设置必填字段
                officialFields.querySelectorAll('input, select, textarea').forEach(field => {
                    field.required = true;
                });
            } else {
                officialFields.classList.remove('show');
                // 移除必填字段
                officialFields.querySelectorAll('input, select, textarea').forEach(field => {
                    field.required = false;
                });
            }
        }
        
        function addAccompanying() {
            accompanyingCount++;
            const accompanyingList = document.getElementById('accompanyingList');
            
            const accompanyingItem = document.createElement('div');
            accompanyingItem.className = 'accompanying-item';
            accompanyingItem.innerHTML = `
                <div class="accompanying-header">
                    <h4>随行人员 ${accompanyingCount}</h4>
                    <button type="button" class="remove-accompanying" onclick="removeAccompanying(this)">删除</button>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>姓名</label>
                        <input type="text" name="accompanyingName" required>
                    </div>
                    <div class="form-group">
                        <label>身份证号</label>
                        <input type="text" name="accompanyingIdCard" required pattern="[0-9Xx]{18}">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>手机号</label>
                        <input type="tel" name="accompanyingPhone" required pattern="[0-9]{11}">
                    </div>
                </div>
            `;
            
            accompanyingList.appendChild(accompanyingItem);
        }
        
        function removeAccompanying(button) {
            button.closest('.accompanying-item').remove();
        }
        
        // 设置默认进校时间为明天上午9点
        window.onload = function() {
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            tomorrow.setHours(9, 0, 0, 0);
            
            const dateTimeLocal = tomorrow.toISOString().slice(0, 16);
            document.querySelector('input[name="entryTime"]').value = dateTimeLocal;
        };
    </script>
</body>
</html> 