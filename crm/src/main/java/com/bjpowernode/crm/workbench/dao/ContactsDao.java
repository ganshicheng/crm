package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Contacts;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsDao {

    int insertCon(Contacts con);

    List<Contacts> selectListByName(@Param("fullname") String fullname);
}
