<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="${sessionScope.csrfToken}">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>我的借阅 - 图书管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js" charset="UTF-8"></script>
    <style>
        .borrow-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 24px 20px 48px;
        }
        
        .borrow-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }
        
        .borrow-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a1a2e;
            margin: 0;
        }
        
        .borrow-search {
            background: #fff;
            border-radius: 12px;
            padding: 16px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            margin-bottom: 24px;
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
        
        .borrow-card {
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            transition: all 0.2s;
        }
        
        .borrow-card:hover {
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
        
        .borrow-card-header {
            display: flex;
            gap: 16px;
            margin-bottom: 16px;
        }
        
        .borrow-cover {
            width: 60px;
            height: 80px;
            border-radius: 8px;
            object-fit: cover;
            flex-shrink: 0;
        }
        
        .borrow-info {
            flex: 1;
        }
        
        .borrow-book-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1a1a2e;
            margin-bottom: 4px;
        }
        
        .borrow-book-author {
            color: #6B7280;
            font-size: 0.875rem;
            margin-bottom: 8px;
        }
        
        .borrow-status {
            flex-shrink: 0;
        }
        
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
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
        
        .borrow-meta {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            padding: 12px 0;
            border-top: 1px solid #f3f4f6;
            border-bottom: 1px solid #f3f4f6;
            margin-bottom: 12px;
        }
        
        .meta-item {
            display: flex;
            flex-direction: column;
        }
        
        .meta-label {
            font-size: 0.6875rem;
            color: #9CA3AF;
            margin-bottom: 2px;
        }
        
        .meta-value {
            font-size: 0.875rem;
            color: #374151;
            font-weight: 500;
        }
        
        .borrow-actions {
            display: flex;
            justify-content: flex-end;
        }
        
        .btn {
            padding: 8px 20px;
            border: none;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .btn-success {
            background: linear-gradient(135deg, #10B981 0%, #059669 100%);
            color: #fff;
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.3);
        }
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }
        
        .btn-success:disabled {
            background: #e5e7eb;
            color: #9CA3AF;
            box-shadow: none;
            cursor: not-allowed;
            transform: none;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-top: 24px;
            list-style: none;
            padding: 0;
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
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
        }
        
        .empty-icon {
            font-size: 4rem;
            margin-bottom: 16px;
        }
        
        .empty-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .empty-desc {
            color: #6B7280;
            margin-bottom: 24px;
        }
        
        .btn-primary {
            display: inline-flex;
            padding: 12px 28px;
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        @media (max-width: 768px) {
            .borrow-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }
            
            .borrow-meta {
                grid-template-columns: 1fr;
            }
            
            .search-form {
                flex-direction: column;
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
                <li><a href="${pageContext.request.contextPath}/user/profile">个人中心</a></li>
                <li><a href="${pageContext.request.contextPath}/user/borrow-list" class="active">我的借阅</a></li>
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

    <div class="borrow-container">
        <div class="borrow-header">
            <h2 class="borrow-title">我的借阅</h2>
        </div>
        
        <div class="borrow-search">
            <form action="${pageContext.request.contextPath}/user/borrow-list" method="get" class="search-form">
                <input type="text" name="keyword" value="${param.keyword}" placeholder="搜索书名" class="search-input">
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
                <c:forEach items="${pageBean.list}" var="borrow">
                    <div class="borrow-card">
                        <div class="borrow-card-header">
                            <img src="${pageContext.request.contextPath}${borrow.bookCover}" alt="${borrow.bookTitle}" class="borrow-cover" onerror="this.src='https://via.placeholder.com/60x80?text=No+Cover'">
                            <div class="borrow-info">
                                <h3 class="borrow-book-title">${borrow.bookTitle}</h3>
                                <p class="borrow-book-author"> ${borrow.bookAuthor}</p>
                                <div class="borrow-status">
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
                                </div>
                            </div>
                        </div>
                        <div class="borrow-meta">
                            <div class="meta-item">
                                <span class="meta-label">借阅时间</span>
                                <span class="meta-value">${borrow.borrowDate}</span>
                            </div>
                            <div class="meta-item">
                                <span class="meta-label">应还时间</span>
                                <span class="meta-value">${borrow.dueDate}</span>
                            </div>
                            <c:if test="${borrow.returnDate != null}">
                                <div class="meta-item">
                                    <span class="meta-label">归还时间</span>
                                    <span class="meta-value">${borrow.returnDate}</span>
                                </div>
                            </c:if>
                        </div>
                        <div class="borrow-actions">
                            <c:if test="${borrow.status == 0}">
                                <button class="btn btn-success" onclick="returnBook(${borrow.id}, this)">归还图书</button>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
                
                <ul class="pagination">
                    <c:if test="${pageBean.pageNo > 1}">
                        <li><a href="${pageContext.request.contextPath}/user/borrow-list?pageNo=${pageBean.pageNo - 1}&keyword=${param.keyword}&status=${param.status}">上一页</a></li>
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
                                <li><a href="${pageContext.request.contextPath}/user/borrow-list?pageNo=${i}&keyword=${param.keyword}&status=${param.status}">${i}</a></li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:if test="${pageBean.pageNo < pageBean.totalPage}">
                        <li><a href="${pageContext.request.contextPath}/user/borrow-list?pageNo=${pageBean.pageNo + 1}&keyword=${param.keyword}&status=${param.status}">下一页</a></li>
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
                    <p class="empty-desc">快去借阅喜欢的图书吧</p>
                    <a href="${pageContext.request.contextPath}/" class="btn-primary">去借书</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        function returnBook(id, btn) {
            if (btn.disabled) return;
            
            var originalText = btn.textContent;
            btn.disabled = true;
            btn.textContent = '归还中...';
            
            ajax('${pageContext.request.contextPath}/borrow', {
                method: 'POST',
                data: {
                    action: 'return',
                    borrowId: id,
                    csrfToken: '${sessionScope.csrfToken}'
                }
            }).then(function(res) {
                if (res && res.success) {
                    showToast('归还成功', 'success');
                    setTimeout(function() {
                        location.reload();
                    }, 1000);
                } else {
                    showToast(res.message || '归还失败', 'error');
                    btn.disabled = false;
                    btn.textContent = originalText;
                }
            }).catch(function() {
                showToast('网络错误，请稍后重试', 'error');
                btn.disabled = false;
                btn.textContent = originalText;
            });
        }
    </script>
</body>
</html>