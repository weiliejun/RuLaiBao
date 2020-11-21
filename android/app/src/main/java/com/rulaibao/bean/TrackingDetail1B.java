package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *    交易记录--明细 实体类
 * Created by junde on 2018/4/16.
 */

public class TrackingDetail1B implements IMouldType {

    private String id; // 交易记录id
    private String orderType; // 账单类型
    private String underwirteTime; // 承保时间
    private String productName; //产品名称
    private String orderCode; // 保单编号
    private String customerName; // 客户姓名
    private String idNo; // 身份证号
    private String insurancePeriod; // 保险期限
    private String paymentPeriod; // 缴费期限（天）
    private String renewalDate ; // 续期日期
    private String  paymentedPremiums; // 已交保费（元）
    private String  promotioinCost; // 推广费（%）
    private String  commissionGained; // 获得佣金（元）
    private String  createTime; // 记录日期
    private String  commissionedTime; // 结算时间

    private String valueaddedTax;  // 增值税
    private String additionalTax;  // 附加税
    private String individualTax;  // 个人所得税

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getOrderType() {
        return orderType;
    }

    public void setOrderType(String orderType) {
        this.orderType = orderType;
    }

    public String getUnderwirteTime() {
        return underwirteTime;
    }

    public void setUnderwirteTime(String underwirteTime) {
        this.underwirteTime = underwirteTime;
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

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getIdNo() {
        return idNo;
    }

    public void setIdNo(String idNo) {
        this.idNo = idNo;
    }

    public String getInsurancePeriod() {
        return insurancePeriod;
    }

    public void setInsurancePeriod(String insurancePeriod) {
        this.insurancePeriod = insurancePeriod;
    }

    public String getPaymentPeriod() {
        return paymentPeriod;
    }

    public void setPaymentPeriod(String paymentPeriod) {
        this.paymentPeriod = paymentPeriod;
    }

    public String getRenewalDate() {
        return renewalDate;
    }

    public void setRenewalDate(String renewalDate) {
        this.renewalDate = renewalDate;
    }

    public String getPaymentedPremiums() {
        return paymentedPremiums;
    }

    public void setPaymentedPremiums(String paymentedPremiums) {
        this.paymentedPremiums = paymentedPremiums;
    }

    public String getPromotioinCost() {
        return promotioinCost;
    }

    public void setPromotioinCost(String promotioinCost) {
        this.promotioinCost = promotioinCost;
    }

    public String getCommissionGained() {
        return commissionGained;
    }

    public void setCommissionGained(String commissionGained) {
        this.commissionGained = commissionGained;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getCommissionedTime() {
        return commissionedTime;
    }

    public void setCommissionedTime(String commissionedTime) {
        this.commissionedTime = commissionedTime;
    }

    public String getValueaddedTax() {
        return valueaddedTax;
    }

    public void setValueaddedTax(String valueaddedTax) {
        this.valueaddedTax = valueaddedTax;
    }

    public String getAdditionalTax() {
        return additionalTax;
    }

    public void setAdditionalTax(String additionalTax) {
        this.additionalTax = additionalTax;
    }

    public String getIndividualTax() {
        return individualTax;
    }

    public void setIndividualTax(String individualTax) {
        this.individualTax = individualTax;
    }
}
