package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class ResultCircleDetailsItemBean implements IMouldType{


    private String circleId;        //  圈子id
    private String circleName;        //  圈子名称
    private String circleDesc;        //  圈子描述
    private String circlePhoto;        //  圈子头像
    private String memberCount;        //  圈子会员总数
    private String topicCount;        //  圈子话题总数
    private String isManager;        //  是否为圈子管理者（yes:是；no:否；）
    private String isJoin;        //  是否已经加入该圈子（yes:是；no:否；）
    private String topAppTopicTotal;        //  置顶话题总数
    private String isNeedAduit;     //  申请加入是否需要验证   （yes:是；no:否；）

    public String getIsNeedAduit() {
        return isNeedAduit;
    }

    public void setIsNeedAduit(String isNeedAduit) {
        this.isNeedAduit = isNeedAduit;
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

    public String getMemberCount() {
        return memberCount;
    }

    public void setMemberCount(String memberCount) {
        this.memberCount = memberCount;
    }

    public String getTopicCount() {
        return topicCount;
    }

    public void setTopicCount(String topicCount) {
        this.topicCount = topicCount;
    }

    public String getIsManager() {
        return isManager;
    }

    public void setIsManager(String isManager) {
        this.isManager = isManager;
    }

    public String getIsJoin() {
        return isJoin;
    }

    public void setIsJoin(String isJoin) {
        this.isJoin = isJoin;
    }

    public String getTopAppTopicTotal() {
        return topAppTopicTotal;
    }

    public void setTopAppTopicTotal(String topAppTopicTotal) {
        this.topAppTopicTotal = topAppTopicTotal;
    }
}
