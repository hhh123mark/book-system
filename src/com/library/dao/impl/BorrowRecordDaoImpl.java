package com.library.dao.impl;

import com.library.dao.BorrowRecordDao;
import com.library.entity.BorrowRecord;
import com.library.util.DBUtil;
import com.library.util.XSSUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BorrowRecordDaoImpl implements BorrowRecordDao {

    private BorrowRecord mapRow(ResultSet rs) throws SQLException {
        BorrowRecord record = new BorrowRecord();
        record.setId(rs.getInt("id"));
        record.setUserId(rs.getInt("user_id"));
        record.setBookId(rs.getInt("book_id"));
        record.setBorrowDate(rs.getObject("borrow_date", LocalDate.class));
        record.setDueDate(rs.getObject("due_date", LocalDate.class));
        record.setReturnDate(rs.getObject("return_date", LocalDate.class));
        record.setStatus(rs.getInt("status"));
        record.setRemark(XSSUtil.escapeHtml(rs.getString("remark")));
        record.setCreateTime(rs.getObject("create_time", java.time.LocalDateTime.class));
        record.setUpdateTime(rs.getObject("update_time", java.time.LocalDateTime.class));
        
        try {
            record.setUsername(XSSUtil.escapeHtml(rs.getString("username")));
        } catch (SQLException e) {}
        try {
            record.setBookTitle(XSSUtil.escapeHtml(rs.getString("book_title")));
        } catch (SQLException e) {}
        try {
            record.setBookAuthor(XSSUtil.escapeHtml(rs.getString("book_author")));
        } catch (SQLException e) {}
        try {
            record.setBookCover(rs.getString("book_cover"));
        } catch (SQLException e) {}
        
        return record;
    }

    @Override
    public BorrowRecord findById(Integer id) {
        String sql = "SELECT * FROM borrow_record WHERE id = ?";
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
    public List<BorrowRecord> findByUserId(Integer userId, int offset, int pageSize) {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM borrow_record WHERE user_id = ? ORDER BY id DESC LIMIT ?, ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, offset);
            pstmt.setInt(3, pageSize);
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
    public List<BorrowRecord> findAll(int offset, int pageSize) {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM borrow_record ORDER BY id DESC LIMIT ?, ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, offset);
            pstmt.setInt(2, pageSize);
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
    public List<BorrowRecord> findByCondition(String keyword, Integer status, int offset, int pageSize) {
        List<BorrowRecord> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT br.*, u.username, b.title as book_title, b.author as book_author, b.cover_image as book_cover FROM borrow_record br JOIN user u ON br.user_id = u.id JOIN book b ON br.book_id = b.id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (u.username LIKE ? OR u.nickname LIKE ? OR b.title LIKE ? OR b.isbn LIKE ?)");
            String likeKeyword = "%" + keyword + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
        }
        if (status != null) {
            sql.append(" AND br.status = ?");
            params.add(status);
        }
        sql.append(" ORDER BY br.id DESC LIMIT ?, ?");
        params.add(offset);
        params.add(pageSize);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
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
    public int countByUserId(Integer userId) {
        String sql = "SELECT COUNT(*) FROM borrow_record WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
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
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM borrow_record";
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
    public int countByCondition(String keyword, Integer status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM borrow_record WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND id IN (SELECT br.id FROM borrow_record br JOIN user u ON br.user_id = u.id JOIN book b ON br.book_id = b.id WHERE u.username LIKE ? OR u.nickname LIKE ? OR b.title LIKE ? OR b.isbn LIKE ?)");
            String likeKeyword = "%" + keyword + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
        }
        if (status != null) {
            sql.append(" AND status = ?");
            params.add(status);
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
    public int save(BorrowRecord record) {
        String sql = "INSERT INTO borrow_record (user_id, book_id, borrow_date, due_date, return_date, status, remark, create_time, update_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, record.getUserId());
            pstmt.setInt(2, record.getBookId());
            pstmt.setObject(3, record.getBorrowDate());
            pstmt.setObject(4, record.getDueDate());
            pstmt.setObject(5, record.getReturnDate());
            pstmt.setInt(6, record.getStatus());
            pstmt.setString(7, record.getRemark());
            pstmt.setObject(8, record.getCreateTime());
            pstmt.setObject(9, record.getUpdateTime());
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int updateReturn(Integer id, LocalDate returnDate, Integer status) {
        String sql = "UPDATE borrow_record SET return_date = ?, status = ?, update_time = NOW() WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, returnDate);
            pstmt.setInt(2, status);
            pstmt.setInt(3, id);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public BorrowRecord findActiveByUserAndBook(Integer userId, Integer bookId) {
        String sql = "SELECT * FROM borrow_record WHERE user_id = ? AND book_id = ? AND status = 0 ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, bookId);
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
    public List<BorrowRecord> findDetailByUserId(Integer userId, int offset, int pageSize) {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT br.*, u.username, b.title as book_title, b.author as book_author, b.cover_image as book_cover FROM borrow_record br JOIN user u ON br.user_id = u.id JOIN book b ON br.book_id = b.id WHERE br.user_id = ? ORDER BY br.id DESC LIMIT ?, ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, offset);
            pstmt.setInt(3, pageSize);
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
    public List<BorrowRecord> findAllDetail(int offset, int pageSize) {
        List<BorrowRecord> list = new ArrayList<>();
        String sql = "SELECT br.*, u.username, b.title as book_title, b.author as book_author, b.cover_image as book_cover FROM borrow_record br JOIN user u ON br.user_id = u.id JOIN book b ON br.book_id = b.id ORDER BY br.id DESC LIMIT ?, ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, offset);
            pstmt.setInt(2, pageSize);
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
    public List<BorrowRecord> findDetailByUserIdAndStatus(Integer userId, Integer status, int offset, int pageSize) {
        List<BorrowRecord> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT br.*, u.username, b.title as book_title, b.author as book_author, b.cover_image as book_cover FROM borrow_record br JOIN user u ON br.user_id = u.id JOIN book b ON br.book_id = b.id WHERE br.user_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(userId);
        
        if (status != null) {
            sql.append(" AND br.status = ?");
            params.add(status);
        }
        
        sql.append(" ORDER BY br.id DESC LIMIT ?, ?");
        params.add(offset);
        params.add(pageSize);
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
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
    public int countByUserIdAndStatus(Integer userId, Integer status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM borrow_record WHERE user_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(userId);
        
        if (status != null) {
            sql.append(" AND status = ?");
            params.add(status);
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
}