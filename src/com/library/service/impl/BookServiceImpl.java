package com.library.service.impl;

import com.library.dao.BookDao;
import com.library.dao.BookImageDao;
import com.library.dao.impl.BookDaoImpl;
import com.library.dao.impl.BookImageDaoImpl;
import com.library.entity.Book;
import com.library.entity.BookImage;
import com.library.service.BookService;
import com.library.util.DBUtil;
import com.library.util.PageUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.List;

public class BookServiceImpl implements BookService {

    private BookDao bookDao = new BookDaoImpl();
    private BookImageDao bookImageDao = new BookImageDaoImpl();

    @Override
    public Book getById(Integer id) {
        try {
            return bookDao.findById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Book getDetailById(Integer id) {
        try {
            return bookDao.findDetailById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public PageUtil getBookPage(int pageNo, int pageSize) {
        try {
            int totalCount = bookDao.countAll();
            PageUtil pageUtil = new PageUtil(pageNo, pageSize, totalCount);
            List<Book> list = bookDao.findAll(pageUtil.getOffset(), pageSize);
            pageUtil.setList(list);
            return pageUtil;
        } catch (Exception e) {
            e.printStackTrace();
            return new PageUtil(pageNo, pageSize, 0);
        }
    }

    @Override
    public PageUtil getBookPage(int pageNo, int pageSize, String keyword, Integer categoryId, String sortField, String sortOrder) {
        try {
            int totalCount = bookDao.countByCondition(keyword, categoryId);
            PageUtil pageUtil = new PageUtil(pageNo, pageSize, totalCount);
            List<Book> list = bookDao.findByCondition(keyword, categoryId, pageUtil.getOffset(), pageSize, sortField, sortOrder);
            pageUtil.setList(list);
            return pageUtil;
        } catch (Exception e) {
            e.printStackTrace();
            return new PageUtil(pageNo, pageSize, 0);
        }
    }

    @Override
    public boolean add(Book book) {
        try {
            book.setCreateTime(LocalDateTime.now());
            book.setUpdateTime(LocalDateTime.now());
            if (book.getStatus() == null) {
                book.setStatus(1);
            }
            int result = bookDao.save(book);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean update(Book book) {
        try {
            book.setUpdateTime(LocalDateTime.now());
            int result = bookDao.update(book);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(Integer id) {
        try {
            int result = bookDao.deleteById(id);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateStatus(Integer id, Integer status) {
        try {
            int result = bookDao.updateStatus(id, status);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<BookImage> getBookImages(Integer bookId) {
        try {
            return bookImageDao.findByBookId(bookId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean addBookImage(BookImage image) {
        try {
            image.setCreateTime(LocalDateTime.now());
            int result = bookImageDao.save(image);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteBookImage(Integer id) {
        try {
            int result = bookImageDao.deleteById(id);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean addBookWithImages(Book book, List<BookImage> images) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            DBUtil.beginTransaction(conn);

            String bookSql = "INSERT INTO book (isbn, title, author, publisher, publish_date, category_id, price, stock, available, cover_image, description, status, create_time, update_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement bookPstmt = conn.prepareStatement(bookSql, Statement.RETURN_GENERATED_KEYS);
            bookPstmt.setString(1, book.getIsbn());
            bookPstmt.setString(2, book.getTitle());
            bookPstmt.setString(3, book.getAuthor());
            bookPstmt.setString(4, book.getPublisher());
            bookPstmt.setObject(5, book.getPublishDate());
            bookPstmt.setInt(6, book.getCategoryId());
            bookPstmt.setBigDecimal(7, book.getPrice());
            bookPstmt.setInt(8, book.getStock());
            bookPstmt.setInt(9, book.getAvailable());
            bookPstmt.setString(10, book.getCoverImage());
            bookPstmt.setString(11, book.getDescription());
            bookPstmt.setInt(12, book.getStatus() != null ? book.getStatus() : 1);
            bookPstmt.setObject(13, LocalDateTime.now());
            bookPstmt.setObject(14, LocalDateTime.now());
            bookPstmt.executeUpdate();

            Integer bookId = null;
            ResultSet generatedKeys = bookPstmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                bookId = generatedKeys.getInt(1);
            }
            generatedKeys.close();
            bookPstmt.close();

            if (bookId == null) {
                DBUtil.rollbackTransaction(conn);
                return false;
            }

            if (images != null && !images.isEmpty()) {
                String imageSql = "INSERT INTO book_image (book_id, image_path, image_name, sort_order, create_time) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement imagePstmt = conn.prepareStatement(imageSql);
                for (BookImage image : images) {
                    imagePstmt.setInt(1, bookId);
                    imagePstmt.setString(2, image.getImagePath());
                    imagePstmt.setString(3, image.getImageName());
                    imagePstmt.setInt(4, image.getSortOrder() != null ? image.getSortOrder() : 0);
                    imagePstmt.setObject(5, LocalDateTime.now());
                    imagePstmt.addBatch();
                }
                imagePstmt.executeBatch();
                imagePstmt.close();
            }

            DBUtil.commitTransaction(conn);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    DBUtil.rollbackTransaction(conn);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            DBUtil.close(conn);
        }
    }
}
