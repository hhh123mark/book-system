package com.library.controller;

import com.library.service.BorrowService;
import com.library.service.impl.BorrowServiceImpl;
import com.library.util.PageUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminBorrowServlet extends HttpServlet {

    private BorrowService borrowService = new BorrowServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        if ("list".equals(action)) {
            listBorrows(request, response);
        } else {
            listBorrows(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        if ("return".equals(action)) {
            confirmReturn(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/borrow?action=list");
        }
    }

    private void listBorrows(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pageNo = 1;
        int pageSize = 10;
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        if (pageNoStr != null && !pageNoStr.trim().isEmpty()) {
            try {
                pageNo = Integer.parseInt(pageNoStr);
            } catch (NumberFormatException e) {
                pageNo = 1;
            }
        }
        if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeStr);
            } catch (NumberFormatException e) {
                pageSize = 10;
            }
        }

        String keyword = request.getParameter("keyword");
        String statusStr = request.getParameter("status");
        Integer status = null;
        if (statusStr != null && !statusStr.trim().isEmpty()) {
            try {
                status = Integer.parseInt(statusStr);
            } catch (NumberFormatException e) {
                status = null;
            }
        }

        PageUtil pageUtil = borrowService.getBorrowPage(pageNo, pageSize, keyword, status);

        request.setAttribute("pageBean", pageUtil);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/admin/borrow-list.jsp").forward(request, response);
    }

    private void confirmReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        String borrowIdStr = request.getParameter("id");

        if (borrowIdStr == null || borrowIdStr.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"借阅记录ID不能为空\"}");
            return;
        }

        try {
            Integer borrowId = Integer.parseInt(borrowIdStr);
            boolean result = borrowService.returnBook(borrowId);

            if (result) {
                response.getWriter().write("{\"success\":true,\"message\":\"确认归还成功\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"归还失败\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"参数错误\"}");
        }
    }
}
