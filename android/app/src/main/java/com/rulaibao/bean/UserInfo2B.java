package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;

/**
 *  个人信息/销售认证
 */
public class UserInfo2B implements IMouldType {
    private String realName; // 用户姓名
    private String mobile; // 手机号
    private String headPhoto; // 头像
    private String checkStatus; // 认证状态  1.init未认证（未填写认证信息）,2.submit待认证(提交认证信息待审核),3.submit待认证(提交认证信息待审核),4.fail - 认证失败
    private String busiCardPhoto; // 名片
    private String position; // 从业岗位
    private String idNo; // 身份证号
    private String area; // 省市（beijing 默认,  hebei,neimeng, guihzou）

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

    public String getBusiCardPhoto() {
        return busiCardPhoto;
    }

    public void setBusiCardPhoto(String busiCardPhoto) {
        this.busiCardPhoto = busiCardPhoto;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getIdNo() {
        return idNo;
    }

    public void setIdNo(String idNo) {
        this.idNo = idNo;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }
}