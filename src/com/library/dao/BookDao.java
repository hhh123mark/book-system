package com.library.dao;

import com.library.entity.Book;
import java.util.List;

public interface BookDao {
    Book findById(Integer id);
    List<Book> findAll(int offset, int pageSize);
    List<Book> findByCondition(String keyword, Integer categoryId, int offset, int pageSize, String sortField, String sortOrder);
    int countAll();
    int countByCondition(String keyword, Integer categoryId);
    int save(Book book);
    int update(Book book);
    int deleteById(Integer id);
    int updateStatus(Integer id, Integer status);
    int updateStock(Integer bookId, int change);
    List<Book> findByCategoryId(Integer categoryId);
    Book findDetailById(Integer id);
}
