package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.vo.ActivityUserVo;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private ActivityDao activityDao;
    @Resource
    private ActivityRemarkDao activityRemarkDao;


    @Override
    public Boolean saveActivity(Activity activity) {

        int res = activityDao.insertActivity(activity);

        return res == 1;
    }

    @Override
    public List<Activity> getActivityListByCondition(Activity activity) {

        List<Activity> list = activityDao.selectActivitiesByCondition(activity);

        return list;
    }

    @Override
    @Transactional
    public Boolean deleteActivities(String[] ids) {

        Boolean flag = true;
        int count1 = activityRemarkDao.selectById(ids);
        int count2 = activityRemarkDao.deleteARById(ids);

        if ( count1 != count2){
            flag = false;
        }

        int res = activityDao.deleteActivities(ids);
        if (res != ids.length) {
            flag = false;
        }

        return flag;
    }

    @Override
    public ActivityUserVo selectActivityById(String id) {

        ActivityUserVo activityUserVo = activityDao.selectActivityById(id);


        return activityUserVo;
    }

    @Override
    public Boolean updateActivity(Activity activity) {

        int res = activityDao.updateActivity(activity);

        return res == 1;
    }

    @Override
    public ActivityUserVo searchActivityInfo(String id) {

        ActivityUserVo vo = new ActivityUserVo();
        vo = activityDao.selectActivityById(id);

        return vo;
    }

    @Override
    public ActivityUserVo detail(String id) {

        ActivityUserVo vo = activityDao.selectActivityById(id);
        return vo;
    }

    @Override
    public List<ActivityRemark> getRemarkListByAid(String activityId) {

        List<ActivityRemark> list = activityRemarkDao.getRemarkListById(activityId);
        return list;
    }

    @Override
    public Boolean deleteRemark(String id) {

        int res = activityRemarkDao.deleteRemark(id);
        return res == 1;
    }

    @Override
    public Boolean saveRemark(ActivityRemark activityRemark) {

        int res = activityRemarkDao.insertRemark(activityRemark);
        return res == 1;
    }

    @Override
    public ActivityRemark selectRemarkById(String id) {

        ActivityRemark remark = activityRemarkDao.selectRemarkById(id);
        return remark;
    }

    @Override
    public Boolean updateRemark(ActivityRemark remark) {

        int res = activityRemarkDao.updateRemark(remark);
        return res == 1;
    }

    @Override
    public List<Activity> getActivityList(String name, String clueId) {

        List<Activity> list = activityDao.selectActivityList(name, clueId);
        return list;
    }

    @Override
    public List<Activity> selectActivityByName(String name) {

        List<Activity> list = activityDao.selectActivityByName(name);
        return list;
    }
}
