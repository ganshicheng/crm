package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service
public class ClueServiceImpl implements ClueService {
    @Resource
    private ClueDao clueDao;
    @Resource
    private ClueRemarkDao clueRemarkDao;
    @Resource
    private ClueActivityRelationDao clueActivityRelationDao;

    @Resource
    private CustomerDao customerDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;

    @Resource
    private ContactsDao contactsDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    @Resource
    private ContactsActivityRelationDao contactsActivityRelationDao;

    @Resource
    private TranDao tranDao;
    @Resource
    private TranHistoryDao tranHistoryDao;


    @Override
    public Boolean saveClue(Clue clue) {

        int res = clueDao.insertClue(clue);
        return res == 1;
    }

    @Override
    public List<Clue> getPageList(Clue clue) {

        List<Clue> list = clueDao.selectClueByCondition(clue);
        return list;
    }

    @Override
    public Clue getClueInfo(String id) {

        Clue clue = clueDao.selectClueById(id);
        return clue;
    }

    @Override
    public Boolean updateClue(Clue clue) {

        int res = clueDao.updateClue(clue);
        return res == 1;
    }

    @Override
    @Transactional
    public Boolean removeClue(String[] ids) {

        int bundCount = clueActivityRelationDao.selectBundByIds(ids);
        int bundRes = clueActivityRelationDao.deleteBundByIds(ids);

        int remarkCount = clueRemarkDao.selectRemarkCountByIds(ids);
        int remarkRes = clueRemarkDao.deleteRemarkByIds(ids);

        if (bundCount == bundRes && remarkCount == remarkRes){
            int res = clueDao.deleteClue(ids);
            return res == ids.length;
        }
        return false;
    }

    @Override
    public Clue getClueDetail(String id) {

        Clue clue = clueDao.selectDetailById(id);
        return clue;
    }

    @Override
    public List<ClueRemark> getClueRemark(String clueId) {

        List<ClueRemark> list = clueRemarkDao.selectRemarkByClueId(clueId);
        return list;
    }

    @Override
    public Boolean saveClueRemark(ClueRemark clueRemark) {

        int res = clueRemarkDao.insertClueRemark(clueRemark);
        return res == 1;
    }

    @Override
    public ClueRemark getClueRemarkById(String id) {

        ClueRemark remark = clueRemarkDao.selectRemarkById(id);
        return remark;
    }

    @Override
    public Boolean removeRemark(String id) {

        int res = clueRemarkDao.deleteRemark(id);
        return res == 1;
    }

    @Override
    public List<Activity> getClueActivity(String clueId) {

        List<Activity> list = clueActivityRelationDao.selectActivityByClueId(clueId);
        return list;
    }

    @Override
    public Boolean removeRelation(String id) {

        int res = clueActivityRelationDao.deleteRelation(id);
        return res == 1;
    }

    @Override
    public Boolean saveClueActivity(String[] activityIds, String clueId) {

        List<ClueActivityRelation> list = new ArrayList<>();
        ClueActivityRelation car = null;
        for (String activityId : activityIds){

            car = new ClueActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setActivityId(activityId);
            car.setClueId(clueId);
            list.add(car);
        }

        int res = clueActivityRelationDao.insertRelations(list);
        return res == activityIds.length;
    }

    @Override
    @Transactional
    public Boolean deleteClueById(String id) {


        int bundCount = clueActivityRelationDao.selectBundById(id);
        int bundRes = clueActivityRelationDao.deleteBund(id);

        int remarkCount = clueRemarkDao.selectRemarkCount(id);
        int remarkRes = clueRemarkDao.deleteRemarkByClueId(id);

        if (bundCount == bundRes && remarkCount == remarkRes){
            int num = clueDao.deleteClueById(id);
            return num == 1;
        }
        return false;
    }

    @Override
    public Boolean convert(String clueId, Tran tran, String createBy) {

        //根据clueId得到clue对象
        Clue clue = clueDao.selectClueById(clueId);
        String company = clue.getCompany();
        String createTime = DateTimeUtil.getSysTime();
        Boolean flag = true;
        //根据公司名精准查找是否已存在该客户
        Customer cus = customerDao.selectCusByName(company);
        if (cus == null){
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setOwner(clue.getOwner());
            cus.setName(company);
            cus.setWebsite(clue.getWebsite());
            cus.setPhone(clue.getPhone());
            cus.setCreateBy(createBy);
            cus.setCreateTime(createTime);
            cus.setContactSummary(clue.getContactSummary());
            cus.setNextContactTime(clue.getNextContactTime());
            cus.setDescription(clue.getDescription());
            cus.setAddress(clue.getAddress());
        }
        //插入一条客户记录
        int res1 = customerDao.insertCus(cus);
        if ( res1 != 1){
            flag = false;
        }
        //根据线索提取联系人信息
        Contacts con = new Contacts();
        con.setId(UUIDUtil.getUUID());
        con.setOwner(clue.getOwner());
        con.setSource(clue.getSource());
        con.setCustomerId(cus.getId());
        con.setFullname(clue.getFullname());
        con.setAppellation(clue.getAppellation());
        con.setEmail(clue.getEmail());
        con.setMphone(clue.getMphone());
        con.setJob(clue.getJob());
        con.setCreateBy(createBy);
        con.setCreateTime(createTime);
        con.setDescription(clue.getDescription());
        con.setContactSummary(clue.getContactSummary());
        con.setNextContactTime(clue.getNextContactTime());
        con.setAddress(clue.getAddress());

        //插入联系人信息
        int res2 = contactsDao.insertCon(con);
        if (res2 != 1){
            flag = false;
        }
        //根据clueId查询关联的备注信息列表
        List<ClueRemark> clueRemarkList = clueRemarkDao.getListByClueId(clueId);
        CustomerRemark customerRemark = null;
        ContactsRemark contactsRemark = null;
        int res3 = 0;
        int res4 = 0;

        for (ClueRemark clueRemark : clueRemarkList){
            //取出备注信息转换为客户备注信息
            customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(createTime);
            customerRemark.setEditFlag("0");
            customerRemark.setCustomerId(cus.getId());
            res3 = customerRemarkDao.insertRemark(customerRemark);
            if (res3 != 1){
                flag = false;
            }

            //取出备注信息转换为联系人备注信息
            contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setEditFlag("0");
            contactsRemark.setContactsId(con.getId());
            res4 = contactsRemarkDao.insertRemark(contactsRemark);
            if (res4 != 1){
                flag = false;
            }
        }

        //根据clueId找出线索与市场关联的信息列表
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getListByClueId(clueId);
        int res5 = 0;
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList){

            //将线索与市场的关联关系转换为联系人与市场的关联关系
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setContactsId(con.getId());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            res5 = contactsActivityRelationDao.insertRelation(contactsActivityRelation);
            if (res5 != 1){
                flag = false;
            }

        }

        if (tran.getId() != null || "".equals(tran.getId())){

            //创建交易
            tran.setOwner(clue.getOwner());
            tran.setCustomerId(cus.getId());
            tran.setContactsId(con.getId());
            tran.setDescription(clue.getDescription());
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setContactSummary(clue.getContactSummary());
            int res6 = tranDao.insertTran(tran);
            if (res6 != 1){
                flag = false;
            }

            //创建交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setStage(tran.getStage());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(createTime);
            tranHistory.setTranId(tran.getId());
            int res7 = tranHistoryDao.insertTranHis(tranHistory);
            if (res7 != 1){
                flag = false;
            }
        }

        //删除线索备注记录
        for (ClueRemark clueRemark : clueRemarkList){
            int res8 = clueRemarkDao.deleteRemark(clueRemark.getId());
            if (res8 != 1){
                flag = false;
            }
        }
        //删除线索与市场的关联关系
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList){
            int res9 = clueActivityRelationDao.deleteRelation(clueActivityRelation.getId());
            if (res9 != 1){
                flag = false;
            }
        }

        //删除线索记录
        int res10 = clueDao.deleteClueById(clueId);
        if (res10 != 1){
            flag = false;
        }




        return flag;
    }
}
