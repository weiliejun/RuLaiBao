package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class ResultCircleDetailsTopicDetailsItemBean implements IMouldType{

    private String topicId;      //     话题id
    private String topicContent;      //     话题内容
    private String commentCount;      //
    private String likeCount;      //     点赞总数
    private String createTime;      //     话题创建时间
    private String creatorName;      //     话题发表人
    private String creatorPhoto;      //     话题发表人头像
    private String likeStatus;      //     点赞状态（yes:已点赞；no:未点赞；）
    private String circleName;      //     圈子名称
    private String isTop;       //  是否置顶（yes是  no 否）
    private String isManager;       //  是否是管理员 (yes是  no否)
    private String circleId;        //  圈子id
    private String isJoin;        //  是否已加入圈子       yes 是   no否

    public String getIsJoin() {
        return isJoin;
    }

    public void setIsJoin(String isJoin) {
        this.isJoin = isJoin;
    }

    public String getCircleId() {
        return circleId;
    }

    public void setCircleId(String circleId) {
        this.circleId = circleId;
    }

    public String getIsTop() {
        return isTop;
    }

    public void setIsTop(String isTop) {
        this.isTop = isTop;
    }

    public String getIsManager() {
        return isManager;
    }

    public void setIsManager(String isManager) {
        this.isManager = isManager;
    }

    public String getTopicId() {
        return topicId;
    }

    public void setTopicId(String topicId) {
        this.topicId = topicId;
    }

    public String getTopicContent() {
        return topicContent;
    }

    public void setTopicContent(String topicContent) {
        this.topicContent = topicContent;
    }

    public String getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(String commentCount) {
        this.commentCount = commentCount;
    }

    public String getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(String likeCount) {
        this.likeCount = likeCount;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getCreatorName() {
        return creatorName;
    }

    public void setCreatorName(String creatorName) {
        this.creatorName = creatorName;
    }

    public String getCreatorPhoto() {
        return creatorPhoto;
    }

    public void setCreatorPhoto(String creatorPhoto) {
        this.creatorPhoto = creatorPhoto;
    }

    public String getLikeStatus() {
        return likeStatus;
    }

    public void setLikeStatus(String likeStatus) {
        this.likeStatus = likeStatus;
    }

    public String getCircleName() {
        return circleName;
    }

    public void setCircleName(String circleName) {
        this.circleName = circleName;
    }
}
