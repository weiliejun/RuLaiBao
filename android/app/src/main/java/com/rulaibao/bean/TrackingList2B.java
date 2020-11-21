package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;

public class TrackingList2B implements IMouldType {
    private String id; // 交易记录id
    private String productName; // 产品名称
    private String orderCode; // 保单编号
    private String commissionGained; // 获得佣金
    private String commissionTime ; // 收益日期


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public String getCommissionGained() {
        return commissionGained;
    }

    public void setCommissionGained(String commissionGained) {
        this.commissionGained = commissionGained;
    }

    public String getCommissionTime() {
        return commissionTime;
    }

    public void setCommissionTime(String commissionTime) {
        this.commissionTime = commissionTime;
    }
}