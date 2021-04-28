package com.bjpowernode.crm.handler;

import com.bjpowernode.crm.exception.LoginException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class LoginExceptionHandler {
    @ExceptionHandler(value = LoginException.class)
    @ResponseBody
    public Map<String, String> doLoginException(Exception ex){
        System.out.println("处理登录异常。。。");
        Map<String, String> map = new HashMap<>();
        map.put("success", "false");
        map.put("msg", ex.getMessage());
        return map;
    }
}
