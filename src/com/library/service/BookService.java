package com.library.service;

import com.library.entity.Book;
import com.library.entity.BookImage;
import com.library.util.PageUtil;

import java.util.List;

public interface BookService {
    Book getById(Integer id);
    Book getDetailById(Integer id);
    PageUtil getBookPage(int pageNo, int pageSize);
    PageUtil getBookPage(int pageNo, int pageSize, String keyword, Integer categoryId, String sortField, String sortOrder);
    boolean add(Book book);
    boolean update(Book book);
    boolean delete(Integer id);
    boolean updateStatus(Integer id, Integer status);
    List<BookImage> getBookImages(Integer bookId);
    boolean addBookImage(BookImage image);
    boolean deleteBookImage(Integer id);
    boolean addBookWithImages(Book book, List<BookImage> images);
}
