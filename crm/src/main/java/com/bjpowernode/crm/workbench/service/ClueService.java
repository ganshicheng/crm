package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;

public interface ClueService {
    Boolean saveClue(Clue clue);

    List<Clue> getPageList(Clue clue);

    Clue getClueInfo(String id);

    Boolean updateClue(Clue clue);

    Boolean removeClue(String[] ids);

    Clue getClueDetail(String id);

    List<ClueRemark> getClueRemark(String clueId);

    Boolean saveClueRemark(ClueRemark clueRemark);

    ClueRemark getClueRemarkById(String id);

    Boolean removeRemark(String id);

    List<Activity> getClueActivity(String clueId);

    Boolean removeRelation(String id);

    Boolean saveClueActivity(String[] activityIds, String clueId);

    Boolean deleteClueById(String id);

    Boolean convert(String clueId, Tran tran, String createBy);
}
