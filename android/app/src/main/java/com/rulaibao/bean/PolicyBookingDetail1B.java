package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

/**
 *    预约详情 实体类
 * Created by junde on 2018/5/8.
 */

public class PolicyBookingDetail1B implements IMouldType {

    private String id; // 预约 id
    private String productName; // 预约产品名称
    private String auditStatus; // 预约状态(confirmed：已确认; confirming：待确认; refuse：已驳回; canceled：已取消;)
    private String createTime; // 预约时间
    private String userName; // 预约人姓名
    private String userId; // 预约人id
    private String companyName; // 保险公司名称
    private String insurancePlan; // 保险计划
    private String insuranceAmount; // 保险金额
    private String periodAmount; // 年缴保费
    private String insurancePeriod; // 保险期限
    private String paymentPeriod; //缴费期限
    private String exceptSubmitTime; // 预计交单时间
    private String remark; // 备注说明
    private String refuseReason; // 驳回原因
    private String mobile; // 预约电话
    private String productId; // 产品id
    private String auditTime; // 驳回时间

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

    public String getAuditStatus() {
        return auditStatus;
    }

    public void setAuditStatus(String auditStatus) {
        this.auditStatus = auditStatus;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getInsurancePlan() {
        return insurancePlan;
    }

    public void setInsurancePlan(String insurancePlan) {
        this.insurancePlan = insurancePlan;
    }

    public String getInsuranceAmount() {
        return insuranceAmount;
    }

    public void setInsuranceAmount(String insuranceAmount) {
        this.insuranceAmount = insuranceAmount;
    }

    public String getPeriodAmount() {
        return periodAmount;
    }

    public void setPeriodAmount(String periodAmount) {
        this.periodAmount = periodAmount;
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

    public String getExceptSubmitTime() {
        return exceptSubmitTime;
    }

    public void setExceptSubmitTime(String exceptSubmitTime) {
        this.exceptSubmitTime = exceptSubmitTime;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getRefuseReason() {
        return refuseReason;
    }

    public void setRefuseReason(String refuseReason) {
        this.refuseReason = refuseReason;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(String auditTime) {
        this.auditTime = auditTime;
    }
}
