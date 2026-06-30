<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="${sessionScope.csrfToken}">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>个人中心 - 图书管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js" charset="UTF-8"></script>
    <style>
        .profile-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 24px 20px 48px;
        }
        
        .profile-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }
        
        .profile-header {
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            padding: 40px 32px;
            display: flex;
            align-items: center;
            gap: 24px;
            position: relative;
        }
        
        .profile-avatar-wrapper {
            position: relative;
        }
        
        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 4px solid rgba(255, 255, 255, 0.3);
            object-fit: cover;
            background: #fff;
        }
        
        .avatar-upload-btn {
            position: absolute;
            bottom: 0;
            right: 0;
            width: 32px;
            height: 32px;
            background: #fff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            transition: all 0.2s;
        }
        
        .avatar-upload-btn:hover {
            transform: scale(1.1);
        }
        
        .avatar-upload-btn svg {
            width: 16px;
            height: 16px;
            color: #667EEA;
        }
        
        .profile-info {
            color: #fff;
        }
        
        .profile-nickname {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 4px;
        }
        
        .profile-username {
            font-size: 0.875rem;
            opacity: 0.8;
        }
        
        .profile-body {
            padding: 32px;
        }
        
        .profile-section-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1a1a2e;
            margin-bottom: 24px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f3f4f6;
        }
        
        .profile-form {
            display: grid;
            gap: 20px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-label {
            font-size: 0.875rem;
            font-weight: 500;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .form-input {
            padding: 10px 14px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.875rem;
            transition: all 0.2s;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #667EEA;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-input:disabled {
            background: #f9fafb;
            color: #9CA3AF;
            cursor: not-allowed;
        }
        
        .form-actions {
            display: flex;
            justify-content: flex-end;
            padding-top: 20px;
            border-top: 1px solid #f3f4f6;
            margin-top: 12px;
        }
        
        .btn {
            padding: 10px 24px;
            border: none;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
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
        
        @media (max-width: 768px) {
            .profile-header {
                flex-direction: column;
                text-align: center;
                padding: 32px 20px;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .profile-body {
                padding: 24px 20px;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-container">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand"> 图书管理系统</a>
            
            <ul class="navbar-menu">
                <li><a href="${pageContext.request.contextPath}/">首页</a></li>
                <li><a href="${pageContext.request.contextPath}/user/profile" class="active">个人中心</a></li>
                <li><a href="${pageContext.request.contextPath}/user/borrow-list">我的借阅</a></li>
            </ul>
            
            <div class="user-menu">
                <div class="user-menu-trigger">
                    <img src="${pageContext.request.contextPath}${sessionScope.loginUser.avatar}" alt="头像" class="avatar avatar-sm" onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.svg'">
                    <span>${sessionScope.loginUser.nickname}</span>
                </div>
                <div class="user-menu-dropdown">
                    <c:if test="${sessionScope.loginUser.role == 1}">
                        <a href="${pageContext.request.contextPath}/admin/book">管理后台</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/user/profile">个人中心</a>
                    <a href="${pageContext.request.contextPath}/user/borrow-list">我的借阅</a>
                    <a href="${pageContext.request.contextPath}/logout">退出登录</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="profile-container">
        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-avatar-wrapper">
                    <img src="${pageContext.request.contextPath}${user.avatar}" alt="头像" class="profile-avatar" onerror="this.src='${pageContext.request.contextPath}/images/default-avatar.svg'">
                    <label class="avatar-upload-btn" for="avatarInput">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                    </label>
                    <input type="file" id="avatarInput" accept="image/*" style="display: none;" onchange="uploadAvatar(this)">
                </div>
                <div class="profile-info">
                    <h3 class="profile-nickname">${user.nickname}</h3>
                    <p class="profile-username"> ${user.username}</p>
                </div>
            </div>
            
            <div class="profile-body">
                <h3 class="profile-section-title">基本信息</h3>
                <form action="${pageContext.request.contextPath}/user/profile" method="post" class="profile-form">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">用户名</label>
                            <input type="text" name="username" class="form-input" value="${user.username}" disabled>
                        </div>
                        <div class="form-group">
                            <label class="form-label">昵称</label>
                            <input type="text" name="nickname" class="form-input" value="${user.nickname}" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">邮箱</label>
                            <input type="email" name="email" class="form-input" value="${user.email}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">新密码</label>
                            <input type="password" name="password" class="form-input" placeholder="不修改请留空">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">确认密码</label>
                            <input type="password" name="confirmPassword" class="form-input" placeholder="不修改请留空">
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">保存修改</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function uploadAvatar(input) {
            if (!input.files || !input.files[0]) return;
            
            var formData = new FormData();
            formData.append('avatar', input.files[0]);
            formData.append('csrfToken', '${sessionScope.csrfToken}');
            
            var xhr = new XMLHttpRequest();
            xhr.open('POST', '${pageContext.request.contextPath}/user/profile?action=uploadAvatar');
            xhr.onload = function() {
                if (xhr.status == 200) {
                    try {
                        var res = JSON.parse(xhr.responseText);
                        if (res.success) {
                            showToast('头像上传成功', 'success');
                            setTimeout(function() {
                                location.reload();
                            }, 1000);
                        } else {
                            showToast(res.message || '上传失败', 'error');
                        }
                    } catch(e) {
                        showToast('上传失败', 'error');
                    }
                } else {
                    showToast('上传失败', 'error');
                }
            };
            xhr.onerror = function() {
                showToast('网络错误，请稍后重试', 'error');
            };
            xhr.send(formData);
        }
    </script>
</body>
</html>