package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ClueActivityRelationDao {


    List<Activity> selectActivityByClueId(String clueId);

    int deleteRelation(String id);

    int insertRelations(List<ClueActivityRelation> list);

    int selectBundById(String id);

    int deleteBund(String id);

    int selectBundByIds(String[] ids);

    int deleteBundByIds(String[] ids);

    List<ClueActivityRelation> getListByClueId(String clueId);
}
