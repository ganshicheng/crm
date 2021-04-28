package com.bjpowernode.crm.handler;


import com.bjpowernode.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MyInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {


        User user = (User) request.getSession(false).getAttribute("user");
        if (user == null){
            response.sendRedirect("index.jsp");
            return false;
        }

        return true;
    }
}
