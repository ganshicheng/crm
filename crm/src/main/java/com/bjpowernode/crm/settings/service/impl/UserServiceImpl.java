package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.util.DateTimeUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {

    @Resource
    private UserDao userDao;


    @Override
    public User queryUser(String loginAct, String loginPwd, String ip) throws LoginException {

        Map<String, String> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);


        User user =  userDao.selectUser(map);

        if (user == null) {
            throw new LoginException("账号密码错误");
        }

//        if (!user.getAllowIps().contains(ip)){
//            throw new LoginException("您的Ip地址不在允许范围内");
//        }

        if (user.getExpireTime().compareTo(DateTimeUtil.getSysTime()) < 0) {

            throw new LoginException("该用户已失效");
        }

        if ("0".equals(user.getLockState())){
            throw new LoginException("该用户已被锁定");
        }

        return user;
    }

    @Override
    public List<User> getUserList() {

        List<User> list = userDao.selectUsers();

        return list;
    }
}
