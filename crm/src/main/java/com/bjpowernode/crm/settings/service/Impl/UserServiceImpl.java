package com.bjpowernode.crm.settings.service.Impl;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import org.apache.ibatis.logging.LogException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String, String> map = new HashMap<String, String>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);

        User user = userDao.login(map);

        if (user == null) {
            throw new LoginException("登录账号或密码错误");
        }
        //程序执行到此处说明账号等正常，继续向下做其他登录验证判断
        //验证失效时间
        String expireTime = user.getExpireTime();    //获取账号登录失效时间
        String currentTime = DateTimeUtil.getSysTime(); //获取系统当前时间
        if (expireTime.compareTo(currentTime) < 0) {
            throw new LoginException("账号已失效");
        }

        //判断锁定状态
        String lockState = user.getLockState();
        if ("0".equals(lockState)){
            throw new LoginException("账号已锁定，请联系管理员");
        }

        //执行到此处说明前面的验证都已通过，接下来验证ip
        String allowIps = user.getAllowIps();     //获取数据库中的ip信息
        if (!allowIps.contains(ip)) {
            throw new LogException("ip地址不正确，请联系管理员");
        }


        return user;
    }

    @Override
    public List<User> getUserList() {
        List<User> uList = userDao.getUserList();
        return uList;
    }
}
