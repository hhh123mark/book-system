package com.library.controller;

import com.library.service.UserService;
import com.library.service.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CheckUsernameServlet extends HttpServlet {

    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        boolean exists = userService.checkUsername(username);

        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"valid\":" + !exists + "}");
    }
}
