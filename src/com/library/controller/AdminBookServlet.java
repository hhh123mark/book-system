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
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class AdminBookServlet extends HttpServlet {

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
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBook(request, response);
                break;
            default:
                listBooks(request, response);
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
                addBook(request, response);
                break;
            case "update":
                updateBook(request, response);
                break;
            case "updateStatus":
                updateStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
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

        PageUtil pageUtil = bookService.getBookPage(pageNo, pageSize, keyword, null, null, null);

        request.setAttribute("pageBean", pageUtil);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/admin/book-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categoryList = categoryService.getAll();
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("formAction", "add");
        request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
            return;
        }

        try {
            Integer id = Integer.parseInt(idStr);
            Book book = bookService.getDetailById(id);
            if (book == null) {
                response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
                return;
            }

            List<BookImage> images = bookService.getBookImages(id);
            List<Category> categoryList = categoryService.getAll();

            request.setAttribute("book", book);
            request.setAttribute("images", images);
            request.setAttribute("categoryList", categoryList);
            request.setAttribute("formAction", "edit");

            request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
        }
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                Integer id = Integer.parseInt(idStr);
                bookService.delete(id);
            } catch (NumberFormatException e) {
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
    }

    private void addBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String isbn = request.getParameter("isbn");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String publisher = request.getParameter("publisher");
        String publishDateStr = request.getParameter("publishDate");
        String categoryIdStr = request.getParameter("categoryId");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String coverImage = request.getParameter("coverImage");
        String description = request.getParameter("description");
        String[] imagePaths = request.getParameterValues("imagePaths");
        String[] imageNames = request.getParameterValues("imageNames");

        Book book = new Book();
        book.setIsbn(isbn);
        book.setTitle(title);
        book.setAuthor(author);
        book.setPublisher(publisher);

        if (publishDateStr != null && !publishDateStr.trim().isEmpty()) {
            try {
                book.setPublishDate(LocalDate.parse(publishDateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd")));
            } catch (Exception e) {
            }
        }

        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                book.setCategoryId(Integer.parseInt(categoryIdStr));
            } catch (NumberFormatException e) {
            }
        }

        if (priceStr != null && !priceStr.trim().isEmpty()) {
            try {
                book.setPrice(new BigDecimal(priceStr));
            } catch (NumberFormatException e) {
            }
        }

        if (stockStr != null && !stockStr.trim().isEmpty()) {
            try {
                int stock = Integer.parseInt(stockStr);
                book.setStock(stock);
                book.setAvailable(stock);
            } catch (NumberFormatException e) {
            }
        }

        book.setCoverImage(coverImage);
        book.setDescription(description);
        book.setStatus(1);

        List<BookImage> images = new ArrayList<>();
        if (imagePaths != null) {
            for (int i = 0; i < imagePaths.length; i++) {
                BookImage img = new BookImage();
                img.setImagePath(imagePaths[i]);
                img.setImageName(imageNames != null && i < imageNames.length ? imageNames[i] : "");
                img.setSortOrder(i + 1);
                images.add(img);
            }
        }

        boolean result = bookService.addBookWithImages(book, images);

        if (result) {
            response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
        } else {
            request.setAttribute("errorMsg", "添加失败");
            List<Category> categoryList = categoryService.getAll();
            request.setAttribute("categoryList", categoryList);
            request.setAttribute("book", book);
            request.setAttribute("formAction", "add");
            request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);
        }
    }

    private void updateBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
            return;
        }

        try {
            Integer id = Integer.parseInt(idStr);
            Book book = bookService.getById(id);
            if (book == null) {
                response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
                return;
            }

            String isbn = request.getParameter("isbn");
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String publisher = request.getParameter("publisher");
            String publishDateStr = request.getParameter("publishDate");
            String categoryIdStr = request.getParameter("categoryId");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            String coverImage = request.getParameter("coverImage");
            String description = request.getParameter("description");

            book.setIsbn(isbn);
            book.setTitle(title);
            book.setAuthor(author);
            book.setPublisher(publisher);

            if (publishDateStr != null && !publishDateStr.trim().isEmpty()) {
                try {
                    book.setPublishDate(LocalDate.parse(publishDateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd")));
                } catch (Exception e) {
                }
            }

            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    book.setCategoryId(Integer.parseInt(categoryIdStr));
                } catch (NumberFormatException e) {
                }
            }

            if (priceStr != null && !priceStr.trim().isEmpty()) {
                try {
                    book.setPrice(new BigDecimal(priceStr));
                } catch (NumberFormatException e) {
                }
            }

            if (stockStr != null && !stockStr.trim().isEmpty()) {
                try {
                    int stock = Integer.parseInt(stockStr);
                    int oldStock = book.getStock() == null ? 0 : book.getStock();
                    int oldAvailable = book.getAvailable() == null ? 0 : book.getAvailable();
                    int diff = stock - oldStock;
                    book.setStock(stock);
                    book.setAvailable(oldAvailable + diff);
                    if (book.getAvailable() < 0) {
                        book.setAvailable(0);
                    }
                } catch (NumberFormatException e) {
                }
            }

            book.setCoverImage(coverImage);
            book.setDescription(description);

            boolean result = bookService.update(book);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
            } else {
                request.setAttribute("errorMsg", "更新失败");
                List<Category> categoryList = categoryService.getAll();
                request.setAttribute("categoryList", categoryList);
                request.setAttribute("book", book);
                request.setAttribute("formAction", "edit");
                request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
        }
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
            boolean result = bookService.updateStatus(id, status);

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
