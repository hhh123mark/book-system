package com.library.dao.impl;

import com.library.dao.BookImageDao;
import com.library.entity.BookImage;
import com.library.util.DBUtil;
import com.library.util.XSSUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookImageDaoImpl implements BookImageDao {

    private BookImage mapRow(ResultSet rs) throws SQLException {
        BookImage image = new BookImage();
        image.setId(rs.getInt("id"));
        image.setBookId(rs.getInt("book_id"));
        image.setImagePath(XSSUtil.escapeHtml(rs.getString("image_path")));
        image.setImageName(XSSUtil.escapeHtml(rs.getString("image_name")));
        image.setSortOrder(rs.getInt("sort_order"));
        image.setCreateTime(rs.getObject("create_time", java.time.LocalDateTime.class));
        return image;
    }

    @Override
    public List<BookImage> findByBookId(Integer bookId) {
        List<BookImage> list = new ArrayList<>();
        String sql = "SELECT * FROM book_image WHERE book_id = ? ORDER BY sort_order ASC, id ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, bookId);
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
    public int save(BookImage image) {
        String sql = "INSERT INTO book_image (book_id, image_path, image_name, sort_order, create_time) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, image.getBookId());
            pstmt.setString(2, image.getImagePath());
            pstmt.setString(3, image.getImageName());
            pstmt.setInt(4, image.getSortOrder());
            pstmt.setObject(5, image.getCreateTime());
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int deleteById(Integer id) {
        String sql = "DELETE FROM book_image WHERE id = ?";
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
    public int deleteByBookId(Integer bookId) {
        String sql = "DELETE FROM book_image WHERE book_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, bookId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
