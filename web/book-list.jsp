<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="${sessionScope.csrfToken}">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>图书管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js" charset="UTF-8"></script>
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            padding: 16px 0 12px;
            margin-bottom: 12px;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 50%, rgba(255, 255, 255, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 80% 50%, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
            pointer-events: none;
        }
        
        .hero-content {
            position: relative;
            z-index: 1;
            text-align: center;
            color: white;
        }
        
        .hero-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 2px;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        }
        
        .hero-subtitle {
            font-size: 0.75rem;
            opacity: 0.8;
            margin-bottom: 10px;
        }
        
        .hero-search {
            max-width: 450px;
            margin: 0 auto;
        }
        
        .hero-search-form {
            display: flex;
            gap: 6px;
            background: rgba(255, 255, 255, 0.95);
            padding: 5px;
            border-radius: 10px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
        }
        
        .hero-search-form input {
            flex: 1;
            border: none;
            padding: 8px 12px;
            font-size: 0.8125rem;
            outline: none;
            background: transparent;
            color: #333;
        }
        
        .hero-search-form input::placeholder {
            color: #999;
        }
        
        .hero-search-form .btn {
            border-radius: 6px;
            padding: 8px 16px;
            font-size: 0.8125rem;
        }
        
        .filter-bar {
            background: #fff;
            border-radius: 10px;
            padding: 10px 14px;
            box-shadow: 0 1px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #f0f0f0;
            margin-bottom: 14px;
        }
        
        .filter-bar-inner {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .filter-label {
            color: #666;
            font-weight: 600;
            font-size: 0.75rem;
        }
        
        .filter-select {
            min-width: 100px;
            padding: 5px 8px;
            font-size: 0.75rem;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            background: #fafafa;
            color: #333;
            outline: none;
            cursor: pointer;
        }
        
        .filter-select:focus {
            border-color: #667EEA;
            background: #fff;
        }
        
        .sort-tabs {
            display: flex;
            align-items: center;
            gap: 3px;
            margin-left: auto;
        }
        
        .sort-tab {
            padding: 4px 8px;
            border-radius: 5px;
            color: #666;
            font-size: 0.75rem;
            font-weight: 500;
            transition: all 0.2s ease;
            cursor: pointer;
            text-decoration: none;
        }
        
        .sort-tab:hover {
            color: #667EEA;
            background-color: rgba(102, 126, 234, 0.08);
        }
        
        .sort-tab.active {
            color: #667EEA;
            background-color: rgba(102, 126, 234, 0.1);
            font-weight: 600;
        }
        
        .sort-divider {
            color: #ddd;
            font-size: 0.6875rem;
        }
        
        .results-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            color: #888;
            font-size: 0.75rem;
        }
        
        .results-info strong {
            color: #667EEA;
        }
        
        .book-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 14px;
            justify-content: center;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .book-card {
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06);
            border: 1px solid #f0f0f0;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .book-card:hover {
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            transform: translateY(-3px);
        }
        
        .book-card-image-wrapper {
            position: relative;
            overflow: hidden;
            height: 160px;
            background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%);
        }
        
        .book-card-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        .book-card:hover .book-card-image {
            transform: scale(1.05);
        }
        
        .book-card-content {
            padding: 12px;
        }
        
        .book-card-category {
            display: inline-flex;
            align-items: center;
            gap: 2px;
            padding: 2px 6px;
            background: rgba(102, 126, 234, 0.1);
            color: #667EEA;
            border-radius: 3px;
            font-size: 0.625rem;
            font-weight: 600;
            margin-bottom: 6px;
        }
        
        .book-card-title {
            font-weight: 600;
            font-size: 0.875rem;
            margin-bottom: 3px;
            color: #333;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            line-height: 1.3;
        }
        
        .book-card-author {
            color: #999;
            font-size: 0.75rem;
            margin-bottom: 8px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .book-card-footer {
            margin-top: auto;
        }
        
        .book-card-price {
            color: #e74c3c;
            font-weight: 700;
            font-size: 1rem;
        }
        
        .book-card-stock {
            display: inline-flex;
            align-items: center;
            gap: 2px;
            font-size: 0.6875rem;
            color: #27ae60;
            font-weight: 500;
        }
        
        .book-card-stock.out {
            color: #e74c3c;
        }
        
        .borrow-btn {
            width: 100%;
            padding: 7px 10px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-top: 8px;
        }
        
        .borrow-btn:hover:not(:disabled) {
            transform: translateY(-1px);
            box-shadow: 0 3px 10px rgba(102, 126, 234, 0.35);
        }
        
        .borrow-btn:disabled {
            background: #f0f0f0;
            color: #999;
            cursor: not-allowed;
        }
        
        .empty-state {
            text-align: center;
            padding: 50px 20px;
        }
        
        .empty-state-icon {
            font-size: 3.5rem;
            margin-bottom: 14px;
            opacity: 0.5;
        }
        
        .empty-state h3 {
            font-size: 1.125rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .empty-state p {
            color: #999;
            font-size: 0.8125rem;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 5px;
            margin-top: 20px;
            list-style: none;
            padding: 0;
        }
        
        .pagination li {
            display: inline-block;
        }
        
        .pagination li a,
        .pagination li span {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 28px;
            height: 28px;
            padding: 0 8px;
            border-radius: 6px;
            font-size: 0.75rem;
            color: #666;
            text-decoration: none;
            transition: all 0.2s ease;
            border: 1px solid #e0e0e0;
            background: #fff;
        }
        
        .pagination li a:hover {
            color: #667EEA;
            border-color: #667EEA;
            background: rgba(102, 126, 234, 0.05);
        }
        
        .pagination li.active span {
            color: #fff;
            background: #667EEA;
            border-color: #667EEA;
        }
        
        .pagination li.disabled span {
            color: #ccc;
            cursor: not-allowed;
        }
        
        @media (max-width: 768px) {
            .book-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 10px;
            }
            
            .book-card-image-wrapper {
                height: 130px;
            }
            
            .filter-bar-inner {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .sort-tabs {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-container">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand"> 图书管理系统</a>
            
            <ul class="navbar-menu">
                <li><a href="${pageContext.request.contextPath}/" class="active">首页</a></li>
            </ul>
            
            <div class="user-menu">
                <c:choose>
                    <c:when test="${not empty sessionScope.loginUser}">
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
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-sm btn-secondary">登录</a>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-sm btn-primary">注册</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <div class="hero-section">
        <div class="container">
            <div class="hero-content">
                <h1 class="hero-title"> 发现你的下一本好书</h1>
                <p class="hero-subtitle">海量图书资源，随时随地畅享阅读</p>
                <div class="hero-search">
                    <form action="${pageContext.request.contextPath}/" method="get" class="hero-search-form">
                        <input type="text" name="keyword" value="${param.keyword}" placeholder="搜索书名、作者、ISBN...">
                        <button type="submit" class="btn btn-primary">搜索</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="container" style="padding-bottom: 36px;">
        <div class="filter-bar">
            <div class="filter-bar-inner">
                <span class="filter-label">分类</span>
                <select id="categorySelect" class="filter-select">
                    <option value="">全部分类</option>
                    <c:forEach items="${categoryList}" var="cat">
                        <option value="${cat.id}" <c:if test="${categoryId == cat.id}">selected</c:if>>${cat.name}</option>
                    </c:forEach>
                </select>
                
                <div class="sort-tabs">
                    <span class="filter-label">排序</span>
                    <a href="${pageContext.request.contextPath}/?categoryId=${categoryId}&keyword=${keyword}&sortField=createTime&sortOrder=DESC" class="sort-tab <c:if test="${empty sortField || sortField == 'createTime'}">active</c:if>">最新</a>
                    <span class="sort-divider">|</span>
                    <a href="${pageContext.request.contextPath}/?categoryId=${categoryId}&keyword=${keyword}&sortField=title&sortOrder=ASC" class="sort-tab <c:if test="${sortField == 'title'}">active</c:if>">书名</a>
                    <span class="sort-divider">|</span>
                    <a href="${pageContext.request.contextPath}/?categoryId=${categoryId}&keyword=${keyword}&sortField=price&sortOrder=ASC" class="sort-tab <c:if test="${sortField == 'price'}">active</c:if>">价格</a>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty pageBean.list}">
                <div class="results-info">
                    <span>共找到 <strong>${pageBean.totalCount}</strong> 本图书</span>
                    <span>第 ${pageBean.pageNo}/${pageBean.totalPage} 页</span>
                </div>
                
                <div class="book-grid">
                    <c:forEach items="${pageBean.list}" var="book">
                        <div class="book-card" onclick="window.location.href='${pageContext.request.contextPath}/book?action=detail&id=${book.id}'">
                            <div class="book-card-image-wrapper">
                                <img src="${pageContext.request.contextPath}${book.coverImage}" alt="${book.title}" class="book-card-image" onerror="this.src='https://via.placeholder.com/260x320?text=No+Cover'">
                            </div>
                            <div class="book-card-content">
                                <div class="book-card-category"> ${book.categoryName}</div>
                                <div class="book-card-title">${book.title}</div>
                                <div class="book-card-author">${book.author}</div>
                                <div class="book-card-footer">
                                    <div class="d-flex justify-content-between align-items-center" style="margin-bottom: 6px;">
                                        <span class="book-card-price">¥${book.price}</span>
                                        <span class="book-card-stock ${book.available > 0 ? '' : 'out'}">
                                            <c:choose>
                                                <c:when test="${book.available > 0}">可借 ${book.available} 本</c:when>
                                                <c:otherwise>暂无库存</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <button class="btn btn-primary btn-sm btn-block borrow-btn" data-book-id="${book.id}" onclick="event.stopPropagation(); borrowBook(${book.id}, this)" <c:if test="${book.available <= 0}">disabled</c:if>>
                                        <c:choose>
                                            <c:when test="${book.available > 0}">立即借阅</c:when>
                                            <c:otherwise>暂无库存</c:otherwise>
                                        </c:choose>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <ul class="pagination">
                    <c:if test="${pageBean.pageNo > 1}">
                        <li><a href="${pageContext.request.contextPath}/?pageNo=${pageBean.pageNo - 1}&categoryId=${categoryId}&keyword=${keyword}&sortField=${sortField}&sortOrder=${sortOrder}">上一页</a></li>
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
                                <li><a href="${pageContext.request.contextPath}/?pageNo=${i}&categoryId=${categoryId}&keyword=${keyword}&sortField=${sortField}&sortOrder=${sortOrder}">${i}</a></li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:if test="${pageBean.pageNo < pageBean.totalPage}">
                        <li><a href="${pageContext.request.contextPath}/?pageNo=${pageBean.pageNo + 1}&categoryId=${categoryId}&keyword=${keyword}&sortField=${sortField}&sortOrder=${sortOrder}">下一页</a></li>
                    </c:if>
                    <c:if test="${pageBean.pageNo >= pageBean.totalPage}">
                        <li class="disabled"><span>下一页</span></li>
                    </c:if>
                    
                    <li><span style="border: none; background: none; color: #888;">共 ${pageBean.totalCount} 条</span></li>
                </ul>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon"></div>
                    <h3>暂无图书数据</h3>
                    <p>系统中还没有添加任何图书，请稍后再来查看</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        // 分类选择器
        document.getElementById('categorySelect').addEventListener('change', function() {
            var categoryId = this.value;
            var keyword = '${keyword != null ? keyword : ""}';
            var sortField = '${sortField != null ? sortField : ""}';
            var sortOrder = '${sortOrder != null ? sortOrder : ""}';
            var url = '${pageContext.request.contextPath}/?categoryId=' + categoryId + '&keyword=' + keyword + '&sortField=' + sortField + '&sortOrder=' + sortOrder;
            window.location.href = url;
        });
        
        function borrowBook(bookId, btn) {
            <c:if test="${empty sessionScope.loginUser}">
                showToast('请先登录', 'warning');
                setTimeout(function() {
                    window.location.href = '${pageContext.request.contextPath}/login.jsp';
                }, 1500);
                return;
            </c:if>
            
            if (btn.disabled) return;
            
            var originalText = btn.textContent;
            btn.disabled = true;
            btn.textContent = '借阅中...';
            
            ajax('${pageContext.request.contextPath}/borrow', {
                method: 'POST',
                data: {
                    action: 'borrow',
                    bookId: bookId,
                    csrfToken: '${sessionScope.csrfToken}'
                }
            }).then(function(res) {
                if (res && res.success) {
                    showToast('借阅成功', 'success');
                    setTimeout(function() {
                        location.reload();
                    }, 1000);
                } else {
                    showToast(res.message || '借阅失败', 'error');
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