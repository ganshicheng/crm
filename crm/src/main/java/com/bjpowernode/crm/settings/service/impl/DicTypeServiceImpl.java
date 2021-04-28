package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.dao.DicTypeDao;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.service.DicTypeService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class DicTypeServiceImpl implements DicTypeService {
    @Resource
    private DicTypeDao dicTypeDao;

    @Override
    public List<DicType> selectDicTypes() {

        List<DicType> dicTypes = dicTypeDao.selectDicTypes();
        return dicTypes;
    }
}
