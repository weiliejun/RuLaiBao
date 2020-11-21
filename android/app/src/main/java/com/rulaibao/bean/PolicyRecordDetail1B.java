package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

/**
 *    保单详情 实体类
 * Created by junde on 2018/4/16.
 */

public class PolicyRecordDetail1B implements IMouldType {

    private String status; // 保单状态 (init:待审核; payed:已承保; rejected:问题件; receiptSigned:回执签收; commissioned:已结算; 续保中:renewing;已续保:renewed)
    private String underwirteTime; // 承保时间
    private String orderCode; // 保单编号
    private String insuranceName; //产品名称
    private String customerName; // 客户姓名
    private String customerIdNo; // 身份证号
    private String insurancePeriod; // 保险期限
    private String paymentPeriod; // 缴费期限（天）
    private String renewalDate ; // 续期日期
    private String paymentedPremiums; // 已交保费（元）
    private String promotioinCost; // 推广费（%）
    private String commissionGained; // 获得佣金（元）
    private String recordTime; // 记录日期
    private int attachmentNum; // 附件数量(0，1，2，3，4，5)
    private String idcardPositive; // 身份证正面
    private String idcardNegative; // 身份证反面
    private String bankCard; // 银行卡
    private String attachmentFirst; // 附件一
    private String attachmentSecond; // 附件二
    private String remark; // 备注说明
    private String auditDesc; // 驳回原因（问题保单）
    private String auditTime; // 驳回时间（问题保单）
    private String productId; // 产品编号
    private String productStatus; // normal：正常；delete：已删除;  down：已下架


    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUnderwirteTime() {
        return underwirteTime;
    }

    public void setUnderwirteTime(String underwirteTime) {
        this.underwirteTime = underwirteTime;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public String getInsuranceName() {
        return insuranceName;
    }

    public void setInsuranceName(String insuranceName) {
        this.insuranceName = insuranceName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerIdNo() {
        return customerIdNo;
    }

    public void setCustomerIdNo(String customerIdNo) {
        this.customerIdNo = customerIdNo;
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

    public String getRecordTime() {
        return recordTime;
    }

    public void setRecordTime(String recordTime) {
        this.recordTime = recordTime;
    }

    public int getAttachmentNum() {
        return attachmentNum;
    }

    public void setAttachmentNum(int attachmentNum) {
        this.attachmentNum = attachmentNum;
    }

    public String getIdcardPositive() {
        return idcardPositive;
    }

    public void setIdcardPositive(String idcardPositive) {
        this.idcardPositive = idcardPositive;
    }

    public String getIdcardNegative() {
        return idcardNegative;
    }

    public void setIdcardNegative(String idcardNegative) {
        this.idcardNegative = idcardNegative;
    }

    public String getBankCard() {
        return bankCard;
    }

    public void setBankCard(String bankCard) {
        this.bankCard = bankCard;
    }

    public String getAttachmentFirst() {
        return attachmentFirst;
    }

    public void setAttachmentFirst(String attachmentFirst) {
        this.attachmentFirst = attachmentFirst;
    }

    public String getAttachmentSecond() {
        return attachmentSecond;
    }

    public void setAttachmentSecond(String attachmentSecond) {
        this.attachmentSecond = attachmentSecond;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getAuditDesc() {
        return auditDesc;
    }

    public void setAuditDesc(String auditDesc) {
        this.auditDesc = auditDesc;
    }

    public String getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(String auditTime) {
        this.auditTime = auditTime;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductStatus() {
        return productStatus;
    }

    public void setProductStatus(String productStatus) {
        this.productStatus = productStatus;
    }
}

