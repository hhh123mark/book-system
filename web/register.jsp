<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="${sessionScope.csrfToken}">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>用户注册 - 图书管理系统</title>
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
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }
        
        .auth-card {
            position: relative;
            z-index: 1;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 36px 32px;
            width: 100%;
            max-width: 480px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            animation: slideUp 0.5s ease;
        }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .auth-header {
            text-align: center;
            margin-bottom: 28px;
        }
        
        .auth-logo {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin: 0 auto 16px;
            box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
            animation: bounceIn 0.6s ease;
        }
        
        @keyframes bounceIn {
            0% { transform: scale(0); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        
        .auth-header h1 {
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 6px;
        }
        
        .auth-header p {
            color: #6B7280;
            font-size: 0.875rem;
        }
        
        .form-group {
            margin-bottom: 16px;
        }
        
        .form-label {
            display: block;
            font-size: 0.8125rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 6px;
        }
        
        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 0.875rem;
            background: #f9fafb;
            color: #333;
            transition: all 0.2s ease;
            outline: none;
        }
        
        .form-control:focus {
            border-color: #667EEA;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-control::placeholder {
            color: #9CA3AF;
        }
        
        .form-text {
            font-size: 0.75rem;
            margin-top: 4px;
        }
        
        .form-text.error {
            color: #DC2626;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 20px;
            border: none;
            border-radius: 10px;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            color: #fff;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-lg {
            padding: 12px 24px;
            font-size: 1rem;
        }
        
        .btn-block {
            width: 100%;
        }
        
        .auth-footer {
            text-align: center;
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid #e5e7eb;
            color: #6B7280;
            font-size: 0.875rem;
        }
        
        .auth-footer a {
            color: #667EEA;
            text-decoration: none;
            font-weight: 600;
        }
        
        .auth-footer a:hover {
            text-decoration: underline;
        }
        
        .auth-divider {
            display: flex;
            align-items: center;
            margin: 20px 0;
            color: #9CA3AF;
            font-size: 0.75rem;
        }
        
        .auth-divider::before,
        .auth-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e5e7eb;
        }
        
        .auth-divider span {
            padding: 0 12px;
        }
        
        .auth-features {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin-top: 20px;
        }
        
        .auth-feature {
            text-align: center;
            padding: 10px 8px;
            background: #f9fafb;
            border-radius: 8px;
        }
        
        .auth-feature-icon {
            font-size: 1.25rem;
            margin-bottom: 4px;
        }
        
        .auth-feature-text {
            font-size: 0.6875rem;
            color: #6B7280;
        }
        
        .error-msg {
            margin-bottom: 16px;
            padding: 12px;
            background: linear-gradient(135deg, rgba(220, 38, 38, 0.1), rgba(239, 68, 68, 0.05));
            border: 1px solid rgba(220, 38, 38, 0.2);
            border-radius: 10px;
            color: #DC2626;
            font-size: 0.8125rem;
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
                padding: 24px 20px;
            }
            
            .form-row {
                grid-template-columns: 1fr;
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
                <h1>用户注册</h1>
                <p>创建您的账户，开始探索图书世界</p>
            </div>
            
            <c:if test="${not empty errorMsg}">
                <div class="error-msg">${errorMsg}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm" data-validate>
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                
                <div class="form-group">
                    <label class="form-label">用户名</label>
                    <input type="text" name="username" id="username" class="form-control" required placeholder="请输入用户名（3-20个字符）">
                    <div class="form-text error" id="usernameError"></div>
                    <div class="form-text" id="usernameTip"></div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">密码</label>
                        <input type="password" name="password" id="password" class="form-control" required placeholder="6-20个字符">
                        <div class="form-text error"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">确认密码</label>
                        <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required placeholder="再次输入密码">
                        <div class="form-text error" id="confirmPasswordError"></div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">昵称</label>
                    <input type="text" name="nickname" class="form-control" required placeholder="请输入昵称">
                    <div class="form-text error"></div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">邮箱</label>
                        <input type="email" name="email" class="form-control" required placeholder="请输入邮箱">
                        <div class="form-text error"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">手机号</label>
                        <input type="tel" name="phone" class="form-control" required placeholder="请输入手机号">
                        <div class="form-text error"></div>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary btn-lg btn-block">注 册</button>
            </form>
            
            <div class="auth-divider"><span>已有账号？</span></div>
            
            <div class="auth-footer" style="border: none; padding: 0; margin: 0;">
                <a href="${pageContext.request.contextPath}/login.jsp">立即登录</a>
            </div>
            
            <div class="auth-features">
                <div class="auth-feature">
                    <div class="auth-feature-icon">📖</div>
                    <div class="auth-feature-text">海量图书</div>
                </div>
                <div class="auth-feature">
                    <div class="auth-feature-icon">⚡</div>
                    <div class="auth-feature-text">快速借阅</div>
                </div>
                <div class="auth-feature">
                    <div class="auth-feature-icon"></div>
                    <div class="auth-feature-text">到期提醒</div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var usernameInput = document.getElementById('username');
            var usernameTip = document.getElementById('usernameTip');
            var usernameError = document.getElementById('usernameError');
            var passwordInput = document.getElementById('password');
            var confirmPasswordInput = document.getElementById('confirmPassword');
            var confirmPasswordError = document.getElementById('confirmPasswordError');
            var form = document.getElementById('registerForm');
            
            var checkTimer = null;
            
            usernameInput.addEventListener('input', function() {
                var username = this.value.trim();
                usernameError.textContent = '';
                usernameTip.textContent = '';
                
                if (username.length < 3 || username.length > 20) {
                    return;
                }
                
                clearTimeout(checkTimer);
                usernameTip.textContent = '正在验证...';
                usernameTip.style.color = '#9CA3AF';
                
                checkTimer = setTimeout(function() {
                    ajax('${pageContext.request.contextPath}/checkUsername', {
                        method: 'GET',
                        data: { username: username }
                    }).then(function(res) {
                        if (res && res.success) {
                            if (res.exists) {
                                usernameError.textContent = '该用户名已被使用';
                                usernameInput.style.borderColor = '#DC2626';
                                usernameTip.textContent = '';
                            } else {
                                usernameTip.textContent = '用户名可用';
                                usernameTip.style.color = '#10B981';
                                usernameInput.style.borderColor = '';
                            }
                        }
                    }).catch(function() {
                        usernameTip.textContent = '';
                    });
                }, 500);
            });
            
            confirmPasswordInput.addEventListener('input', function() {
                if (this.value && this.value !== passwordInput.value) {
                    confirmPasswordError.textContent = '两次输入的密码不一致';
                    this.style.borderColor = '#DC2626';
                } else {
                    confirmPasswordError.textContent = '';
                    this.style.borderColor = '';
                }
            });
            
            form.addEventListener('submit', function(e) {
                var password = passwordInput.value;
                var confirmPassword = confirmPasswordInput.value;
                
                if (password.length < 6 || password.length > 20) {
                    e.preventDefault();
                    showToast('密码长度为6-20个字符', 'error');
                    return;
                }
                
                if (password !== confirmPassword) {
                    e.preventDefault();
                    showToast('两次输入的密码不一致', 'error');
                    return;
                }
                
                if (usernameError.textContent) {
                    e.preventDefault();
                    showToast('用户名已被使用', 'error');
                    return;
                }
            });
        });
    </script>
</body>
</html>