package com.library.controller;

import com.library.entity.User;
import com.library.service.UserService;
import com.library.service.impl.UserServiceImpl;
import com.library.util.CSRFUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userService.login(username, password);

        if (user != null) {
            if (user.getStatus() == 0) {
                request.setAttribute("errorMsg", "\u8d26\u53f7\u5df2\u88ab\u7981\u7528\uff0c\u8bf7\u8054\u7cfb\u7ba1\u7406\u5458");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("loginUser", user);

            String csrfToken = CSRFUtil.generateToken();
            session.setAttribute("csrfToken", csrfToken);

            if (user.getRole() == 1) {
                response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        } else {
            request.setAttribute("errorMsg", "\u7528\u6237\u540d\u6216\u5bc6\u7801\u9519\u8bef");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
