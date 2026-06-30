package com.library.service;

import com.library.entity.Category;
import java.util.List;

public interface CategoryService {
    List<Category> getAll();
    Category getById(Integer id);
    boolean add(Category category);
    boolean update(Category category);
    boolean delete(Integer id);
}
