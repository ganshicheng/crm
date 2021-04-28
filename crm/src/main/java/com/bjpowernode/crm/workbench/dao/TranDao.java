package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int insertTran(Tran tran);

    List<Tran> getPageList(Tran tran);

    Tran selectTranById(String id);

    int deleteById(String id);

    int changeStage(Tran tran);

    int getTotal();

    List<Map<String, Object>> getCharts();

    List<String> getKeyList();
}
