package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 圈子首页数据item
public class ResultCircleIndexItemBean implements IMouldType {

    private String circleId;        //  圈子id
    private String circleName;        //  圈子名称
    private String circleDesc;        //  圈子描述
    private String circlePhoto;        //  圈子头像
    private String isApply;        //  是否可申请加入        yes已申请  no 可加入

    public String getIsApply() {
        return isApply;
    }

    public void setIsApply(String isApply) {
        this.isApply = isApply;
    }

    public String getCircleId() {
        return circleId;
    }

    public void setCircleId(String circleId) {
        this.circleId = circleId;
    }

    public String getCircleName() {
        return circleName;
    }

    public void setCircleName(String circleName) {
        this.circleName = circleName;
    }

    public String getCircleDesc() {
        return circleDesc;
    }

    public void setCircleDesc(String circleDesc) {
        this.circleDesc = circleDesc;
    }

    public String getCirclePhoto() {
        return circlePhoto;
    }

    public void setCirclePhoto(String circlePhoto) {
        this.circlePhoto = circlePhoto;
    }
}