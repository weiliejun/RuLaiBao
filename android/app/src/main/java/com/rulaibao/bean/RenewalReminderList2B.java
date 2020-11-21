package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

/**
 *    续保提醒列表 实体类
 * Created by junde on 2018/5/3.
 */

public class RenewalReminderList2B implements IMouldType {

    private String orderId; // 保单ID
    private String insuranceName; // 保险名称
    private String companyLogo; // 保险LOGO地址
    private String status; // 保单状态
    private String customerName; // 客户姓名
    private String paymentedPremiums; // 已交保费
    private String insurancePeriod; // 保险期限

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getInsuranceName() {
        return insuranceName;
    }

    public void setInsuranceName(String insuranceName) {
        this.insuranceName = insuranceName;
    }

    public String getCompanyLogo() {
        return companyLogo;
    }

    public void setCompanyLogo(String companyLogo) {
        this.companyLogo = companyLogo;
    }

    public String getInsurancPeremiums() {
        return paymentedPremiums;
    }

    public void setInsurancPeremiums(String insurancPeremiums) {
        this.paymentedPremiums = insurancPeremiums;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
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
