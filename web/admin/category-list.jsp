<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="${sessionScope.csrfToken}">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>分类管理 - 图书管理系统</title>
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
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .admin-card-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1a1a2e;
            margin: 0;
        }
        
        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            padding: 24px;
        }
        
        .category-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.2s;
        }
        
        .category-card:hover {
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
            border-color: #667EEA;
        }
        
        .category-card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
        }
        
        .category-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1.25rem;
        }
        
        .category-name {
            font-size: 1rem;
            font-weight: 600;
            color: #1a1a2e;
        }
        
        .category-count {
            font-size: 0.875rem;
            color: #6B7280;
            margin-bottom: 16px;
        }
        
        .category-actions {
            display: flex;
            gap: 8px;
        }
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 8px;
            font-size: 0.8125rem;
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
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #EF4444 0%, #DC2626 100%);
            color: #fff;
        }
        
        .btn-danger:hover {
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        }
        
        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
        }
        
        .btn-secondary:hover {
            background: #e5e7eb;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        
        .empty-icon {
            font-size: 4rem;
            margin-bottom: 16px;
        }
        
        .empty-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .empty-desc {
            color: #6B7280;
        }
        
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        
        .modal.active {
            display: flex;
        }
        
        .modal-content {
            background: #fff;
            border-radius: 16px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            animation: modalSlideIn 0.3s ease;
        }
        
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid #f3f4f6;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .modal-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1a1a2e;
            margin: 0;
        }
        
        .modal-close {
            width: 32px;
            height: 32px;
            border: none;
            background: #f3f4f6;
            border-radius: 8px;
            font-size: 1.25rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
        
        .modal-close:hover {
            background: #e5e7eb;
        }
        
        .modal-body {
            padding: 24px;
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
        
        .modal-footer {
            padding: 16px 24px;
            border-top: 1px solid #f3f4f6;
            display: flex;
            gap: 12px;
            justify-content: flex-end;
        }
        
        @media (max-width: 768px) {
            .admin-sidebar {
                display: none;
            }
            .admin-content {
                margin-left: 0;
            }
            .category-grid {
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
                <li><a href="${pageContext.request.contextPath}/admin/category" class="active">分类管理</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/user">用户管理</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/borrow">借阅管理</a></li>
            </ul>
        </aside>
        
        <div class="admin-content">
            <header class="admin-header">
                <div class="admin-header-title">分类管理</div>
                <div style="display: flex; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">前台首页</a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">退出登录</a>
                </div>
            </header>
            
            <main class="admin-main">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h2 class="admin-card-title">分类列表</h2>
                        <button class="btn btn-primary" onclick="showCategoryModal()">+ 添加分类</button>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty categoryList}">
                            <div class="category-grid">
                                <c:forEach items="${categoryList}" var="category">
                                    <div class="category-card">
                                        <div class="category-card-header">
                                            <div class="category-icon"> </div>
                                            <span class="category-name">${category.name}</span>
                                        </div>
                                        <div class="category-count">包含 ${category.bookCount} 本图书</div>
                                        <div class="category-actions">
                                            <button class="btn btn-primary" onclick="editCategory(${category.id}, '${category.name}')">编辑</button>
                                            <button class="btn btn-danger" onclick="deleteCategory(${category.id})">删除</button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-icon"> </div>
                                <h3 class="empty-title">暂无分类数据</h3>
                                <p class="empty-desc">点击上方按钮添加分类</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>

    <div class="modal" id="categoryModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="modalTitle">添加分类</h3>
                <button class="modal-close" onclick="closeCategoryModal()"> </button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="categoryId">
                <div class="form-group">
                    <label class="form-label">分类名称</label>
                    <input type="text" id="categoryName" class="form-input" required placeholder="请输入分类名称">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeCategoryModal()">取消</button>
                <button class="btn btn-primary" onclick="saveCategory()">保存</button>
            </div>
        </div>
    </div>

    <script>
        function showCategoryModal() {
            document.getElementById('categoryId').value = '';
            document.getElementById('categoryName').value = '';
            document.getElementById('modalTitle').textContent = '添加分类';
            document.getElementById('categoryModal').classList.add('active');
        }
        
        function closeCategoryModal() {
            document.getElementById('categoryModal').classList.remove('active');
        }
        
        function editCategory(id, name) {
            document.getElementById('categoryId').value = id;
            document.getElementById('categoryName').value = name;
            document.getElementById('modalTitle').textContent = '编辑分类';
            document.getElementById('categoryModal').classList.add('active');
        }
        
        function saveCategory() {
            var id = document.getElementById('categoryId').value;
            var name = document.getElementById('categoryName').value.trim();
            
            if (!name) {
                showToast('请输入分类名称', 'warning');
                return;
            }
            
            var action = id ? 'update' : 'add';
            
            ajax('${pageContext.request.contextPath}/admin/category', {
                method: 'POST',
                data: {
                    action: action,
                    id: id,
                    name: name,
                    csrfToken: '${sessionScope.csrfToken}'
                }
            }).then(function(res) {
                if (res && res.success) {
                    showToast(action == 'add' ? '添加成功' : '更新成功', 'success');
                    closeCategoryModal();
                    setTimeout(function() {
                        location.reload();
                    }, 500);
                } else {
                    showToast(res.message || '操作失败', 'error');
                }
            }).catch(function() {
                showToast('网络错误，请稍后重试', 'error');
            });
        }
        
        function deleteCategory(id) {
            showConfirm('确认删除该分类吗？关联的图书不会被删除。', '删除确认').then(function(confirmed) {
                if (!confirmed) return;
                
                ajax('${pageContext.request.contextPath}/admin/category', {
                    method: 'POST',
                    data: {
                        action: 'delete',
                        id: id,
                        csrfToken: '${sessionScope.csrfToken}'
                    }
                }).then(function(res) {
                    if (res && res.success) {
                        showToast('删除成功', 'success');
                        setTimeout(function() {
                            location.reload();
                        }, 500);
                    } else {
                        showToast(res.message || '删除失败', 'error');
                    }
                }).catch(function() {
                    showToast('网络错误，请稍后重试', 'error');
                });
            });
        }
    </script>
</body>
</html>