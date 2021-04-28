package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    int selectById(String[] ids);

    int deleteARById(String[] ids);

    List<ActivityRemark> getRemarkListById(String activityId);

    int deleteRemark(String id);

    int insertRemark(ActivityRemark activityRemark);

    ActivityRemark selectRemarkById(String id);

    int updateRemark(ActivityRemark remark);
}
