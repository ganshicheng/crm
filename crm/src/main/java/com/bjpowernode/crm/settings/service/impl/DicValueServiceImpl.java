package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.dao.DicValueDao;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicValueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class DicValueServiceImpl implements DicValueService {
    @Resource
    private DicValueDao dicValueDao;

    @Override
    public List<DicValue> selectDicValuesByCode(String code) {
        List<DicValue> dicValues = dicValueDao.selectDicValuesByCode(code);
        return dicValues;
    }
}
