package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> selectRemarkByClueId(String clueId);

    int insertClueRemark(ClueRemark clueRemark);

    ClueRemark selectRemarkById(String id);

    int deleteRemark(String id);

    int selectRemarkCount(String id);

    int deleteRemarkByClueId(String id);

    int selectRemarkCountByIds(String[] ids);

    int deleteRemarkByIds(String[] ids);

    List<ClueRemark> getListByClueId(String clueId);
}
