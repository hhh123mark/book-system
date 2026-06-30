package com.library.controller;

import com.library.entity.Book;
import com.library.entity.BookImage;
import com.library.entity.Category;
import com.library.service.BookService;
import com.library.service.CategoryService;
import com.library.service.impl.BookServiceImpl;
import com.library.service.impl.CategoryServiceImpl;
import com.library.util.PageUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class BookServlet extends HttpServlet {

    private BookService bookService = new BookServiceImpl();
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
                listBooks(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            default:
                listBooks(request, response);
                break;
        }
    }

    private void listBooks(HttpServletRequest request, HttpServletResponse response)
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
        String categoryIdStr = request.getParameter("categoryId");
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                categoryId = null;
            }
        }
        String sortField = request.getParameter("sortField");
        String sortOrder = request.getParameter("sortOrder");

        PageUtil pageUtil = bookService.getBookPage(pageNo, pageSize, keyword, categoryId, sortField, sortOrder);
        List<Category> categoryList = categoryService.getAll();

        request.setAttribute("pageBean", pageUtil);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("keyword", keyword);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("sortField", sortField);
        request.setAttribute("sortOrder", sortOrder);

        request.getRequestDispatcher("/book-list.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/book?action=list");
            return;
        }

        try {
            Integer id = Integer.parseInt(idStr);
            Book book = bookService.getDetailById(id);
            if (book == null) {
                response.sendRedirect(request.getContextPath() + "/book?action=list");
                return;
            }

            List<BookImage> images = bookService.getBookImages(id);

            request.setAttribute("book", book);
            request.setAttribute("images", images);

            request.getRequestDispatcher("/book-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/book?action=list");
        }
    }
}
