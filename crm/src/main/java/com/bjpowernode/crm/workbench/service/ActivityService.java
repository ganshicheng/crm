package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.ActivityUserVo;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityService {


    Boolean saveActivity(Activity activity);

    List<Activity> getActivityListByCondition(Activity activity);

    Boolean deleteActivities(String[] ids);

    ActivityUserVo selectActivityById(String id);

    Boolean updateActivity(Activity activity);

    ActivityUserVo searchActivityInfo(String id);

    ActivityUserVo detail(String id);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    Boolean deleteRemark(String id);

    Boolean saveRemark(ActivityRemark activityRemark);

    ActivityRemark selectRemarkById(String id);

    Boolean updateRemark(ActivityRemark remark);

    List<Activity> getActivityList(String name, String clueId);

    List<Activity> selectActivityByName(String name);
}
