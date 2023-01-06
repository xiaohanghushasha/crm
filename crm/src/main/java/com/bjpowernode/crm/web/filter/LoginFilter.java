package com.bjpowernode.crm.web.filter;

import com.bjpowernode.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 过滤器
 * 对登录操作，判断是否登录过进行拦截
 */

public class LoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {
        //向下转型
        HttpServletRequest httpRequest = (HttpServletRequest) servletRequest;
        HttpServletResponse httpResponse = (HttpServletResponse) servletResponse;

        //如果是这两种请求直接放行
        String path = httpRequest.getServletPath();
        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){
            filterChain.doFilter(servletRequest,servletResponse);
        }
        //其他请求进行过滤拦截
        else {
            HttpSession session = httpRequest.getSession();
            User user = (User) session.getAttribute("user");
            //如果user不等于null说明登录过
            if (user != null) {
                filterChain.doFilter(servletRequest, servletResponse);
            }
            //没有登陆过
            else {
                //重定向到登录页
                String path1 = httpRequest.getContextPath();
                httpResponse.sendRedirect(path1 + "/login.jsp");
            }
        }
    }

    @Override
    public void destroy() {

    }
}
