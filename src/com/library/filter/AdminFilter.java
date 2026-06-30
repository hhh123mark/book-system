package com.library.filter;

import com.library.entity.User;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession();
        User user = (User) session.getAttribute("loginUser");

        if (user == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }

        if (user.getRole() == null || user.getRole() != 1) {
            httpResponse.setContentType("text/html;charset=UTF-8");
            PrintWriter out = httpResponse.getWriter();
            out.println("<script>");
            out.println("alert('无权限访问，请联系管理员！');");
            out.println("history.back();");
            out.println("</script>");
            out.close();
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
