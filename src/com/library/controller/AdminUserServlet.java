package com.library.controller;

import com.library.service.UserService;
import com.library.service.impl.UserServiceImpl;
import com.library.util.PageUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminUserServlet extends HttpServlet {

    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listUsers(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        if ("updateStatus".equals(action)) {
            updateStatus(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
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

        PageUtil pageUtil;
        if (keyword != null && !keyword.trim().isEmpty()) {
            pageUtil = userService.getUserPage(pageNo, pageSize, keyword);
        } else {
            pageUtil = userService.getUserPage(pageNo, pageSize);
        }

        request.setAttribute("pageBean", pageUtil);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/admin/user-list.jsp").forward(request, response);
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                Integer id = Integer.parseInt(idStr);
                userService.deleteUser(id);
            } catch (NumberFormatException e) {
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/user?action=list");
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        String idStr = request.getParameter("id");
        String statusStr = request.getParameter("status");

        if (idStr == null || statusStr == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"参数错误\"}");
            return;
        }

        try {
            Integer id = Integer.parseInt(idStr);
            Integer status = Integer.parseInt(statusStr);
            boolean result = userService.updateStatus(id, status);

            if (result) {
                response.getWriter().write("{\"success\":true,\"message\":\"操作成功\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"操作失败\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"参数错误\"}");
        }
    }
}