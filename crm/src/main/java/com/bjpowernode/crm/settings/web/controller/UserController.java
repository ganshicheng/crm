package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.util.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/settings/user")
public class UserController {

    @Resource
    private UserService userService;

    @RequestMapping("/login.do")
    @ResponseBody
    public Map<String, String> login(String loginAct, String loginPwd, HttpServletRequest request, HttpServletResponse response) throws LoginException {

        String ip = request.getRemoteAddr();
        loginPwd = MD5Util.getMD5(loginPwd);

        User user = userService.queryUser(loginAct, loginPwd, ip);

        request.getSession().setAttribute("user", user);

        Map<String, String> map = new HashMap<>();
        map.put("success", "true");
        map.put("msg", "");
        return map;

    }

}
