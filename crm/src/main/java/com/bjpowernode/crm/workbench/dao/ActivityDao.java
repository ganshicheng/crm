package com.bjpowernode.crm.workbench.dao;


import com.bjpowernode.crm.vo.ActivityUserVo;
import com.bjpowernode.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ActivityDao {
    int insertActivity(Activity activity);

    List<Activity> selectActivitiesByCondition(Activity activity);

    int deleteActivities(String[] ids);

    ActivityUserVo selectActivityById(String id);

    int updateActivity(Activity activity);

    List<Activity> selectActivityList(@Param("name") String name, @Param("clueId") String clueId);

    List<Activity> selectActivityByName(@Param("name") String name);
}
