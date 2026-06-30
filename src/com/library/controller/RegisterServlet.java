package com.library.controller;

import com.library.entity.User;
import com.library.service.UserService;
import com.library.service.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String nickname = request.getParameter("nickname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("errorMsg", "\u7528\u6237\u540d\u4e0d\u80fd\u4e3a\u7a7a");
            setFormAttributes(request, username, nickname, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (username.length() < 3 || username.length() > 20) {
            request.setAttribute("errorMsg", "\u7528\u6237\u540d\u957f\u5ea6\u5fc5\u987b\u57283-20\u4e2a\u5b57\u7b26\u4e4b\u95f4");
            setFormAttributes(request, username, nickname, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMsg", "\u5bc6\u7801\u4e0d\u80fd\u4e3a\u7a7a");
            setFormAttributes(request, username, nickname, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6 || password.length() > 20) {
            request.setAttribute("errorMsg", "\u5bc6\u7801\u957f\u5ea6\u5fc5\u987b\u57286-20\u4e2a\u5b57\u7b26\u4e4b\u95f4");
            setFormAttributes(request, username, nickname, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userService.checkUsername(username)) {
            request.setAttribute("errorMsg", "\u7528\u6237\u540d\u5df2\u5b58\u5728");
            setFormAttributes(request, username, nickname, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setNickname(nickname);
        user.setEmail(email);
        user.setPhone(phone);

        boolean result = userService.register(user);

        if (result) {
            response.sendRedirect(request.getContextPath() + "/login?msg=\u6ce8\u518c\u6210\u529f\uff0c\u8bf7\u767b\u5f55");
        } else {
            request.setAttribute("errorMsg", "\u6ce8\u518c\u5931\u8d25\uff0c\u8bf7\u91cd\u8bd5");
            setFormAttributes(request, username, nickname, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void setFormAttributes(HttpServletRequest request, String username,
                                    String nickname, String email, String phone) {
        request.setAttribute("username", username);
        request.setAttribute("nickname", nickname);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
    }
}
