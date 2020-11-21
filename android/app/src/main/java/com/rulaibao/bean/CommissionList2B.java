package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

/**
 *    待发、已发佣金列表 实体类
 * Created by hong on 2018/11/08.
 */

public class CommissionList2B implements IMouldType {

    private String id; // ID
    private String productId; // 产品ID
    private String orderId; // 保单编号
    private String productName; // 产品名称
    private String userId; // 用户ID
    private String userName; // 用户名称
    private String companyLogo; // 保险LOGO地址
    private String paymentedPremiums; // 已交保费
    private String insurancePeriod; // 保险期限

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getCompanyLogo() {
        return companyLogo;
    }

    public void setCompanyLogo(String companyLogo) {
        this.companyLogo = companyLogo;
    }

    public String getPaymentedPremiums() {
        return paymentedPremiums;
    }

    public void setPaymentedPremiums(String paymentedPremiums) {
        this.paymentedPremiums = paymentedPremiums;
    }

    public String getInsurancePeriod() {
        return insurancePeriod;
    }

    public void setInsurancePeriod(String insurancePeriod) {
        this.insurancePeriod = insurancePeriod;
    }
}
