package com.library.service.impl;

import com.library.dao.CategoryDao;
import com.library.dao.impl.CategoryDaoImpl;
import com.library.entity.Category;
import com.library.service.CategoryService;

import java.time.LocalDateTime;
import java.util.List;

public class CategoryServiceImpl implements CategoryService {

    private CategoryDao categoryDao = new CategoryDaoImpl();

    @Override
    public List<Category> getAll() {
        try {
            return categoryDao.findAll();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Category getById(Integer id) {
        try {
            return categoryDao.findById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean add(Category category) {
        try {
            category.setCreateTime(LocalDateTime.now());
            int result = categoryDao.save(category);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean update(Category category) {
        try {
            int result = categoryDao.update(category);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(Integer id) {
        try {
            int result = categoryDao.deleteById(id);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
