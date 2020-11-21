package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

/**
 *    预约列表 实体类
 * Created by junde on 2018/4/19.
 */

public class PolicyBookingList2B implements IMouldType {

    private String auditId; // 审核者id
    private String id; // 预约id
    private String productId; // 保险产品id
    private String userId; // 用户id
    private String productName; // 预约产品名称
    private String auditStatus; //审核状态： confirmed：表示已确认；confirming：待确认  refuse：已驳回；canceled：已取消
    private String insuranceAmount; // 保险金额

    public String getAuditId() {
        return auditId;
    }

    public void setAuditId(String auditId) {
        this.auditId = auditId;
    }

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

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
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

    public String getInsuranceAmount() {
        return insuranceAmount;
    }

    public void setInsuranceAmount(String insuranceAmount) {
        this.insuranceAmount = insuranceAmount;
    }
}
