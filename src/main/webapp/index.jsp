<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>校园通行码预约管理系统</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
      * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
      }

      body {
          font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
          background-color: #f5f8fa;
          color: #333;
          line-height: 1.6;
      }

      .header {
          background-color: #fff;
          box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          padding: 15px 0;
      }

      .header-content {
          max-width: 1200px;
          margin: 0 auto;
          padding: 0 20px;
          display: flex;
          justify-content: space-between;
          align-items: center;
      }

      .logo {
          display: flex;
          align-items: center;
      }

      .logo-icon {
          font-size: 28px;
          color: #1a6bc4;
          margin-right: 12px;
      }

      .system-title {
          font-size: 22px;
          font-weight: 600;
          color: #1a6bc4;
      }

      .system-subtitle {
          font-size: 14px;
          color: #666;
          margin-top: 4px;
      }

      .stats {
          display: flex;
          gap: 15px;
      }

      .stat-item {
          background: #e9f0f7;
          padding: 8px 15px;
          border-radius: 4px;
          font-size: 14px;
      }

      .main-container {
          max-width: 1200px;
          margin: 30px auto;
          padding: 0 20px;
      }

      .welcome-section {
          background: #fff;
          border-radius: 8px;
          box-shadow: 0 3px 10px rgba(0,0,0,0.05);
          padding: 30px;
          margin-bottom: 30px;
      }

      .section-title {
          font-size: 20px;
          font-weight: 600;
          color: #1a6bc4;
          padding-bottom: 10px;
          border-bottom: 2px solid #1a6bc4;
          margin-bottom: 20px;
      }

      .welcome-content {
          display: flex;
          gap: 30px;
      }

      .welcome-text {
          flex: 1;
      }

      .welcome-text h2 {
          font-size: 24px;
          margin-bottom: 15px;
          color: #1a6bc4;
      }

      .welcome-text p {
          margin-bottom: 15px;
          color: #555;
      }

      .features {
          margin-top: 20px;
      }

      .feature-item {
          display: flex;
          align-items: center;
          margin-bottom: 12px;
      }

      .feature-icon {
          color: #1a6bc4;
          margin-right: 10px;
          font-size: 18px;
          width: 24px;
          text-align: center;
      }

      .qr-preview {
          flex: 0 0 250px;
          text-align: center;
      }

      .qr-box {
          width: 150px;
          height: 150px;
          background: #e9f0f7;
          border-radius: 6px;
          display: flex;
          align-items: center;
          justify-content: center;
          margin: 0 auto 15px;
      }

      .qr-icon {
          font-size: 50px;
          color: #1a6bc4;
      }

      .qr-text {
          font-weight: 500;
      }

      .qr-note {
          font-size: 13px;
          color: #777;
      }

      .access-section {
          margin-bottom: 30px;
      }

      .access-cards {
          display: flex;
          gap: 20px;
      }

      .access-card {
          flex: 1;
          background: #fff;
          border-radius: 8px;
          box-shadow: 0 3px 10px rgba(0,0,0,0.05);
          padding: 25px;
          text-align: center;
          transition: all 0.3s ease;
      }

      .access-card:hover {
          transform: translateY(-5px);
          box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      }

      .card-icon {
          font-size: 40px;
          color: #1a6bc4;
          margin-bottom: 15px;
      }

      .admin .card-icon {
          color: #28a745;
      }

      .access-card h3 {
          font-size: 18px;
          margin-bottom: 12px;
          color: #333;
      }

      .access-card p {
          color: #666;
          margin-bottom: 20px;
          font-size: 14px;
      }

      .btn-access {
          display: block;
          background: #1a6bc4;
          color: #fff;
          text-decoration: none;
          padding: 10px 20px;
          border-radius: 4px;
          font-weight: 500;
          transition: background 0.3s;
      }

      .btn-access:hover {
          background: #1557a0;
      }

      .admin .btn-access {
          background: #28a745;
      }

      .admin .btn-access:hover {
          background: #218838;
      }

      .footer {
          background: #2c3e50;
          color: #ecf0f1;
          padding: 30px 0 15px;
      }

      .footer-content {
          max-width: 1200px;
          margin: 0 auto;
          padding: 0 20px;
          display: flex;
          justify-content: space-between;
          flex-wrap: wrap;
      }

      .footer-section {
          flex: 1;
          min-width: 250px;
          margin-bottom: 20px;
      }

      .footer-title {
          font-size: 18px;
          margin-bottom: 15px;
          color: #fff;
      }

      .footer-links {
          list-style: none;
      }

      .footer-links li {
          margin-bottom: 8px;
      }

      .footer-links a {
          color: #bdc3c7;
          text-decoration: none;
          transition: color 0.3s;
      }

      .footer-links a:hover {
          color: #fff;
      }

      .contact-info {
          margin-bottom: 8px;
          display: flex;
          align-items: center;
      }

      .contact-icon {
          margin-right: 10px;
          width: 20px;
          text-align: center;
      }

      .copyright {
          text-align: center;
          padding-top: 20px;
          border-top: 1px solid #34495e;
          margin-top: 20px;
          color: #95a5a6;
          font-size: 14px;
      }

      @media (max-width: 768px) {
          .header-content {
              flex-direction: column;
              text-align: center;
          }

          .logo {
              margin-bottom: 15px;
          }

          .stats {
              justify-content: center;
          }

          .welcome-content {
              flex-direction: column;
          }

          .access-cards {
              flex-direction: column;
          }

          .qr-preview {
              margin-top: 20px;
          }
      }
  </style>
</head>
<body>
<!-- 顶部导航 -->
<header class="header">
  <div class="header-content">
    <div class="logo">
      <div class="logo-icon">
        <i class="fas fa-qrcode"></i>
      </div>
      <div>
        <div class="system-title">校园通行码预约管理系统</div>
        <div class="system-subtitle">安全 · 便捷 · 高效的校园通行解决方案</div>
      </div>
    </div>
    <div class="stats">
      <div class="stat-item">
        <i class="fas fa-users"></i> 服务用户: 25,000+
      </div>
      <div class="stat-item">
        <i class="fas fa-check-circle"></i> 处理预约: 86,452次
      </div>
    </div>
  </div>
</header>

<!-- 主要内容区域 -->
<div class="main-container">
  <!-- 欢迎区域 -->
  <section class="welcome-section">
    <div class="welcome-content">
      <div class="welcome-text">
        <h2>欢迎使用校园通行码系统</h2>
        <p>本系统为校外人员提供便捷的校园访问预约服务，为校内管理人员提供高效的通行管理工具。</p>
        <p>采用先进的加密技术和权限管理，保障数据安全与隐私保护，符合等保三级安全标准。</p>

        <div class="features">
          <div class="feature-item">
            <div class="feature-icon">
              <i class="fas fa-check-circle"></i>
            </div>
            <div>手机端便捷预约申请</div>
          </div>
          <div class="feature-item">
            <div class="feature-icon">
              <i class="fas fa-check-circle"></i>
            </div>
            <div>动态通行码生成与管理</div>
          </div>
          <div class="feature-item">
            <div class="feature-icon">
              <i class="fas fa-check-circle"></i>
            </div>
            <div>公务/公众双预约通道</div>
          </div>
          <div class="feature-item">
            <div class="feature-icon">
              <i class="fas fa-check-circle"></i>
            </div>
            <div>多维度数据统计分析</div>
          </div>
          <div class="feature-item">
            <div class="feature-icon">
              <i class="fas fa-check-circle"></i>
            </div>
            <div>国密算法加密保障安全</div>
          </div>
          <div class="feature-item">
            <div class="feature-icon">
              <i class="fas fa-check-circle"></i>
            </div>
            <div>完善的权限管理体系</div>
          </div>
        </div>
      </div>

      <div class="qr-preview">
        <div class="qr-box">
          <i class="fas fa-qrcode qr-icon"></i>
        </div>
        <div class="qr-text">通行码示例</div>
        <div class="qr-note">有效通行码为紫色，无效为灰色</div>
      </div>
    </div>
  </section>

  <!-- 入口选择区域 -->
  <section class="access-section">
    <div class="section-title">系统入口</div>
    <div class="access-cards">
      <div class="access-card">
        <div class="card-icon">
          <i class="fas fa-mobile-alt"></i>
        </div>
        <h3>手机端入口</h3>
        <p>校外人员访问入口，提供预约申请、通行码查看、预约记录查询等功能</p>
        <a href="mobile/appointment.jsp" class="btn-access">
          <i class="fas fa-external-link-alt"></i> 进入手机端
        </a>
      </div>

      <div class="access-card admin">
        <div class="card-icon">
          <i class="fas fa-lock"></i>
        </div>
        <h3>管理端入口</h3>
        <p>管理员登录入口，提供预约管理、数据统计、系统设置等功能</p>
        <a href="admin/login.jsp" class="btn-access">
          <i class="fas fa-sign-in-alt"></i> 管理员登录
        </a>
      </div>
    </div>
  </section>
</div>

<!-- 页脚 -->
<footer class="footer">
  <div class="footer-content">
    <div class="footer-section">
      <div class="footer-title">
        <i class="fas fa-qrcode"></i> 校园通行码预约管理系统
      </div>
      <p>为校园安全管理提供数字化解决方案</p>
      <p>保障校园安全 · 提升管理效率 · 优化访客体验</p>
    </div>

    <div class="footer-section">
      <div class="footer-title">快速链接</div>
      <ul class="footer-links">
        <li><a href="#"><i class="fas fa-angle-right"></i> 使用帮助</a></li>
        <li><a href="#"><i class="fas fa-angle-right"></i> 常见问题</a></li>
        <li><a href="#"><i class="fas fa-angle-right"></i> 隐私政策</a></li>
        <li><a href="#"><i class="fas fa-angle-right"></i> 关于我们</a></li>
      </ul>
    </div>

    <div class="footer-section">
      <div class="footer-title">联系我们</div>
      <div class="contact-info">
        <div class="contact-icon">
          <i class="fas fa-envelope"></i>
        </div>
        <div>support@campus-pass.com</div>
      </div>
      <div class="contact-info">
        <div class="contact-icon">
          <i class="fas fa-phone"></i>
        </div>
        <div>(021) 1234-5678</div>
      </div>
      <div class="contact-info">
        <div class="contact-icon">
          <i class="fas fa-map-marker-alt"></i>
        </div>
        <div>智慧校园信息中心</div>
      </div>
    </div>
  </div>

  <div class="copyright">
    &copy; 2023 校园通行码预约管理系统 | 采用国密算法保障数据安全 | 等保三级认证
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>