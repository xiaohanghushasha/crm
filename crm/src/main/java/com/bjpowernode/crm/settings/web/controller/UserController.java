package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.Impl.UserServiceImpl;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.MD5Util;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if("/settings/user/login.do".equals(path)){
            login(request,response);

        }else if ("".equals(path)){

        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        //将密码的明文转换为MD5密文形式
        loginPwd = MD5Util.getMD5(loginPwd);
        //System.out.println("登录账号"+loginAct+"\n"+"密码"+loginPwd);
        //获取浏览器ip地址
        String ip = request.getRemoteAddr();

        //未来业务层开发，统一使用代理类形态接口对象

        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        try{
            User user = us.login(loginAct,loginPwd,ip);
            request.getSession().setAttribute("user",user);

            PrintJson.printJsonFlag(response,true);

        }catch (Exception e){
            e.printStackTrace();
            String msg = e.getMessage();

            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);


        }

    }
}
