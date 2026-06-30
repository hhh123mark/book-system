package com.library.dao;

import com.library.entity.Category;
import java.util.List;

public interface CategoryDao {
    Category findById(Integer id);
    List<Category> findAll();
    int save(Category category);
    int update(Category category);
    int deleteById(Integer id);
    boolean existsByName(String name);
}
