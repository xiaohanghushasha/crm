package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {

    List<String> getCustomerName(String name);

    Customer getCustomerByName(String company);

    int save(Customer customer);
}
