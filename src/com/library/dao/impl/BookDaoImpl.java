package com.library.dao.impl;

import com.library.dao.BookDao;
import com.library.entity.Book;
import com.library.util.DBUtil;
import com.library.util.XSSUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookDaoImpl implements BookDao {

    private Book mapRow(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getInt("id"));
        book.setIsbn(XSSUtil.escapeHtml(rs.getString("isbn")));
        book.setTitle(XSSUtil.escapeHtml(rs.getString("title")));
        book.setAuthor(XSSUtil.escapeHtml(rs.getString("author")));
        book.setPublisher(XSSUtil.escapeHtml(rs.getString("publisher")));
        book.setPublishDate(rs.getObject("publish_date", java.time.LocalDate.class));
        book.setCategoryId(rs.getInt("category_id"));
        book.setPrice(rs.getBigDecimal("price"));
        book.setStock(rs.getInt("stock"));
        book.setAvailable(rs.getInt("available"));
        book.setCoverImage(XSSUtil.escapeHtml(rs.getString("cover_image")));
        book.setDescription(XSSUtil.escapeHtml(rs.getString("description")));
        book.setStatus(rs.getInt("status"));
        book.setCreateTime(rs.getObject("create_time", java.time.LocalDateTime.class));
        book.setUpdateTime(rs.getObject("update_time", java.time.LocalDateTime.class));
        return book;
    }

    private Book mapRowWithCategory(ResultSet rs) throws SQLException {
        Book book = mapRow(rs);
        book.setCategoryName(XSSUtil.escapeHtml(rs.getString("category_name")));
        return book;
    }

    @Override
    public Book findById(Integer id) {
        String sql = "SELECT * FROM book WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Book> findAll(int offset, int pageSize) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name as category_name FROM book b LEFT JOIN category c ON b.category_id = c.id ORDER BY b.id DESC LIMIT ?, ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, offset);
            pstmt.setInt(2, pageSize);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowWithCategory(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private String sanitizeSortField(String sortField) {
        if (sortField == null) {
            return "id";
        }
        switch (sortField) {
            case "id":
            case "title":
            case "author":
            case "publisher":
            case "publishDate":
            case "price":
            case "stock":
            case "createTime":
                return sortField;
            default:
                return "id";
        }
    }

    private String sanitizeSortOrder(String sortOrder) {
        if (sortOrder == null) {
            return "DESC";
        }
        if ("ASC".equalsIgnoreCase(sortOrder)) {
            return "ASC";
        }
        return "DESC";
    }

    @Override
    public List<Book> findByCondition(String keyword, Integer categoryId, int offset, int pageSize, String sortField, String sortOrder) {
        List<Book> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT b.*, c.name as category_name FROM book b LEFT JOIN category c ON b.category_id = c.id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (b.title LIKE ? OR b.author LIKE ? OR b.isbn LIKE ? OR b.publisher LIKE ?)");
            String likeKeyword = "%" + keyword + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
        }
        if (categoryId != null) {
            sql.append(" AND b.category_id = ?");
            params.add(categoryId);
        }

        String safeSortField = sanitizeSortField(sortField);
        String safeSortOrder = sanitizeSortOrder(sortOrder);
        if ("publishDate".equals(safeSortField)) {
            sql.append(" ORDER BY b.publish_date ").append(safeSortOrder);
        } else if ("createTime".equals(safeSortField)) {
            sql.append(" ORDER BY b.create_time ").append(safeSortOrder);
        } else {
            sql.append(" ORDER BY b.").append(safeSortField).append(" ").append(safeSortOrder);
        }
        sql.append(" LIMIT ?, ?");
        params.add(offset);
        params.add(pageSize);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowWithCategory(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM book";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int countByCondition(String keyword, Integer categoryId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM book WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (title LIKE ? OR author LIKE ? OR isbn LIKE ? OR publisher LIKE ?)");
            String likeKeyword = "%" + keyword + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
        }
        if (categoryId != null) {
            sql.append(" AND category_id = ?");
            params.add(categoryId);
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int save(Book book) {
        String sql = "INSERT INTO book (isbn, title, author, publisher, publish_date, category_id, price, stock, available, cover_image, description, status, create_time, update_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, book.getIsbn());
            pstmt.setString(2, book.getTitle());
            pstmt.setString(3, book.getAuthor());
            pstmt.setString(4, book.getPublisher());
            pstmt.setObject(5, book.getPublishDate());
            pstmt.setInt(6, book.getCategoryId());
            pstmt.setBigDecimal(7, book.getPrice());
            pstmt.setInt(8, book.getStock());
            pstmt.setInt(9, book.getAvailable());
            pstmt.setString(10, book.getCoverImage());
            pstmt.setString(11, book.getDescription());
            pstmt.setInt(12, book.getStatus());
            pstmt.setObject(13, book.getCreateTime());
            pstmt.setObject(14, book.getUpdateTime());
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(Book book) {
        String sql = "UPDATE book SET isbn = ?, title = ?, author = ?, publisher = ?, publish_date = ?, category_id = ?, price = ?, stock = ?, available = ?, cover_image = ?, description = ?, status = ?, update_time = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, book.getIsbn());
            pstmt.setString(2, book.getTitle());
            pstmt.setString(3, book.getAuthor());
            pstmt.setString(4, book.getPublisher());
            pstmt.setObject(5, book.getPublishDate());
            pstmt.setInt(6, book.getCategoryId());
            pstmt.setBigDecimal(7, book.getPrice());
            pstmt.setInt(8, book.getStock());
            pstmt.setInt(9, book.getAvailable());
            pstmt.setString(10, book.getCoverImage());
            pstmt.setString(11, book.getDescription());
            pstmt.setInt(12, book.getStatus());
            pstmt.setObject(13, book.getUpdateTime());
            pstmt.setInt(14, book.getId());
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int deleteById(Integer id) {
        String sql = "DELETE FROM book WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int updateStatus(Integer id, Integer status) {
        String sql = "UPDATE book SET status = ?, update_time = NOW() WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, status);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int updateStock(Integer bookId, int change) {
        String sql = "UPDATE book SET stock = stock + ?, available = available + ?, update_time = NOW() WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, change);
            pstmt.setInt(2, change);
            pstmt.setInt(3, bookId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Book> findByCategoryId(Integer categoryId) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM book WHERE category_id = ? AND status = 1 ORDER BY id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, categoryId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Book findDetailById(Integer id) {
        String sql = "SELECT b.*, c.name as category_name FROM book b LEFT JOIN category c ON b.category_id = c.id WHERE b.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowWithCategory(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
