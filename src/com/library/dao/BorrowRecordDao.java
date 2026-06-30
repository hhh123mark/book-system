package com.library.dao;

import com.library.entity.BorrowRecord;
import java.time.LocalDate;
import java.util.List;

public interface BorrowRecordDao {
    BorrowRecord findById(Integer id);
    List<BorrowRecord> findByUserId(Integer userId, int offset, int pageSize);
    List<BorrowRecord> findAll(int offset, int pageSize);
    List<BorrowRecord> findByCondition(String keyword, Integer status, int offset, int pageSize);
    int countByUserId(Integer userId);
    int countAll();
    int countByCondition(String keyword, Integer status);
    int save(BorrowRecord record);
    int updateReturn(Integer id, LocalDate returnDate, Integer status);
    BorrowRecord findActiveByUserAndBook(Integer userId, Integer bookId);
    List<BorrowRecord> findDetailByUserId(Integer userId, int offset, int pageSize);
    List<BorrowRecord> findDetailByUserIdAndStatus(Integer userId, Integer status, int offset, int pageSize);
    int countByUserIdAndStatus(Integer userId, Integer status);
    List<BorrowRecord> findAllDetail(int offset, int pageSize);
}
