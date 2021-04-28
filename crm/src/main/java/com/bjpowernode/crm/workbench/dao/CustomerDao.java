package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {

    Customer selectCusByName(String company);

    int insertCus(Customer cus);

    List<String> selectCusName(String name);
}
