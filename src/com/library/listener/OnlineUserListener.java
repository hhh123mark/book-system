package com.library.listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class OnlineUserListener implements ServletContextListener, HttpSessionListener {

    private static final String ONLINE_COUNT = "onlineCount";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        context.setAttribute(ONLINE_COUNT, 0);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        Integer count = (Integer) context.getAttribute(ONLINE_COUNT);
        if (count == null) {
            count = 0;
        }
        context.setAttribute(ONLINE_COUNT, count + 1);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        Integer count = (Integer) context.getAttribute(ONLINE_COUNT);
        if (count == null) {
            count = 0;
        }
        if (count > 0) {
            context.setAttribute(ONLINE_COUNT, count - 1);
        }
    }
}
