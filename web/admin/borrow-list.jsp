<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="${sessionScope.csrfToken}">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>借阅管理 - 图书管理系统</title>
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
        
        .admin-search {
            padding: 20px 24px;
            background: #fafbfc;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .search-form {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        
        .search-input, .search-select {
            flex: 1;
            min-width: 150px;
            padding: 10px 14px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.875rem;
            transition: border-color 0.2s;
        }
        
        .search-input:focus, .search-select:focus {
            outline: none;
            border-color: #667EEA;
        }
        
        .search-btn {
            padding: 10px 24px;
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .data-table th {
            padding: 12px 16px;
            text-align: left;
            font-size: 0.75rem;
            font-weight: 600;
            color: #6B7280;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            background: #f9fafb;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .data-table td {
            padding: 12px 16px;
            font-size: 0.875rem;
            color: #374151;
            border-bottom: 1px solid #f3f4f6;
            vertical-align: middle;
        }
        
        .data-table tr:hover td {
            background: #f9fafb;
        }
        
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.6875rem;
            font-weight: 600;
        }
        
        .badge-primary {
            background: rgba(102, 126, 234, 0.1);
            color: #667EEA;
        }
        
        .badge-success {
            background: rgba(16, 185, 129, 0.1);
            color: #10B981;
        }
        
        .badge-danger {
            background: rgba(220, 38, 38, 0.1);
            color: #DC2626;
        }
        
        .action-btns {
            display: flex;
            gap: 8px;
        }
        
        .btn {
            padding: 6px 14px;
            border: none;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-success {
            background: linear-gradient(135deg, #10B981 0%, #059669 100%);
            color: #fff;
        }
        
        .btn-success:hover {
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
            transform: translateY(-1px);
        }
        
        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
        }
        
        .btn-secondary:hover {
            background: #e5e7eb;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            padding: 20px;
            list-style: none;
            margin: 0;
        }
        
        .pagination li a, .pagination li span {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 36px;
            height: 36px;
            padding: 0 12px;
            border-radius: 8px;
            background: #fff;
            border: 1px solid #e5e7eb;
            color: #374151;
            text-decoration: none;
            font-size: 0.875rem;
            transition: all 0.2s;
        }
        
        .pagination li a:hover {
            background: #f3f4f6;
            border-color: #667EEA;
            color: #667EEA;
        }
        
        .pagination li.active span {
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            color: #fff;
            border-color: transparent;
        }
        
        .pagination li.disabled span {
            color: #9CA3AF;
            cursor: not-allowed;
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
            .data-table {
                font-size: 0.75rem;
            }
            .data-table th, .data-table td {
                padding: 8px 10px;
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
                <li><a href="${pageContext.request.contextPath}/admin/user">用户管理</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/borrow" class="active">借阅管理</a></li>
            </ul>
        </aside>
        
        <div class="admin-content">
            <header class="admin-header">
                <div class="admin-header-title">借阅管理</div>
                <div style="display: flex; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">前台首页</a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">退出登录</a>
                </div>
            </header>
            
            <main class="admin-main">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h2 class="admin-card-title">借阅记录</h2>
                    </div>
                    
                    <div class="admin-search">
                        <form action="${pageContext.request.contextPath}/admin/borrow" method="get" class="search-form">
                            <input type="text" name="keyword" value="${param.keyword}" placeholder="搜索书名、用户名" class="search-input">
                            <select name="status" class="search-select">
                                <option value="">全部状态</option>
                                <option value="0" ${param.status == '0' ? 'selected' : ''}>借阅中</option>
                                <option value="1" ${param.status == '1' ? 'selected' : ''}>已归还</option>
                                <option value="2" ${param.status == '2' ? 'selected' : ''}>已逾期</option>
                            </select>
                            <button type="submit" class="search-btn">搜索</button>
                        </form>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty pageBean.list}">
                            <div class="table-container" style="overflow-x: auto;">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>用户</th>
                                            <th>图书</th>
                                            <th>借阅时间</th>
                                            <th>应还时间</th>
                                            <th>归还时间</th>
                                            <th>状态</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${pageBean.list}" var="borrow">
                                            <tr>
                                                <td>${borrow.id}</td>
                                                <td>${borrow.username}</td>
                                                <td>${borrow.bookTitle}</td>
                                                <td>${borrow.borrowDate}</td>
                                                <td>${borrow.dueDate}</td>
                                                <td>${borrow.returnDate != null ? borrow.returnDate : '-'}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${borrow.status == 0}">
                                                            <span class="badge badge-primary">借阅中</span>
                                                        </c:when>
                                                        <c:when test="${borrow.status == 1}">
                                                            <span class="badge badge-success">已归还</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-danger">已逾期</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="action-btns">
                                                        <c:if test="${borrow.status == 0}">
                                                            <button class="btn btn-success" onclick="returnBook(${borrow.id})">确认归还</button>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            
                            <ul class="pagination">
                                <c:if test="${pageBean.pageNo > 1}">
                                    <li><a href="${pageContext.request.contextPath}/admin/borrow?pageNo=${pageBean.pageNo - 1}&keyword=${param.keyword}&status=${param.status}">上一页</a></li>
                                </c:if>
                                <c:if test="${pageBean.pageNo <= 1}">
                                    <li class="disabled"><span>上一页</span></li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${pageBean.totalPage}" var="i">
                                    <c:choose>
                                        <c:when test="${i == pageBean.pageNo}">
                                            <li class="active"><span>${i}</span></li>
                                        </c:when>
                                        <c:otherwise>
                                            <li><a href="${pageContext.request.contextPath}/admin/borrow?pageNo=${i}&keyword=${param.keyword}&status=${param.status}">${i}</a></li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                
                                <c:if test="${pageBean.pageNo < pageBean.totalPage}">
                                    <li><a href="${pageContext.request.contextPath}/admin/borrow?pageNo=${pageBean.pageNo + 1}&keyword=${param.keyword}&status=${param.status}">下一页</a></li>
                                </c:if>
                                <c:if test="${pageBean.pageNo >= pageBean.totalPage}">
                                    <li class="disabled"><span>下一页</span></li>
                                </c:if>
                                
                                <li><span style="border: none; background: none;">共 ${pageBean.totalCount} 条</span></li>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-icon"> </div>
                                <h3 class="empty-title">暂无借阅记录</h3>
                                <p class="empty-desc">系统中还没有借阅记录</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>

    <script>
        function returnBook(id) {
            showConfirm('确认归还该图书吗？', '归还确认').then(function(confirmed) {
                if (!confirmed) return;
                
                ajax('${pageContext.request.contextPath}/borrow', {
                    method: 'POST',
                    data: {
                        action: 'return',
                        id: id,
                        csrfToken: '${sessionScope.csrfToken}'
                    }
                }).then(function(res) {
                    if (res && res.success) {
                        showToast('归还成功', 'success');
                        setTimeout(function() {
                            location.reload();
                        }, 500);
                    } else {
                        showToast(res.message || '归还失败', 'error');
                    }
                }).catch(function() {
                    showToast('网络错误，请稍后重试', 'error');
                });
            });
        }
    </script>
</body>
</html>