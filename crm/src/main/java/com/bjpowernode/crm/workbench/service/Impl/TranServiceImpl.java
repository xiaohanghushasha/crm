package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.dao.TranDao;
import com.bjpowernode.crm.workbench.dao.TranHistoryDao;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranServiceImpl implements TranService {
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);


    @Override
    public boolean save(Tran t, String customerName) {

        /*
        交易添加业务

        在做添加之前t里面少了一项信息（customerId），这是客户的主键

        先处理客户相关的需求
        （1）判断customerName，根据客户名称在客户表进行精确查询，
         如有这个客户，则取出客户Id，封装到t对象中，
         如没有这个客户，则在客户表新建一条客户信息，然后将新建的客户Id取出封装到t对象中
         (2) 经过以上操作后，t对象中的信息就全了，然后进行添加交易的操作
         (3) 添加交易成功后，需要添加1条交易历史记录信息
         */
        boolean flag = true;
        Customer cus = customerDao.getCustomerByName(customerName);
        if (cus == null) {
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(t.getName());
            cus.setCreateBy(t.getCreateBy());
            cus.setCreateTime(DateTimeUtil.getSysTime());
            cus.setContactSummary(t.getContactSummary());
            cus.setOwner(t.getOwner());
            cus.setNextContactTime(t.getNextContactTime());

            //添加客户
            int count = customerDao.save(cus);
            if (count != 1) {
                flag = false;
            }
        }

        //通过以上的处理，已获取到客户的Id，现在将客户的Id封装到t对象中
        t.setCustomerId(cus.getId());

        //添加交易
        int count1 = tranDao.save(t);
        if (count1 != 1) {
            flag = false;
        }

        //添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setStage(t.getStage());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(t.getCreateBy());

        int count2 = tranHistoryDao.save(th);
        if (count2 != 1) {
            flag = false;
        }


        return flag;
    }

    @Override
    public Tran detail(String id) {

        Tran t = tranDao.detail(id);

        return t;
    }

    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {

        List<TranHistory> tList = tranHistoryDao.getHistoryListByTranId(tranId);

        return tList;
    }

    @Override
    public boolean changeStage(Tran t) {
        boolean flag = true;

        //改变交易阶段
        int count0 = tranDao.changeStage(t);
        if (count0 != 1) {
            flag = false;
        }

        //添加交易历史记录
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setStage(t.getStage());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());

        int count1 = tranHistoryDao.save(th);
        if (count1 != 1) {
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getCharts() {

        //取得total（总条数）
        int total = tranDao.getTotal();

        //取得dataList
        List<Map<String,Object>> dataList = tranDao.getCharts();

        Map<String,Object> map = new HashMap<String,Object>();

        map.put("total",total);
        map.put("dataList",dataList);


        return map;
    }
}
