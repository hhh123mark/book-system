package com.library.controller;

import com.library.entity.Book;
import com.library.entity.BorrowRecord;
import com.library.entity.User;
import com.library.service.BookService;
import com.library.service.BorrowService;
import com.library.service.UserService;
import com.library.service.impl.BookServiceImpl;
import com.library.service.impl.BorrowServiceImpl;
import com.library.service.impl.UserServiceImpl;
import com.library.util.PageUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class ExportServlet extends HttpServlet {

    private BookService bookService = new BookServiceImpl();
    private BorrowService borrowService = new BorrowServiceImpl();
    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        if (type == null) {
            type = "";
        }

        response.setContentType("text/csv;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        switch (type) {
            case "books":
                exportBooks(response);
                break;
            case "borrows":
                exportBorrows(response);
                break;
            case "users":
                exportUsers(response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                break;
        }
    }

    private void exportBooks(HttpServletResponse response) throws IOException {
        response.setHeader("Content-Disposition", "attachment; filename=books.csv");

        PageUtil pageUtil = bookService.getBookPage(1, Integer.MAX_VALUE);
        @SuppressWarnings("unchecked")
        List<Book> books = (List<Book>) pageUtil.getList();

        PrintWriter writer = response.getWriter();
        writer.write('\uFEFF');
        writer.println("ID,ISBN,书名,作者,出版社,出版日期,分类ID,价格,库存,可借数量,状态");

        for (Book book : books) {
            writer.print(book.getId() + ",");
            writer.print(escapeCsv(book.getIsbn()) + ",");
            writer.print(escapeCsv(book.getTitle()) + ",");
            writer.print(escapeCsv(book.getAuthor()) + ",");
            writer.print(escapeCsv(book.getPublisher()) + ",");
            writer.print(book.getPublishDate() + ",");
            writer.print(book.getCategoryId() + ",");
            writer.print(book.getPrice() + ",");
            writer.print(book.getStock() + ",");
            writer.print(book.getAvailable() + ",");
            writer.println(book.getStatus() == 1 ? "上架" : "下架");
        }

        writer.flush();
    }

    private void exportBorrows(HttpServletResponse response) throws IOException {
        response.setHeader("Content-Disposition", "attachment; filename=borrows.csv");

        PageUtil pageUtil = borrowService.getAllBorrows(1, Integer.MAX_VALUE);
        @SuppressWarnings("unchecked")
        List<BorrowRecord> borrows = (List<BorrowRecord>) pageUtil.getList();

        PrintWriter writer = response.getWriter();
        writer.write('\uFEFF');
        writer.println("ID,用户ID,图书ID,借阅日期,应还日期,归还日期,状态,备注");

        for (BorrowRecord record : borrows) {
            writer.print(record.getId() + ",");
            writer.print(record.getUserId() + ",");
            writer.print(record.getBookId() + ",");
            writer.print(record.getBorrowDate() + ",");
            writer.print(record.getDueDate() + ",");
            writer.print(record.getReturnDate() == null ? "" : record.getReturnDate() + ",");
            writer.print(getBorrowStatusText(record.getStatus()) + ",");
            writer.println(escapeCsv(record.getRemark() == null ? "" : record.getRemark()));
        }

        writer.flush();
    }

    private void exportUsers(HttpServletResponse response) throws IOException {
        response.setHeader("Content-Disposition", "attachment; filename=users.csv");

        PageUtil pageUtil = userService.getUserPage(1, Integer.MAX_VALUE);
        @SuppressWarnings("unchecked")
        List<User> users = (List<User>) pageUtil.getList();

        PrintWriter writer = response.getWriter();
        writer.write('\uFEFF');
        writer.println("ID,用户名,昵称,邮箱,电话,角色,状态,创建时间");

        for (User user : users) {
            writer.print(user.getId() + ",");
            writer.print(escapeCsv(user.getUsername()) + ",");
            writer.print(escapeCsv(user.getNickname() == null ? "" : user.getNickname()) + ",");
            writer.print(escapeCsv(user.getEmail() == null ? "" : user.getEmail()) + ",");
            writer.print(escapeCsv(user.getPhone() == null ? "" : user.getPhone()) + ",");
            writer.print(user.getRole() == 1 ? "管理员" : "普通用户" + ",");
            writer.print(user.getStatus() == 1 ? "启用" : "禁用" + ",");
            writer.println(user.getCreateTime());
        }

        writer.flush();
    }

    private String getBorrowStatusText(Integer status) {
        if (status == null) return "未知";
        switch (status) {
            case 0:
                return "借阅中";
            case 1:
                return "已归还";
            case 2:
                return "已逾期";
            default:
                return "未知";
        }
    }

    private String escapeCsv(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }
}
