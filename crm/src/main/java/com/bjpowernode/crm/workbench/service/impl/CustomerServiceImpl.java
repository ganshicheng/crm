package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class CustomerServiceImpl implements CustomerService {
    @Resource
    private CustomerDao customerDao;

    @Override
    public List<String> getListByName(String name) {

        List<String> list = customerDao.selectCusName(name);
        return list;
    }
}