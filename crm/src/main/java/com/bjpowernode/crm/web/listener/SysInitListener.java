package com.bjpowernode.crm.web.listener;

import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicService;
import com.bjpowernode.crm.settings.service.Impl.DicServiceImpl;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;
import java.util.Map;
import java.util.Set;

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

    }
}
