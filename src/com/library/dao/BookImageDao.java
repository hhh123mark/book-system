package com.library.dao;

import com.library.entity.BookImage;
import java.util.List;

public interface BookImageDao {
    List<BookImage> findByBookId(Integer bookId);
    int save(BookImage image);
    int deleteById(Integer id);
    int deleteByBookId(Integer bookId);
}
