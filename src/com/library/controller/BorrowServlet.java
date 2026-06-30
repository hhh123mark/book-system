package com.library.controller;

import com.library.entity.User;
import com.library.service.BorrowService;
import com.library.service.impl.BorrowServiceImpl;
import com.library.util.PageUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class BorrowServlet extends HttpServlet {

    private BorrowService borrowService = new BorrowServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        if ("list".equals(action)) {
            listMyBorrows(request, response);
        } else {
            listMyBorrows(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "borrow":
                borrowBook(request, response);
                break;
            case "return":
                returnBook(request, response);
                break;
            default:
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"\\u65e0\\u6548\\u64cd\\u4f5c\"}");
                break;
        }
    }

    private void listMyBorrows(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loginUser");

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

        PageUtil pageUtil = borrowService.getMyBorrows(user.getId(), pageNo, pageSize);

        request.setAttribute("pageBean", pageUtil);
        request.getRequestDispatcher("/borrow/list.jsp").forward(request, response);
    }

    private void borrowBook(HttpServletRequest request, HttpServletResponse response) {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("loginUser");

            response.setContentType("application/json;charset=UTF-8");

            if (user == null) {
                response.getWriter().write("{\"success\":false,\"message\":\"\\u8bf7\\u5148\\u767b\\u5f55\"}");
                return;
            }

            String bookIdStr = request.getParameter("bookId");
            String daysStr = request.getParameter("days");

            if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
                response.getWriter().write("{\"success\":false,\"message\":\"\\u56fe\\u4e66ID\\u4e0d\\u80fd\\u4e3a\\u7a7a\"}");
                return;
            }

            Integer bookId = Integer.parseInt(bookIdStr);
            int days = 30;
            if (daysStr != null && !daysStr.trim().isEmpty()) {
                days = Integer.parseInt(daysStr);
            }

            boolean result = borrowService.borrowBook(user.getId(), bookId, days);

            if (result) {
                response.getWriter().write("{\"success\":true,\"message\":\"\\u501f\\u9605\\u6210\\u529f\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"\\u501f\\u9605\\u5931\\u8d25\\uff0c\\u5e93\\u5b58\\u4e0d\\u8db3\\u6216\\u5df2\\u501f\\u9605\\u6b64\\u4e66\"}");
            }
        } catch (NumberFormatException e) {
            try {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"\\u53c2\\u6570\\u9519\\u8bef\"}");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"\\u7cfb\\u7edf\\u9519\\u8bef\\uff0c\\u8bf7\\u7a0d\\u540e\\u91cd\\u8bd5\"}");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    private void returnBook(HttpServletRequest request, HttpServletResponse response) {
        try {
            response.setContentType("application/json;charset=UTF-8");

            String borrowIdStr = request.getParameter("borrowId");

            if (borrowIdStr == null || borrowIdStr.trim().isEmpty()) {
                response.getWriter().write("{\"success\":false,\"message\":\"\\u501f\\u9605\\u8bb0\\u5f55ID\\u4e0d\\u80fd\\u4e3a\\u7a7a\"}");
                return;
            }

            Integer borrowId = Integer.parseInt(borrowIdStr);
            boolean result = borrowService.returnBook(borrowId);

            if (result) {
                response.getWriter().write("{\"success\":true,\"message\":\"\\u5f52\\u8fd8\\u6210\\u529f\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"\\u5f52\\u8fd8\\u5931\\u8d25\"}");
            }
        } catch (NumberFormatException e) {
            try {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"\\u53c2\\u6570\\u9519\\u8bef\"}");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"\\u7cfb\\u7edf\\u9519\\u8bef\\uff0c\\u8bf7\\u7a0d\\u540e\\u91cd\\u8bd5\"}");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}
