package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.vo.ActivityUserVo;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {
    @Resource
    private ActivityService activityService;
    @Resource
    private UserService userService;

    @RequestMapping("/getUserList.do")
    @ResponseBody
    public List<User> getUserList() {


        List<User> list = userService.getUserList();

        return list;
    }

    @RequestMapping(value = "/saveActivity.do")
    @ResponseBody
    public Boolean saveActivity(Activity activity, HttpServletRequest request) {

        String id = UUIDUtil.getUUID();
        String sysTime = DateTimeUtil.getSysTime();
        User user = (User) request.getSession().getAttribute("user");
        String createBy = user.getId();
        activity.setId(id);
        activity.setCreateTime(sysTime);
        activity.setCreateBy(createBy);

        Boolean flag = activityService.saveActivity(activity);
        return flag;
    }

    @RequestMapping("/pageList.do")
    @ResponseBody
    public PageInfo pageList(Integer pageNum, Integer pageSize, Activity activity) {

        PageHelper.startPage(pageNum, pageSize);
        List<Activity> list = activityService.getActivityListByCondition(activity);

        PageInfo pageInfo = new PageInfo(list);

        return pageInfo;
    }

    @RequestMapping("/deleteActivity.do")
    @ResponseBody
    public Map<String, Boolean> deleteActivity(HttpServletRequest request){

        String[] ids = request.getParameterValues("activityId");

        Boolean flag = activityService.deleteActivities( ids);

        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }

    @RequestMapping("/searchActivity.do")
    @ResponseBody
    public ActivityUserVo searchActivity(String id) {

        ActivityUserVo activityUserVo = activityService.selectActivityById(id);
        List<User> userList = userService.getUserList();
        activityUserVo.setList(userList);

        return activityUserVo;

    }

    @RequestMapping("/updateActivity.do")
    @ResponseBody
    public Map<String, Boolean> updateActivity(Activity activity, HttpServletRequest request){

        User user = (User) request.getSession().getAttribute("user");
        activity.setEditBy(user.getId());
        String sysTime = DateTimeUtil.getSysTime();
        activity.setEditTime(sysTime);

        Boolean flag = activityService.updateActivity(activity);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", flag);
        return map;

    }

    @RequestMapping("/detail.do")
    public ModelAndView detail(String id){

        ActivityUserVo vo = activityService.detail(id);
        ModelAndView mv = new ModelAndView();
        mv.addObject("vo", vo);
        mv.setViewName("forward:/workbench/activity/detail.jsp");
        return mv;

    }

    @RequestMapping("/updateDetail.do")
    @ResponseBody
    public Boolean updateDetail(Activity activity, HttpServletRequest request){

        User user = (User) request.getSession().getAttribute("user");
        activity.setEditBy(user.getId());
        activity.setEditTime(DateTimeUtil.getSysTime());

        Boolean flag = activityService.updateActivity(activity);
        return flag;
    }

    @RequestMapping("/getRemarkListByAid.do")
    @ResponseBody
    public List<ActivityRemark> getRemarkListByAid(String activityId) {

        List<ActivityRemark> list = activityService.getRemarkListByAid(activityId);
        return list;
    }

    @RequestMapping("/removeRemark.do")
    @ResponseBody
    public Boolean removeRemark(String id) {

        Boolean flag = activityService.deleteRemark(id);
        return flag;
    }

    @RequestMapping("/saveRemark.do")
    @ResponseBody
    public Map<String, Object> saveRemark(ActivityRemark activityRemark, HttpServletRequest request){

        User user = (User) request.getSession().getAttribute("user");
        activityRemark.setCreateBy(user.getId());
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        activityRemark.setEditFlag("0");


        Boolean flag = activityService.saveRemark(activityRemark);
        ActivityRemark remark = activityService.selectRemarkById(activityRemark.getId());
        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        map.put("remark", remark);
        return map;
    }

    @RequestMapping("/updateRemark.do")
    @ResponseBody
    public Map<String, Object> updateRemark(ActivityRemark remark, HttpServletRequest request){

        User user = (User) request.getSession().getAttribute("user");
        remark.setEditBy(user.getId());
        remark.setEditTime(DateTimeUtil.getSysTime());
        remark.setEditFlag("1");

        Boolean flag = activityService.updateRemark(remark);

        remark = activityService.selectRemarkById(remark.getId());
        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        map.put("remark", remark);
        return map;
    }

}
