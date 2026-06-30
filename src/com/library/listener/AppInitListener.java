package com.library.listener;

import com.library.entity.Category;
import com.library.service.CategoryService;
import com.library.service.impl.CategoryServiceImpl;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.ArrayList;
import java.util.List;

public class AppInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        try {
            CategoryService categoryService = new CategoryServiceImpl();
            List<Category> categoryList = categoryService.getAll();
            if (categoryList == null) {
                categoryList = new ArrayList<>();
            }
            context.setAttribute("categoryList", categoryList);
        } catch (Exception e) {
            e.printStackTrace();
            context.setAttribute("categoryList", new ArrayList<Category>());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
