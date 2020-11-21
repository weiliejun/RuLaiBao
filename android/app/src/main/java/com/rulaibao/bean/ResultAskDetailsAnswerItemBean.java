package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class ResultAskDetailsAnswerItemBean implements IMouldType{

    private String answerId;        //  回答的id
    private String answerContent;        //  回答内容
    private String commentCount;        //  评论总数
    private String likeCount;        //  点赞总数
    private String answerTime;        //  回答时间
    private String answerName;        //  回答人姓名
    private String answerPhoto;        //  回答人头像
    private String likeStatus;        //  点赞状态（yes:已点赞；no:未点赞；）

    public String getAnswerId() {
        return answerId;
    }

    public void setAnswerId(String answerId) {
        this.answerId = answerId;
    }

    public String getAnswerContent() {
        return answerContent;
    }

    public void setAnswerContent(String answerContent) {
        this.answerContent = answerContent;
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

    public String getAnswerTime() {
        return answerTime;
    }

    public void setAnswerTime(String answerTime) {
        this.answerTime = answerTime;
    }

    public String getAnswerName() {
        return answerName;
    }

    public void setAnswerName(String answerName) {
        this.answerName = answerName;
    }

    public String getAnswerPhoto() {
        return answerPhoto;
    }

    public void setAnswerPhoto(String answerPhoto) {
        this.answerPhoto = answerPhoto;
    }

    public String getLikeStatus() {
        return likeStatus;
    }

    public void setLikeStatus(String likeStatus) {
        this.likeStatus = likeStatus;
    }
}
