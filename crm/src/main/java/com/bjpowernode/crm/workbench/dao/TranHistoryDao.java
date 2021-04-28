package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int insertTranHis(TranHistory tranHistory);

    List<TranHistory> getList(String tranId);

    int seleteHistoryCount(String tranId);

    int deleteByTranId(String tranId);
}
