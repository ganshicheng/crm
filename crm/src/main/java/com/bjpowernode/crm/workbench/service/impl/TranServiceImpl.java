package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.dao.TranDao;
import com.bjpowernode.crm.workbench.dao.TranHistoryDao;
import com.bjpowernode.crm.workbench.dao.TranRemarkDao;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.domain.TranRemark;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {

    @Resource
    private TranDao tranDao;
    @Resource
    private TranHistoryDao tranHistoryDao;
    @Resource
    private CustomerDao customerDao;
    @Resource
    private TranRemarkDao tranRemarkDao;

    @Override
    @Transactional
    public Boolean save(Tran tran, String customerName) {

        Boolean flag = true;
        String createBy = tran.getCreateBy();
        String createTime = DateTimeUtil.getSysTime();

        //精确查询该客户名是否存在
        Customer cus = customerDao.selectCusByName(customerName);
        if (cus == null){
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(createBy);
            cus.setCreateTime(createTime);
            cus.setNextContactTime(tran.getNextContactTime());
            cus.setOwner(tran.getOwner());

            int res1 = customerDao.insertCus(cus);
            if (res1 != 1){
                flag = false;
            }
        }
        //设置tran的customerId
        tran.setCustomerId(cus.getId());

        //添加交易
        int res2 = tranDao.insertTran(tran);
        if (res2 != 1){
            flag = false;
        }

        //添加交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranId(tran.getId());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateBy(createBy);
        tranHistory.setCreateTime(createTime);
        int res3 = tranHistoryDao.insertTranHis(tranHistory);
        if (res3 != 1){
            flag = false;
        }
        return flag;

    }

    @Override
    public List<Tran> getPageList(Tran tran) {

        List<Tran> list = tranDao.getPageList(tran);
        return list;
    }

    @Override
    public Tran getTranById(String id) {

        Tran tran = tranDao.selectTranById(id);
        return tran;
    }

    @Override
    public List<TranRemark> getRemarkList(String tranId) {

        List<TranRemark> list = tranRemarkDao.getRemarkList(tranId);
        return list;
    }

    @Override
    public Boolean saveRemark(TranRemark tranRemark) {

        int res = tranRemarkDao.saveRemark(tranRemark);
        return res == 1;
    }

    @Override
    public Boolean removeRemark(String id) {

        int res = tranRemarkDao.delete(id);
        return res == 1;
    }

    @Override
    public Map<String, Object> updateRemark(TranRemark tranRemark) {
        Map<String, Object> map = new HashMap<>();

        int res = tranRemarkDao.updateRemark(tranRemark);
        TranRemark remark = tranRemarkDao.selectRemark(tranRemark.getId());
        map.put("success", res == 1);
        map.put("remark", remark);
        return map;
    }

    @Override
    public List<TranHistory> getHistoryList(String tranId) {

        List<TranHistory> list = tranHistoryDao.getList(tranId);
        return list;
    }

    @Override
    @Transactional
    public Boolean deleteTran(String id) {
        Boolean flag = true;
        //根据id删除交易关联的备注信息
        int count1 = tranRemarkDao.selectRemarkCount(id);
        int res1 = tranRemarkDao.deleteByTranId(id);
        if (count1 != res1){
            flag = false;
        }

        //根据id删除交易关联的交易历史信息
        int count2 = tranHistoryDao.seleteHistoryCount(id);
        int res2 = tranHistoryDao.deleteByTranId(id);
        if (count2 != res2){
            flag = false;
        }

        //删除交易信息
        int res3 = tranDao.deleteById(id);
        if (res3 != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    @Transactional
    public Boolean changeStage(Tran tran) {

        Boolean flag = true;

        //更新原来的tran信息
        int res1 = tranDao.changeStage(tran);
        if (res1 != 1){
            flag = false;
        }

        //生成一个交易历史tranHistory
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setStage(tran.getStage());
        th.setCreateBy(tran.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setTranId(tran.getId());
        th.setMoney(tran.getMoney());
        th.setExpectedDate(tran.getExpectedDate());
        int res2 = tranHistoryDao.insertTranHis(th);
        if (res2 != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public int getTotal() {

        int total = tranDao.getTotal();
        return total;
    }

    @Override
    public List<Map<String, Object>> getCharts() {

        List<Map<String, Object>> dataList = tranDao.getCharts();
        return dataList;
    }

    @Override
    public List<String> getKeyList() {

        List<String> keyList = tranDao.getKeyList();
        return keyList;
    }
}
