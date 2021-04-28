package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkDao {
    List<TranRemark> getRemarkList(String tranId);

    int saveRemark(TranRemark tranRemark);

    int delete(String id);

    int updateRemark(TranRemark tranRemark);

    TranRemark selectRemark(String id);

    int selectRemarkCount(String tranId);

    int deleteByTranId(String tranId);
}
