package com.bjpowernode.crm.web.listener;

import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicService;
import com.bjpowernode.crm.settings.service.Impl.DicServiceImpl;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent event) {

        //System.out.println("上下文域对象创建了");
        System.out.println("服务器缓存数据字典开始");

        ServletContext application = event.getServletContext();
        DicService ds = (DicService) ServiceFactory.getService(new DicServiceImpl());
        /*
        向业务层获取到7个数据字典List
        可以放到一个Map中
         */
        Map<String, List<DicValue>> map = ds.getAll();
        //将Map解析为上下文域对象中保存的键值对
        Set<String> set = map.keySet();
        for (String key:set) {
            application.setAttribute(key,map.get(key));

        }
        System.out.println("服务器缓存数据字典结束");


        //---------------------------------------------------
        //处理stage2Possibility.properties文件
        //    解析该文件，将文件中的键值对关系解析为java中的键值对（map）

        //解析properties文件
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> keys = rb.getKeys();
        Map<String,String> pMap = new HashMap<String, String>();
        while (keys.hasMoreElements()){
            //阶段
            String key = keys.nextElement();
            //可能性
            String value = rb.getString(key);

            pMap.put(key,value);

        }

        //将pMap保存至服务器缓存中
        application.setAttribute("pMap",pMap);

    }
}
