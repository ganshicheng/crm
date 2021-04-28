package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;

public interface ClueDao {


    int insertClue(Clue clue);

    List<Clue> selectClueByCondition(Clue clue);

    Clue selectClueById(String id);

    int updateClue(Clue clue);

    int deleteClue(String[] ids);

    Clue selectDetailById(String id);

    int deleteClueById(String id);
}
