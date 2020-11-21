package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;

public class MineData2B implements IMouldType {
    private String realName; // 用户姓名
    private String mobile; // 手机号
    private String headPhoto; // 头像
    private String checkStatus; // 认证状态  1.init未认证（未填写认证信息）,2.submit待认证(提交认证信息待审核),3.success 认证成功,4.fail - 认证失败
    private String totalCommission; // 累计佣金(元)
    private String messageTotal; // 消息总数
    private String insuranceWarning; // 续保提醒数量
    private String idNo; // 身份证号

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getHeadPhoto() {
        return headPhoto;
    }

    public void setHeadPhoto(String headPhoto) {
        this.headPhoto = headPhoto;
    }

    public String getCheckStatus() {
        return checkStatus;
    }

    public void setCheckStatus(String checkStatus) {
        this.checkStatus = checkStatus;
    }

    public String getTotalCommission() {
        return totalCommission;
    }

    public void setTotalCommission(String totalCommission) {
        this.totalCommission = totalCommission;
    }

    public String getMessageTotal() {
        return messageTotal;
    }

    public void setMessageTotal(String messageTotal) {
        this.messageTotal = messageTotal;
    }

    public String getInsuranceWarning() {
        return insuranceWarning;
    }

    public void setInsuranceWarning(String insuranceWarning) {
        this.insuranceWarning = insuranceWarning;
    }

    public String getIdNo() {
        return idNo;
    }

    public void setIdNo(String idNo) {
        this.idNo = idNo;
    }
}