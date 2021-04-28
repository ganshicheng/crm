package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueService;
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
@RequestMapping("/workbench/clue")
public class ClueController {
    @Resource
    private ClueService clueService;
    @Resource
    private UserService userService;
    @Resource
    private ActivityService activityService;

    /**
     * 查找用户列表
     * @return
     */
    @RequestMapping("/getUserList.do")
    @ResponseBody
    public List<User> getUserList() {

        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping("/saveClue.do")
    @ResponseBody
    public Boolean saveClue(Clue clue, HttpServletRequest request){

        clue.setId(UUIDUtil.getUUID());
        User user = (User) request.getSession().getAttribute("user");
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateTimeUtil.getSysTime());

        Boolean flag = clueService.saveClue(clue);
        return flag;
    }

    @RequestMapping(value = "/pageList.do")
    @ResponseBody
    public PageInfo<Clue> getPageList(Integer pageNum, Integer pageSize, Clue clue){

        PageHelper.startPage(pageNum, pageSize);
        List<Clue> list = clueService.getPageList(clue);
        PageInfo<Clue> info = new PageInfo<>(list);

        return info;
    }

    @RequestMapping("/getClueInfo.do")
    @ResponseBody
    public Clue getClueInfo(String id){
        Clue clue = clueService.getClueInfo(id);
        return clue;
    }

    @RequestMapping("/updateClue.do")
    @ResponseBody
    public Boolean updateClue(Clue clue, HttpServletRequest request){

        User user = (User) request.getSession().getAttribute("user");
        clue.setEditBy(user.getId());
        clue.setEditTime(DateTimeUtil.getSysTime());

        Boolean flag = clueService.updateClue(clue);
        return flag;

    }

    @RequestMapping("/removeClue.do")
    @ResponseBody
    public Boolean removeClue(HttpServletRequest request) {
        String[] ids = request.getParameterValues("id");
        Boolean flag = clueService.removeClue(ids);
        return flag;
    }

    @RequestMapping("/detail.do")
    public ModelAndView detail(String id){

        Clue clue = clueService.getClueDetail(id);
        ModelAndView mv = new ModelAndView();
        mv.addObject("clue", clue);
        mv.setViewName("/workbench/clue/detail.jsp");
        return mv;
    }

    @RequestMapping("/getClueRemark.do")
    @ResponseBody
    public List<ClueRemark> getClueRemark(String clueId){

        List<ClueRemark> list = clueService.getClueRemark(clueId);
        return list;
    }

    @RequestMapping("/saveClueRemark.do")
    @ResponseBody
    public Map<String, Object> saveClueRemark(ClueRemark clueRemark, HttpServletRequest request){

        User user = (User) request.getSession().getAttribute("user");

        clueRemark.setId(UUIDUtil.getUUID());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateTimeUtil.getSysTime());
        clueRemark.setEditFlag("0");

        Boolean flag = clueService.saveClueRemark(clueRemark);
        ClueRemark remark = clueService.getClueRemarkById(clueRemark.getId());
        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        map.put("remark", remark);
        return map;
    }

    @RequestMapping("/removeRemark.do")
    @ResponseBody
    public Boolean removeRemark(String id){

        Boolean flag = clueService.removeRemark(id);
        return flag;
    }

    @RequestMapping("/getClueActivity.do")
    @ResponseBody
    public List<Activity> getClueActivity(String clueId){

        List<Activity> list = clueService.getClueActivity(clueId);
        return list;
    }

    @RequestMapping("/removeRelation.do")
    @ResponseBody
    public Boolean removeRelation(String id){

        Boolean flag = clueService.removeRelation(id);
        return flag;
    }

    @RequestMapping("/getActivityList.do")
    @ResponseBody
    public List<Activity> getActivityList(String name, String clueId){

        List<Activity> list = activityService.getActivityList(name, clueId);
        return list;
    }

    @RequestMapping("/saveClueActivity.do")
    @ResponseBody
    public Boolean saveClueActivity(String clueId, HttpServletRequest request){


        String[] activityIds = request.getParameterValues("activityId");

        Boolean flag  = clueService.saveClueActivity(activityIds, clueId);
        return flag;
    }

    @RequestMapping("/deleteClue.do")
    @ResponseBody
    public Boolean deleteClueById(String id){
        Boolean flag = clueService.deleteClueById(id);
        return flag;
    }

    @RequestMapping("/getActivityListByName.do")
    @ResponseBody
    public List<Activity> getActivityListByName(String name){
        List<Activity> list = activityService.selectActivityByName(name);
        return list;
    }

    @RequestMapping("/convert.do")
    public String convert(Tran tran, HttpServletRequest request){

        String clueId = request.getParameter("clueId");
        String flag = request.getParameter("flag");
        User user = (User) request.getSession().getAttribute("user");
        String createBy = user.getId();

        //需要创建交易
        if ("a".equals(flag)){
            //接收交易表单数据
            tran.setId(UUIDUtil.getUUID());
            tran.setCreateBy(createBy);
            tran.setCreateTime(DateTimeUtil.getSysTime());
        }
        Boolean flag1 = clueService.convert(clueId, tran, createBy);
        request.setAttribute("success", flag1);

        return "/workbench/clue/index.jsp";
    }
}
