package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ContactsService;
import com.bjpowernode.crm.workbench.service.CustomerService;
import com.bjpowernode.crm.workbench.service.TranService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@RequestMapping("/workbench/transaction")
public class TranController {
    @Resource
    private UserService userService;
    @Resource
    private TranService tranService;
    @Resource
    private ActivityService activityService;
    @Resource
    private ContactsService contactsService;
    @Resource
    private CustomerService customerService;


    @RequestMapping("/getUserList.do")
    @ResponseBody
    public List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping("/getActivityList.do")
    @ResponseBody
    public List<Activity> getActivityList(String name) {

        List<Activity> list = activityService.selectActivityByName(name);
        return list;
    }

    @RequestMapping("/getContactsList.do")
    @ResponseBody
    public List<Contacts> getContactsList(String fullname){

        List<Contacts> list = contactsService.getContactsListByName(fullname);
        return list;
    }

    @RequestMapping("/getCustomerName.do")
    @ResponseBody
    public List<String> getCustomerName(String name){

        List<String> list = customerService.getListByName(name);
        return list;
    }

    @RequestMapping("/save.do")
    public ModelAndView save(Tran tran, String customerName, HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateBy(user.getId());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        Boolean flag = tranService.save(tran, customerName);
        if (flag){
            return new ModelAndView("redirect:/workbench/transaction/index.jsp");
        }
        return null;
    }

    @RequestMapping("/getPageList.do")
    @ResponseBody
    public PageInfo<Tran> getPageList(Tran tran, Integer pageNum, Integer pageSize){

        PageHelper.startPage(pageNum, pageSize);
        List<Tran> list = tranService.getPageList(tran);
        PageInfo<Tran> pageInfo = new PageInfo<>(list);
        return pageInfo;
    }

    @RequestMapping("/detail.do")
    public ModelAndView detail(String id, HttpServletRequest request){

        Tran tran = tranService.getTranById(id);
        ServletContext application = request.getServletContext();
        Map<String, String> pMap = (Map<String, String>) application.getAttribute("pMap");
        String possibility = pMap.get(tran.getStage());
        tran.setPossibility(possibility);


        ModelAndView mv = new ModelAndView();
        mv.addObject("tran", tran);
        mv.setViewName("/workbench/transaction/detail.jsp");
        return mv;
    }

    @RequestMapping("/getRemarkList.do")
    @ResponseBody
    public List<TranRemark> getRemarkList(String tranId){
        List<TranRemark> list = tranService.getRemarkList(tranId);
        return list;
    }

    @RequestMapping("/saveRemark.do")
    @ResponseBody
    public Boolean saveRemark(TranRemark tranRemark, HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");

        tranRemark.setId(UUIDUtil.getUUID());
        tranRemark.setCreateBy(user.getId());
        tranRemark.setCreateTime(DateTimeUtil.getSysTime());
        tranRemark.setEditFlag("0");
        Boolean flag = tranService.saveRemark(tranRemark);
        return flag;
    }

    @RequestMapping("/removeRemark.do")
    @ResponseBody
    public Boolean removeRemark(String id){
        Boolean flag = tranService.removeRemark(id);
        return flag;
    }

    @RequestMapping("/updateRemark.do")
    @ResponseBody
    public Map<String, Object> updateRemark(TranRemark tranRemark, HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        tranRemark.setEditFlag("1");
        tranRemark.setEditBy(user.getId());
        tranRemark.setEditTime(DateTimeUtil.getSysTime());
        Map<String, Object> map = tranService.updateRemark(tranRemark);
        return map;
    }

    @RequestMapping("/getHistoryList.do")
    @ResponseBody
    public List<TranHistory> getHistoryList(String tranId, HttpServletRequest request){
        List<TranHistory> list = tranService.getHistoryList(tranId);
        Map<String, String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");

        for (TranHistory th : list){
            String possibility  = pMap.get(th.getStage());
            th.setPossibility(possibility);
        }

        return list;
    }

    @RequestMapping("/deleteTran.do")
    public ModelAndView deleteTran(String id){

        Boolean flag = tranService.deleteTran(id);

        if (flag){

            return new ModelAndView("redirect:/workbench/transaction/index.jsp");
        }
        return null;
    }

    @RequestMapping("/changeStage.do")
    @ResponseBody
    public Map<String, Object> changeStage(Tran tran, HttpServletRequest request){

        User user = (User) request.getSession().getAttribute("user");
        tran.setEditBy(user.getId());
        tran.setEditTime(DateTimeUtil.getSysTime());

        Boolean flag = tranService.changeStage(tran);

        Tran t = tranService.getTranById(tran.getId());

        Map<String, String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(tran.getStage());
        t.setPossibility(possibility);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        map.put("t", t);
        return map;
    }

    @RequestMapping("/getCharts.do")
    @ResponseBody
    public Map<String, Object> getCharts() {

        int total = tranService.getTotal();
        List<Map<String, Object>> dataList = tranService.getCharts();
        List<String> keyList = tranService.getKeyList();


        Map<String, Object> map = new HashMap<>();
        map.put("keyList", keyList);
        map.put("total", total);
        map.put("dataList", dataList);
        return map;
    }
}
