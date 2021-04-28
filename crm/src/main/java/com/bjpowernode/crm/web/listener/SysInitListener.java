package com.bjpowernode.crm.web.listener;

import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicTypeService;
import com.bjpowernode.crm.settings.service.DicValueService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {



    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {

        String config = "conf/applicationContext.xml";
        ApplicationContext ac = new ClassPathXmlApplicationContext(config);
        DicTypeService dtService = ac.getBean(DicTypeService.class);
        DicValueService dvService = ac.getBean(DicValueService.class);
        ServletContext application = servletContextEvent.getServletContext();


        //处理数据字典
        List<DicType> dicTypes = dtService.selectDicTypes();

        for (DicType dicType : dicTypes) {
            List<DicValue> dicValues = dvService.selectDicValuesByCode(dicType.getCode());
            application.setAttribute(dicType.getCode() + "List", dicValues);
        }

        //处理Stage2Possibility.properties文件
        ResourceBundle bundle = ResourceBundle.getBundle("conf/Stage2Possibility");
        Enumeration<String> e = bundle.getKeys();
        Map<String, String> map = new HashMap<>();
        while (e.hasMoreElements()){
            String key = e.nextElement();
            String value = bundle.getString(key);
            map.put(key, value);
        }
        application.setAttribute("pMap", map);


    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
