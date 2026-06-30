<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="${sessionScope.csrfToken}">
    <meta name="context-path" content="${pageContext.request.contextPath}">
    <title>${book.title} - 图书管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/common.js" charset="UTF-8"></script>
    <style>
        .detail-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 24px 20px 48px;
        }
        
        .detail-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            display: flex;
            gap: 0;
        }
        
        .detail-cover {
            width: 300px;
            min-height: 400px;
            background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf1 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        
        .detail-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .detail-info {
            flex: 1;
            padding: 32px;
            display: flex;
            flex-direction: column;
        }
        
        .detail-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 8px;
            line-height: 1.3;
        }
        
        .detail-author {
            color: #6B7280;
            font-size: 0.9375rem;
            margin-bottom: 16px;
        }
        
        .detail-tags {
            display: flex;
            gap: 8px;
            margin-bottom: 20px;
            flex-wrap: wrap;
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
        
        .detail-price {
            font-size: 2rem;
            font-weight: 700;
            color: #e74c3c;
            margin-bottom: 24px;
        }
        
        .detail-meta {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 24px;
        }
        
        .meta-item {
            display: flex;
            flex-direction: column;
            padding: 10px 14px;
            background: #f9fafb;
            border-radius: 8px;
        }
        
        .meta-label {
            font-size: 0.6875rem;
            color: #9CA3AF;
            margin-bottom: 2px;
        }
        
        .meta-item span:last-child {
            font-size: 0.875rem;
            color: #374151;
            font-weight: 500;
        }
        
        .detail-desc {
            flex: 1;
            margin-bottom: 24px;
        }
        
        .detail-desc h3 {
            font-size: 0.9375rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        
        .detail-desc p {
            font-size: 0.875rem;
            color: #6B7280;
            line-height: 1.7;
        }
        
        .detail-actions {
            display: flex;
            gap: 12px;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 24px;
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
        
        .btn-primary:disabled {
            background: #e5e7eb;
            color: #9CA3AF;
            box-shadow: none;
            cursor: not-allowed;
            transform: none;
        }
        
        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
        }
        
        .btn-secondary:hover {
            background: #e5e7eb;
        }
        
        .btn-lg {
            padding: 12px 28px;
            font-size: 0.9375rem;
        }
        
        @media (max-width: 768px) {
            .detail-card {
                flex-direction: column;
            }
            
            .detail-cover {
                width: 100%;
                min-height: 250px;
            }
            
            .detail-info {
                padding: 24px 20px;
            }
            
            .detail-meta {
                grid-template-columns: 1fr;
            }
            
            .detail-actions {
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

    <div class="detail-container">
        <div class="detail-card">
            <div class="detail-cover">
                <img src="${pageContext.request.contextPath}${book.coverImage}" alt="${book.title}" onerror="this.src='https://via.placeholder.com/300x400?text=No+Cover'">
            </div>
            <div class="detail-info">
                <h1 class="detail-title">${book.title}</h1>
                <p class="detail-author"> ${book.author}</p>
                
                <div class="detail-tags">
                    <span class="badge badge-primary"> ${book.categoryName}</span>
                    <c:choose>
                        <c:when test="${book.status == 1}">
                            <span class="badge badge-success"> 上架中</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-danger"> 已下架</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="detail-price">¥${book.price}</div>
                
                <div class="detail-meta">
                    <div class="meta-item">
                        <span class="meta-label">ISBN</span>
                        <span>${book.isbn}</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">出版社</span>
                        <span>${book.publisher}</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">出版日期</span>
                        <span>${book.publishDate}</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">库存</span>
                        <span>${book.stock}</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">可借</span>
                        <span>${book.available}</span>
                    </div>
                </div>
                
                <div class="detail-desc">
                    <h3>图书简介</h3>
                    <p>${book.description}</p>
                </div>
                
                <div class="detail-actions">
                    <button class="btn btn-primary btn-lg borrow-btn" data-book-id="${book.id}" onclick="borrowBook(${book.id}, this)" <c:if test="${book.available <= 0}">disabled</c:if>>
                        <c:choose>
                            <c:when test="${book.available > 0}">立即借阅</c:when>
                            <c:otherwise>暂无库存</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary btn-lg">返回列表</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function borrowBook(bookId, btn) {
            <c:if test="${empty sessionScope.loginUser}">
                showToast('请先登录', 'warning');
                setTimeout(function() {
                    location.href = '${pageContext.request.contextPath}/login.jsp';
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
                        location.href = '${pageContext.request.contextPath}/user/borrow-list';
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