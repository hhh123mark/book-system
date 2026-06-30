package com.library.controller;

import com.library.entity.Category;
import com.library.service.CategoryService;
import com.library.service.impl.CategoryServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class AdminCategoryServlet extends HttpServlet {

    private CategoryService categoryService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listCategories(request, response);
                break;
            case "edit":
                getCategory(request, response);
                break;
            default:
                listCategories(request, response);
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

        switch (action) {
            case "add":
                addCategory(request, response);
                break;
            case "update":
                updateCategory(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/category?action=list");
                break;
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categoryList = categoryService.getAll();
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("/admin/category-list.jsp").forward(request, response);
    }

    private void getCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"参数错误\"}");
            return;
        }

        try {
            Integer id = Integer.parseInt(idStr);
            Category category = categoryService.getById(id);

            if (category != null) {
                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"data\":{");
                json.append("\"id\":").append(category.getId()).append(",");
                json.append("\"name\":\"").append(escapeJson(category.getName())).append("\",");
                json.append("\"description\":\"").append(escapeJson(category.getDescription() == null ? "" : category.getDescription())).append("\",");
                json.append("\"sortOrder\":").append(category.getSortOrder() == null ? 0 : category.getSortOrder());
                json.append("}}");
                response.getWriter().write(json.toString());
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"分类不存在\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"参数错误\"}");
        }
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String sortOrderStr = request.getParameter("sortOrder");

        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/category?action=list");
            return;
        }

        Category category = new Category();
        category.setName(name);
        category.setDescription(description);

        if (sortOrderStr != null && !sortOrderStr.trim().isEmpty()) {
            try {
                category.setSortOrder(Integer.parseInt(sortOrderStr));
            } catch (NumberFormatException e) {
                category.setSortOrder(0);
            }
        } else {
            category.setSortOrder(0);
        }

        categoryService.add(category);

        response.sendRedirect(request.getContextPath() + "/admin/category?action=list");
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/category?action=list");
            return;
        }

        try {
            Integer id = Integer.parseInt(idStr);
            Category category = categoryService.getById(id);
            if (category == null) {
                response.sendRedirect(request.getContextPath() + "/admin/category?action=list");
                return;
            }

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String sortOrderStr = request.getParameter("sortOrder");

            category.setName(name);
            category.setDescription(description);

            if (sortOrderStr != null && !sortOrderStr.trim().isEmpty()) {
                try {
                    category.setSortOrder(Integer.parseInt(sortOrderStr));
                } catch (NumberFormatException e) {
                }
            }

            categoryService.update(category);

            response.sendRedirect(request.getContextPath() + "/admin/category?action=list");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/category?action=list");
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"参数错误\"}");
            return;
        }

        try {
            Integer id = Integer.parseInt(idStr);
            boolean result = categoryService.delete(id);

            if (result) {
                response.getWriter().write("{\"success\":true,\"message\":\"删除成功\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"删除失败\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"参数错误\"}");
        }
    }

    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}