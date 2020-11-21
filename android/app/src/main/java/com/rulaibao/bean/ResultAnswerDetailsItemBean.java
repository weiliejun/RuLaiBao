package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class ResultAnswerDetailsItemBean implements IMouldType{

    public String title;        //  问题标题
    public String answerId;        //  回答id
    public String answerContent;        //  回答内容
    public String answerTime;        //  回答时间
    public String answerName;        //  回答人姓名
    public String answerPhoto;        //  回答人头像
    public String likeStatus;        //  点赞状态

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

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
