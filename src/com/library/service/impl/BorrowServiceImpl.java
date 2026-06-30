package com.library.service.impl;

import com.library.dao.BookDao;
import com.library.dao.BorrowRecordDao;
import com.library.dao.impl.BookDaoImpl;
import com.library.dao.impl.BorrowRecordDaoImpl;
import com.library.entity.Book;
import com.library.entity.BorrowRecord;
import com.library.service.BorrowService;
import com.library.util.DBUtil;
import com.library.util.PageUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class BorrowServiceImpl implements BorrowService {

    private BorrowRecordDao borrowRecordDao = new BorrowRecordDaoImpl();
    private BookDao bookDao = new BookDaoImpl();

    @Override
    public boolean borrowBook(Integer userId, Integer bookId, int days) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            DBUtil.beginTransaction(conn);

            String checkSql = "SELECT available FROM book WHERE id = ? FOR UPDATE";
            PreparedStatement checkPstmt = conn.prepareStatement(checkSql);
            checkPstmt.setInt(1, bookId);
            java.sql.ResultSet rs = checkPstmt.executeQuery();
            if (!rs.next()) {
                rs.close();
                checkPstmt.close();
                DBUtil.rollbackTransaction(conn);
                return false;
            }
            int available = rs.getInt("available");
            rs.close();
            checkPstmt.close();

            if (available <= 0) {
                DBUtil.rollbackTransaction(conn);
                return false;
            }

            String updateStockSql = "UPDATE book SET available = available - 1, update_time = NOW() WHERE id = ?";
            PreparedStatement updatePstmt = conn.prepareStatement(updateStockSql);
            updatePstmt.setInt(1, bookId);
            updatePstmt.executeUpdate();
            updatePstmt.close();

            String insertSql = "INSERT INTO borrow_record (user_id, book_id, borrow_date, due_date, status, create_time, update_time) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement insertPstmt = conn.prepareStatement(insertSql);
            LocalDate borrowDate = LocalDate.now();
            LocalDate dueDate = borrowDate.plusDays(days);
            insertPstmt.setInt(1, userId);
            insertPstmt.setInt(2, bookId);
            insertPstmt.setObject(3, borrowDate);
            insertPstmt.setObject(4, dueDate);
            insertPstmt.setInt(5, 0);
            insertPstmt.setObject(6, LocalDateTime.now());
            insertPstmt.setObject(7, LocalDateTime.now());
            insertPstmt.executeUpdate();
            insertPstmt.close();

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

    @Override
    public boolean returnBook(Integer borrowId) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            DBUtil.beginTransaction(conn);

            String selectSql = "SELECT book_id, status FROM borrow_record WHERE id = ?";
            PreparedStatement selectPstmt = conn.prepareStatement(selectSql);
            selectPstmt.setInt(1, borrowId);
            java.sql.ResultSet rs = selectPstmt.executeQuery();
            if (!rs.next()) {
                rs.close();
                selectPstmt.close();
                DBUtil.rollbackTransaction(conn);
                return false;
            }
            Integer bookId = rs.getInt("book_id");
            Integer status = rs.getInt("status");
            rs.close();
            selectPstmt.close();

            if (status != 0) {
                DBUtil.rollbackTransaction(conn);
                return false;
            }

            String updateBorrowSql = "UPDATE borrow_record SET return_date = ?, status = 1, update_time = NOW() WHERE id = ?";
            PreparedStatement updateBorrowPstmt = conn.prepareStatement(updateBorrowSql);
            updateBorrowPstmt.setObject(1, LocalDate.now());
            updateBorrowPstmt.setInt(2, borrowId);
            updateBorrowPstmt.executeUpdate();
            updateBorrowPstmt.close();

            String updateStockSql = "UPDATE book SET available = available + 1, update_time = NOW() WHERE id = ?";
            PreparedStatement updateStockPstmt = conn.prepareStatement(updateStockSql);
            updateStockPstmt.setInt(1, bookId);
            updateStockPstmt.executeUpdate();
            updateStockPstmt.close();

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

    @Override
    public PageUtil getMyBorrows(Integer userId, int pageNo, int pageSize) {
        try {
            int totalCount = borrowRecordDao.countByUserId(userId);
            PageUtil pageUtil = new PageUtil(pageNo, pageSize, totalCount);
            List<BorrowRecord> list = borrowRecordDao.findDetailByUserId(userId, pageUtil.getOffset(), pageSize);
            pageUtil.setList(list);
            return pageUtil;
        } catch (Exception e) {
            e.printStackTrace();
            return new PageUtil(pageNo, pageSize, 0);
        }
    }

    @Override
    public PageUtil getBorrowPageByUserId(Integer userId, int pageNo, int pageSize, Integer status) {
        try {
            int totalCount = borrowRecordDao.countByUserIdAndStatus(userId, status);
            PageUtil pageUtil = new PageUtil(pageNo, pageSize, totalCount);
            List<BorrowRecord> list = borrowRecordDao.findDetailByUserIdAndStatus(userId, status, pageUtil.getOffset(), pageSize);
            pageUtil.setList(list);
            return pageUtil;
        } catch (Exception e) {
            e.printStackTrace();
            return new PageUtil(pageNo, pageSize, 0);
        }
    }

    @Override
    public PageUtil getAllBorrows(int pageNo, int pageSize) {
        try {
            int totalCount = borrowRecordDao.countAll();
            PageUtil pageUtil = new PageUtil(pageNo, pageSize, totalCount);
            List<BorrowRecord> list = borrowRecordDao.findAllDetail(pageUtil.getOffset(), pageSize);
            pageUtil.setList(list);
            return pageUtil;
        } catch (Exception e) {
            e.printStackTrace();
            return new PageUtil(pageNo, pageSize, 0);
        }
    }

    @Override
    public PageUtil getBorrowPage(int pageNo, int pageSize, String keyword, Integer status) {
        try {
            int totalCount = borrowRecordDao.countByCondition(keyword, status);
            PageUtil pageUtil = new PageUtil(pageNo, pageSize, totalCount);
            List<BorrowRecord> list = borrowRecordDao.findByCondition(keyword, status, pageUtil.getOffset(), pageSize);
            pageUtil.setList(list);
            return pageUtil;
        } catch (Exception e) {
            e.printStackTrace();
            return new PageUtil(pageNo, pageSize, 0);
        }
    }

    @Override
    public BorrowRecord getById(Integer id) {
        try {
            return borrowRecordDao.findById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean hasActiveBorrow(Integer userId, Integer bookId) {
        try {
            BorrowRecord record = borrowRecordDao.findActiveByUserAndBook(userId, bookId);
            return record != null;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
