<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="${sessionScope.csrfToken}">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title><c:choose><c:when test="${book != null}">编辑图书</c:when><c:otherwise>添加图书</c:otherwise></c:choose> - 图书管理系统</title>
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
        
        .form-container {
            padding: 24px;
            max-width: 800px;
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
            font-weight: 500;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .form-label .required {
            color: #EF4444;
        }
        
        .form-input, .form-select, .form-textarea {
            padding: 10px 14px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.875rem;
            transition: all 0.2s;
        }
        
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: #667EEA;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-file {
            padding: 8px;
            border: 2px dashed #e5e7eb;
            border-radius: 8px;
            background: #fafbfc;
            cursor: pointer;
        }
        
        .form-file:hover {
            border-color: #667EEA;
        }
        
        .current-cover {
            margin-top: 12px;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .form-actions {
            display: flex;
            gap: 12px;
            padding-top: 24px;
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
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
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
        
        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
        }
        
        .btn-secondary:hover {
            background: #e5e7eb;
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
            .form-container {
                padding: 20px;
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
                <li><a href="${pageContext.request.contextPath}/admin/book" class="active">图书管理</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/category">分类管理</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/user">用户管理</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/borrow">借阅管理</a></li>
            </ul>
        </aside>
        
        <div class="admin-content">
            <header class="admin-header">
                <div class="admin-header-title">
                    <c:choose>
                        <c:when test="${book != null}">编辑图书</c:when>
                        <c:otherwise>添加图书</c:otherwise>
                    </c:choose>
                </div>
                <div style="display: flex; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">前台首页</a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">退出登录</a>
                </div>
            </header>
            
            <main class="admin-main">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h2 class="admin-card-title">
                            <c:choose>
                                <c:when test="${book != null}">编辑图书信息</c:when>
                                <c:otherwise>添加新图书</c:otherwise>
                            </c:choose>
                        </h2>
                    </div>
                    
                    <div class="form-container">
                        <form action="${pageContext.request.contextPath}/admin/book" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="action" value="${book != null ? 'update' : 'add'}">
                            <c:if test="${book != null}">
                                <input type="hidden" name="id" value="${book.id}">
                            </c:if>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">书名 <span class="required">*</span></label>
                                    <input type="text" name="title" class="form-input" value="${book != null ? book.title : ''}" required placeholder="请输入书名">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">作者 <span class="required">*</span></label>
                                    <input type="text" name="author" class="form-input" value="${book != null ? book.author : ''}" required placeholder="请输入作者">
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">分类 <span class="required">*</span></label>
                                    <select name="categoryId" class="form-select" required>
                                        <option value="">请选择分类</option>
                                        <c:forEach items="${categoryList}" var="cat">
                                            <option value="${cat.id}" ${book != null && book.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">ISBN <span class="required">*</span></label>
                                    <input type="text" name="isbn" class="form-input" value="${book != null ? book.isbn : ''}" required placeholder="请输入ISBN">
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">价格 <span class="required">*</span></label>
                                    <input type="number" name="price" class="form-input" value="${book != null ? book.price : ''}" required placeholder="请输入价格" step="0.01">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">库存 <span class="required">*</span></label>
                                    <input type="number" name="stock" class="form-input" value="${book != null ? book.stock : '1'}" required placeholder="请输入库存" min="0">
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">出版社</label>
                                    <input type="text" name="publisher" class="form-input" value="${book != null ? book.publisher : ''}" placeholder="请输入出版社">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">出版日期</label>
                                    <input type="date" name="publishDate" class="form-input" value="${book != null ? book.publishDate : ''}">
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">封面图片</label>
                                    <input type="file" name="coverImage" class="form-file" accept="image/*">
                                    <c:if test="${book != null && book.coverImage != null}">
                                        <div class="current-cover">
                                            <img src="${pageContext.request.contextPath}${book.coverImage}" alt="封面" style="width: 100px; height: 120px; object-fit: cover; display: block;" onerror="this.style.display='none'">
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group" style="grid-column: 1 / -1;">
                                    <label class="form-label">图书简介</label>
                                    <textarea name="description" class="form-textarea" rows="4" placeholder="请输入图书简介">${book != null ? book.description : ''}</textarea>
                                </div>
                            </div>
                            
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">保存</button>
                                <a href="${pageContext.request.contextPath}/admin/book" class="btn btn-secondary">取消</a>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>