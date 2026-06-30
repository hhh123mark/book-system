<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="${sessionScope.csrfToken}">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title><c:choose><c:when test="${user != null}">编辑用户</c:when><c:otherwise>添加用户</c:otherwise></c:choose> - 图书管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js" charset="UTF-8"></script>
    <style>
        .admin-layout {
            display: flex;
            min-height: 100vh;
            background: #f5f7fa;
        }
        
        .admin-sidebar {
            width: 220px;
            background: linear-gradient(180deg, #1a1a2e 0%, #16213e 100%);
            color: #fff;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }
        
        .admin-sidebar-header {
            padding: 24px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .admin-sidebar-header h2 {
            font-size: 1.125rem;
            font-weight: 700;
            margin: 0;
        }
        
        .admin-sidebar-menu {
            list-style: none;
            padding: 16px 0;
            margin: 0;
        }
        
        .admin-sidebar-menu li a {
            display: block;
            padding: 12px 20px;
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            font-size: 0.875rem;
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }
        
        .admin-sidebar-menu li a:hover,
        .admin-sidebar-menu li a.active {
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            border-left-color: #667EEA;
        }
        
        .admin-content {
            flex: 1;
            margin-left: 220px;
            display: flex;
            flex-direction: column;
        }
        
        .admin-header {
            background: #fff;
            padding: 16px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            position: sticky;
            top: 0;
            z-index: 10;
        }
        
        .admin-header-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1a1a2e;
        }
        
        .admin-main {
            padding: 24px;
            flex: 1;
        }
        
        .admin-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            overflow: hidden;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .admin-card-header {
            padding: 20px 24px;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .admin-card-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1a1a2e;
            margin: 0;
        }
        
        .form-body {
            padding: 24px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .form-input, .form-select {
            padding: 10px 14px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.875rem;
            transition: all 0.2s;
        }
        
        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: #667EEA;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-actions {
            display: flex;
            gap: 12px;
            padding-top: 24px;
            border-top: 1px solid #f3f4f6;
            margin-top: 24px;
        }
        
        .btn {
            padding: 10px 24px;
            border: none;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            color: #fff;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
        }
        
        .btn-secondary:hover {
            background: #e5e7eb;
        }
        
        .required {
            color: #EF4444;
        }
        
        .form-hint {
            font-size: 0.75rem;
            color: #6B7280;
            margin-top: 4px;
        }
        
        @media (max-width: 1024px) {
            .admin-sidebar {
                width: 180px;
            }
            .admin-content {
                margin-left: 180px;
            }
        }
        
        @media (max-width: 768px) {
            .admin-sidebar {
                display: none;
            }
            .admin-content {
                margin-left: 0;
            }
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <div class="admin-sidebar-header">
                <h2> 管理后台</h2>
            </div>
            <ul class="admin-sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/admin/book">图书管理</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/category">分类管理</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/user" class="active">用户管理</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/borrow">借阅管理</a></li>
            </ul>
        </aside>
        
        <div class="admin-content">
            <header class="admin-header">
                <div class="admin-header-title"><c:choose><c:when test="${user != null}">编辑用户</c:when><c:otherwise>添加用户</c:otherwise></c:choose></div>
                <div style="display: flex; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">前台首页</a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">退出登录</a>
                </div>
            </header>
            
            <main class="admin-main">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h2 class="admin-card-title"><c:choose><c:when test="${user != null}">编辑用户信息</c:when><c:otherwise>添加新用户</c:otherwise></c:choose></h2>
                    </div>
                    
                    <form action="${pageContext.request.contextPath}/admin/user" method="post" class="form-body">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <input type="hidden" name="action" value="${user != null ? 'update' : 'add'}">
                        <c:if test="${user != null}">
                            <input type="hidden" name="id" value="${user.id}">
                        </c:if>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">用户名 <span class="required">*</span></label>
                                <input type="text" name="username" class="form-input" value="${user != null ? user.username : ''}" required placeholder="请输入用户名">
                            </div>
                            <div class="form-group">
                                <label class="form-label">昵称 <span class="required">*</span></label>
                                <input type="text" name="nickname" class="form-input" value="${user != null ? user.nickname : ''}" required placeholder="请输入昵称">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">邮箱 <span class="required">*</span></label>
                                <input type="email" name="email" class="form-input" value="${user != null ? user.email : ''}" required placeholder="请输入邮箱">
                            </div>
                            <div class="form-group">
                                <label class="form-label">角色 <span class="required">*</span></label>
                                <select name="role" class="form-select" required>
                                    <option value="0" ${user != null && user.role == 0 ? 'selected' : ''}>普通用户</option>
                                    <option value="1" ${user != null && user.role == 1 ? 'selected' : ''}>管理员</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">密码 <c:if test="${user == null}"><span class="required">*</span></c:if></label>
                                <input type="password" name="password" class="form-input" placeholder="${user != null ? '不修改请留空' : '请输入密码'}">
                                <c:if test="${user != null}">
                                    <span class="form-hint">不修改请留空</span>
                                </c:if>
                            </div>
                            <div class="form-group">
                                <label class="form-label">确认密码 <c:if test="${user == null}"><span class="required">*</span></c:if></label>
                                <input type="password" name="confirmPassword" class="form-input" placeholder="${user != null ? '不修改请留空' : '请确认密码'}">
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">保存</button>
                            <a href="${pageContext.request.contextPath}/admin/user" class="btn btn-secondary">取消</a>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
</body>
</html>