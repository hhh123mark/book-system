package com.library.controller;

import com.library.entity.User;
import com.library.service.BorrowService;
import com.library.service.UserService;
import com.library.service.impl.BorrowServiceImpl;
import com.library.service.impl.UserServiceImpl;
import com.library.util.PageUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class UserServlet extends HttpServlet {

    private UserService userService = new UserServiceImpl();
    private BorrowService borrowService = new BorrowServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestUri = request.getRequestURI();
        if (requestUri.endsWith("/borrow-list")) {
            listMyBorrows(request, response);
            return;
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loginUser");

        User freshUser = userService.getById(user.getId());
        request.setAttribute("user", freshUser);

        request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("loginUser");

        String action = request.getParameter("action");
        if ("updateAvatar".equals(action)) {
            String avatar = request.getParameter("avatar");
            boolean result = userService.updateAvatar(sessionUser.getId(), avatar);
            response.setContentType("application/json;charset=UTF-8");
            if (result) {
                User updatedUser = userService.getById(sessionUser.getId());
                session.setAttribute("loginUser", updatedUser);
                response.getWriter().write("{\"success\":true}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"更新失败\"}");
            }
            return;
        }

        String nickname = request.getParameter("nickname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        User user = new User();
        user.setId(sessionUser.getId());
        user.setNickname(nickname);
        user.setEmail(email);
        user.setPhone(phone);

        boolean result = userService.updateProfile(user);

        if (result) {
            User updatedUser = userService.getById(sessionUser.getId());
            session.setAttribute("loginUser", updatedUser);
            request.setAttribute("successMsg", "更新成功");
            request.setAttribute("user", updatedUser);
        } else {
            request.setAttribute("errorMsg", "更新失败");
            request.setAttribute("user", user);
        }

        request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
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

        String statusStr = request.getParameter("status");
        Integer status = null;
        if (statusStr != null && !statusStr.trim().isEmpty()) {
            try {
                status = Integer.parseInt(statusStr);
            } catch (NumberFormatException e) {
                status = null;
            }
        }

        PageUtil pageUtil = borrowService.getBorrowPageByUserId(user.getId(), pageNo, pageSize, status);

        request.setAttribute("pageBean", pageUtil);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/user/borrow-list.jsp").forward(request, response);
    }
}
