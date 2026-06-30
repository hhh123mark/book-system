<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="${sessionScope.csrfToken}">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>用户登录 - 图书管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js" charset="UTF-8"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
        }
        
        .auth-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            position: relative;
            overflow: hidden;
        }
        
        .auth-container::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: 
                radial-gradient(circle at 20% 80%, rgba(255, 255, 255, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.12) 0%, transparent 50%),
                radial-gradient(circle at 50% 50%, rgba(255, 255, 255, 0.05) 0%, transparent 70%);
            animation: float 20s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(30px, -30px) rotate(5deg); }
            66% { transform: translate(-20px, 20px) rotate(-5deg); }
        }
        
        .floating-shapes {
            position: absolute;
            width: 100%;
            height: 100%;
            overflow: hidden;
            pointer-events: none;
        }
        
        .shape {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: floatShape 15s ease-in-out infinite;
        }
        
        .shape:nth-child(1) {
            width: 80px;
            height: 80px;
            top: 10%;
            left: 10%;
            animation-delay: 0s;
        }
        
        .shape:nth-child(2) {
            width: 120px;
            height: 120px;
            top: 60%;
            right: 10%;
            animation-delay: -5s;
        }
        
        .shape:nth-child(3) {
            width: 60px;
            height: 60px;
            bottom: 20%;
            left: 20%;
            animation-delay: -10s;
        }
        
        .shape:nth-child(4) {
            width: 100px;
            height: 100px;
            top: 30%;
            right: 25%;
            animation-delay: -7s;
        }
        
        @keyframes floatShape {
            0%, 100% { transform: translateY(0) rotate(0deg); opacity: 0.6; }
            50% { transform: translateY(-30px) rotate(180deg); opacity: 0.3; }
        }
        
        .auth-card {
            width: 100%;
            max-width: 420px;
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.3);
            padding: 48px 40px;
            animation: slideUp 0.6s ease;
            position: relative;
            z-index: 1;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .auth-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667EEA, #764BA2, #F093FB, #667EEA);
            background-size: 300% 100%;
            animation: gradientLine 3s ease infinite;
            border-radius: 24px 24px 0 0;
        }
        
        @keyframes gradientLine {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        .auth-header {
            text-align: center;
            margin-bottom: 36px;
        }
        
        .auth-logo {
            width: 72px;
            height: 72px;
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 2.5rem;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
            animation: logoFloat 3s ease-in-out infinite;
        }
        
        @keyframes logoFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }
        
        .auth-header h1 {
            font-size: 1.75rem;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 8px;
            background: linear-gradient(135deg, #667EEA, #764BA2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .auth-header p {
            color: #6b7280;
            font-size: 0.9375rem;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            font-size: 0.875rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .input-wrapper {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.125rem;
            color: #9ca3af;
            pointer-events: none;
            transition: all 0.3s ease;
            z-index: 1;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 16px 14px 48px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 0.9375rem;
            color: #1f2937;
            background: #f9fafb;
            transition: all 0.3s ease;
            outline: none;
        }
        
        .form-control:focus {
            border-color: #667EEA;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .form-control:focus + .input-icon,
        .form-control:not(:placeholder-shown) + .input-icon {
            color: #667EEA;
        }
        
        .password-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.125rem;
            color: #9ca3af;
            padding: 4px;
            transition: color 0.3s ease;
        }
        
        .password-toggle:hover {
            color: #667EEA;
        }
        
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            font-size: 0.875rem;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #6b7280;
            cursor: pointer;
        }
        
        .remember-me input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: #667EEA;
            cursor: pointer;
        }
        
        .forgot-password {
            color: #667EEA;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        
        .forgot-password:hover {
            color: #764BA2;
            text-decoration: underline;
        }
        
        .btn-login {
            width: 100%;
            padding: 14px 24px;
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            position: relative;
            overflow: hidden;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
        }
        
        .btn-login:active {
            transform: translateY(0);
        }
        
        .btn-login::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s ease, height 0.6s ease;
        }
        
        .btn-login:active::after {
            width: 300px;
            height: 300px;
        }
        
        .auth-divider {
            display: flex;
            align-items: center;
            margin: 24px 0;
            color: #9ca3af;
            font-size: 0.8125rem;
        }
        
        .auth-divider::before,
        .auth-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: linear-gradient(90deg, transparent, #e5e7eb, transparent);
        }
        
        .auth-divider span {
            padding: 0 16px;
        }
        
        .auth-footer {
            text-align: center;
            color: #6b7280;
            font-size: 0.875rem;
        }
        
        .auth-footer a {
            color: #667EEA;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        
        .auth-footer a:hover {
            color: #764BA2;
            text-decoration: underline;
        }
        
        .auth-features {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 28px;
            padding-top: 24px;
            border-top: 1px solid #f3f4f6;
        }
        
        .auth-feature {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #6b7280;
            font-size: 0.8125rem;
        }
        
        .auth-feature-icon {
            font-size: 1rem;
        }
        
        .error-message {
            margin-bottom: 20px;
            padding: 12px 16px;
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(220, 38, 38, 0.05));
            border: 1px solid rgba(239, 68, 68, 0.2);
            border-radius: 12px;
            color: #dc2626;
            font-size: 0.875rem;
            text-align: center;
            animation: shake 0.5s ease;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        
        @media (max-width: 480px) {
            .auth-card {
                padding: 36px 24px;
            }
            
            .auth-features {
                flex-direction: column;
                align-items: center;
                gap: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="floating-shapes">
            <div class="shape"></div>
            <div class="shape"></div>
            <div class="shape"></div>
            <div class="shape"></div>
        </div>
        
        <div class="auth-card">
            <div class="auth-header">
                <div class="auth-logo">📚</div>
                <h1>欢迎回来</h1>
                <p>登录您的账户，开始阅读之旅</p>
            </div>
            
            <c:if test="${not empty errorMsg}">
                <div class="error-message">${errorMsg}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                
                <div class="form-group">
                    <label class="form-label">用户名</label>
                    <div class="input-wrapper">
                        <input type="text" name="username" class="form-control" required placeholder="请输入用户名" autocomplete="username">
                        <span class="input-icon"></span>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">密码</label>
                    <div class="input-wrapper">
                        <input type="password" name="password" id="passwordInput" class="form-control" required placeholder="请输入密码" autocomplete="current-password">
                        <span class="input-icon"></span>
                        <button type="button" class="password-toggle" onclick="togglePassword()">👁️</button>
                    </div>
                </div>
                
                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember">
                        <span>记住我</span>
                    </label>
                    <a href="#" class="forgot-password">忘记密码？</a>
                </div>
                
                <button type="submit" class="btn-login">登 录</button>
            </form>
            
            <div class="auth-divider">
                <span>或者</span>
            </div>
            
            <div class="auth-footer">
                还没有账号？<a href="${pageContext.request.contextPath}/register.jsp">立即注册</a>
            </div>
            
            <div class="auth-features">
                <div class="auth-feature">
                    <span class="auth-feature-icon">📖</span>
                    <span>海量图书</span>
                </div>
                <div class="auth-feature">
                    <span class="auth-feature-icon">⚡</span>
                    <span>快速借阅</span>
                </div>
                <div class="auth-feature">
                    <span class="auth-feature-icon">🔔</span>
                    <span>到期提醒</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        function togglePassword() {
            var input = document.getElementById('passwordInput');
            var btn = event.target;
            if (input.type === 'password') {
                input.type = 'text';
                btn.textContent = '🙈';
            } else {
                input.type = 'password';
                btn.textContent = '👁️';
            }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            var form = document.getElementById('loginForm');
            form.addEventListener('submit', function(e) {
                var username = form.querySelector('[name="username"]').value.trim();
                var password = form.querySelector('[name="password"]').value.trim();
                
                if (!username || !password) {
                    e.preventDefault();
                    showToast('请填写完整信息', 'error');
                }
            });
        });
    </script>
</body>
</html>