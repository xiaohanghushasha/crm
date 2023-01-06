package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {

    int save(Activity act);

    int getTotal(Map<String, Object> map);

    List<Activity> getDataList(Map<String, Object> map);

    Activity getActivity(String id);

    int update(Activity act);

    int delete(String[] ids);

    Activity detail(String id);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map);
}
