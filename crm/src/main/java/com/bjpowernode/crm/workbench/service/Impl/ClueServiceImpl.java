package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ClueService;

import javax.swing.plaf.IconUIResource;
import java.util.Date;
import java.util.List;

public class ClueServiceImpl implements ClueService {
    //线索相关表
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private ClueActivityRelationDao clueActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
    private ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);

    //客户相关表
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);

    //联系人相关表
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
    private ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);

    //交易相关表
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);

    @Override
    public boolean save(Clue clue) {
        boolean flag = true;
        int count = clueDao.save(clue);
        if (count!=1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Clue detail(String id) {

        Clue c = clueDao.detail(id);
        return c;
    }

    @Override
    public boolean unbund(String id) {
        boolean flag = true;
        int count = clueActivityRelationDao.unbund(id);
        if (count!=1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean bund(String cid, String[] aids) {
        boolean flag = true;

        for(String aid : aids){
            //取得每一个aid和cid做关联
            ClueActivityRelation car = new ClueActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setActivityId(aid);
            car.setClueId(cid);

            //添加关联关系表中的记录
            int count = clueActivityRelationDao.bund(car);
            if (count!=1){
                flag = false;
            }
        }
        return flag;
    }

    @Override
    public boolean convert(String clueId, Tran t, String createBy) {
        String createTime = DateTimeUtil.getSysTime();
        boolean flag = true;

        //(1)通过线索id获取线索对象，线索对象中封装了线索信息
        Clue c = clueDao.getById(clueId);
        //(2)通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司名称精确匹配，判断该客户是否存在）
        String company = c.getCompany();
        Customer customer = customerDao.getCustomerByName(company);
        //如果customer为null，说明没有这个客户，需要新建客户
        if (customer==null){

            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setAddress(c.getAddress());
            customer.setWebsite(c.getWebsite());
            customer.setPhone(c.getPhone());
            customer.setOwner(c.getOwner());
            customer.setNextContactTime(c.getNextContactTime());
            customer.setName(company);
            customer.setDescription(c.getDescription());
            customer.setContactSummary(c.getContactSummary());
            customer.setCreateBy(createBy);
            customer.setCreateTime(createTime);

            //添加客户
            int count1 = customerDao.save(customer);
            if (count1!=1){
                flag = false;
            }
        }

        //----------------------------------------------------------------------------------
        //经过第二步的处理后，客户的信息我们已经拥有了，将来在处理其他表的时候，如果要使用到客户的id
        //直接使用customer.getId()
        //----------------------------------------------------------------------------------

        //(3)通过线索对象提取联系人信息，保存联系人
        Contacts contacts = new Contacts();
        contacts.setSource(c.getSource());
        contacts.setOwner(c.getOwner());
        contacts.setNextContactTime(c.getNextContactTime());
        contacts.setMphone(c.getMphone());
        contacts.setJob(c.getJob());
        contacts.setFullname(c.getFullname());
        contacts.setEmail(c.getEmail());
        contacts.setDescription( c.getDescription());
        contacts.setCustomerId(customer.getId());
        contacts.setId(UUIDUtil.getUUID());
        contacts.setCreateTime(createTime);
        contacts.setCreateBy(createBy);
        contacts.setContactSummary(c.getContactSummary());
        contacts.setAppellation(c.getAppellation());
        contacts.setAddress(c.getAddress());
        //添加联系人
        int count2 = contactsDao.save(contacts);
        if (count2!=1){
            flag = false;
        }

        //----------------------------------------------------------------------------------
        //经过第三步的处理后，联系人的信息我们已经拥有了，将来在处理其他表的时候，如果要使用到联系人的id
        //直接使用contacts.getId()
        //----------------------------------------------------------------------------------

        //（4）线索备注转换到客户备注以及联系人备注
        //查询出与该线索关联的备注信息列表
        List<ClueRemark> clueRemarkList = clueRemarkDao.getListByClueId(clueId);
        //取出每一条线索的备注
        for (ClueRemark clueRemark : clueRemarkList){
            //取出备注信息（主要转换到客户备注和联系人备注的就是这个备注信息）
            String noteContent = clueRemark.getNoteContent();
            //创建客户备注对象，添加客户备注
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(noteContent);
            customerRemark.setCreateTime(createTime);
            customerRemark.setCreateBy(createBy);
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setEditFlag("0");

            int count3 = customerRemarkDao.save(customerRemark);
            if (count3!=1){
                flag = false;
            }
            //创建联系人备注对象，添加联系人备注
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setNoteContent(noteContent);
            contactsRemark.setEditFlag("0");

            int count4 = contactsRemarkDao.save(contactsRemark);
            if (count4!=1){
                flag = false;
            }
        }

        //(5)"线索和市场活动"的关系转换到"联系人和市场活动"的关系
        //查询出与该条线索关联的市场活动，查询与市场活动的关联关系列表
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getListById(clueId);
        //遍历出每一条与市场活动关联的关联关系记录
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList){
            //从每一条遍历出来的记录中取出关联的市场活动id
            String activityId = clueActivityRelation.getActivityId();

            //创建联系人与市场活动的关联关系对象，让第三步生成的联系人与市场活动做关联
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(activityId);
            contactsActivityRelation.setContactsId(contacts.getId());
            //添加联系人与市场活动的关联关系
            int count5 = contactsActivityRelationDao.save(contactsActivityRelation);
            if (count5!=1){
                flag = false;
            }

        }

        //(6)如果有创建交易的需求，创建一条交易
        if (t!=null){
            t.setSource(c.getSource());
            t.setOwner(c.getOwner());
            t.setNextContactTime(c.getNextContactTime());
            t.setDescription(c.getDescription());
            t.setCustomerId(customer.getId());
            t.setContactSummary(c.getContactSummary());
            t.setContactsId(contacts.getId());
            //添加交易
            int count6 = tranDao.save(t);
            if (count6!=1){
                flag = false;
            }

            //（7）如创建了一条交易，就要创建一条该交易的交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(createTime);
            tranHistory.setMoney(t.getMoney());
            tranHistory.setTranId(t.getId());
            tranHistory.setStage(t.getStage());
            tranHistory.setExpectedDate(t.getExpectedDate());
            //添加交易历史
            int count7 = tranHistoryDao.save(tranHistory);
            if (count7!=1){
                flag = false;
            }
        }

        //（8）删除线索备注
        for (ClueRemark clueRemark : clueRemarkList){

            int count8 = clueRemarkDao.delete(clueRemark);
            if (count8!=1){
                flag = false;
            }
        }

        //(9)删除线索和市场活动的关系
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList){
            int count9 = clueActivityRelationDao.delete(clueActivityRelation);
            if (count9!=1){
                flag = false;
            }
        }

        //(10)删除线索
        int count10 = clueDao.delete(clueId);
        if (count10!=1){
            flag = false;
        }


        return flag;
    }
}
