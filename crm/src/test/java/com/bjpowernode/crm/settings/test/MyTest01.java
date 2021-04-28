package com.bjpowernode.crm.settings.test;

import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import javafx.application.Application;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.defaults.DefaultSqlSessionFactory;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;


public class MyTest01 {


    @Test
    public void test01(){

        /*String expireTime = "2021-10-10 13:45:20";

        String sysTime = DateTimeUtil.getSysTime();
        int i = expireTime.compareTo(sysTime);
        System.out.println(i);*/

        String ip = "192.168.1.1";
        String allowip = "192.168.1.1,192.168.1.2";
        if (allowip.contains(ip)){
            System.out.println("有效IP");
        }

    }

    @Test
    public void test02() {

        String config = "conf/applicationContext.xml";
        ApplicationContext ac = new ClassPathXmlApplicationContext(config);
        ActivityDao arDao = (ActivityDao) ac.getBean("activityDao");

        String[] ids = {"796d262fe2e74c7b836a3862ccc2e478"};

        int res = arDao.deleteActivities(ids);
        System.out.println("===================" + res);
    }
}
