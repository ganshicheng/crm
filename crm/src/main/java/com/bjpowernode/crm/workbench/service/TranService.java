package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;
import java.util.Map;

public interface TranService {
    Boolean save(Tran tran, String customerName);

    List<Tran> getPageList(Tran tran);

    Tran getTranById(String id);

    List<TranRemark> getRemarkList(String tranId);

    Boolean saveRemark(TranRemark tranRemark);

    Boolean removeRemark(String id);

    Map<String, Object> updateRemark(TranRemark tranRemark);

    List<TranHistory> getHistoryList(String tranId);

    Boolean deleteTran(String id);

    Boolean changeStage(Tran tran);

    int getTotal();

    List<Map<String, Object>> getCharts();

    List<String> getKeyList();
}
