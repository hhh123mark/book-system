package com.library.service;

import com.library.entity.BorrowRecord;
import com.library.util.PageUtil;

public interface BorrowService {
    boolean borrowBook(Integer userId, Integer bookId, int days);
    boolean returnBook(Integer borrowId);
    PageUtil getMyBorrows(Integer userId, int pageNo, int pageSize);
    PageUtil getBorrowPageByUserId(Integer userId, int pageNo, int pageSize, Integer status);
    PageUtil getAllBorrows(int pageNo, int pageSize);
    PageUtil getBorrowPage(int pageNo, int pageSize, String keyword, Integer status);
    BorrowRecord getById(Integer id);
    boolean hasActiveBorrow(Integer userId, Integer bookId);
}
