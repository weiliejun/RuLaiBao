package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class ResultAskIndexItemBean implements IMouldType{

    private String questionId;      //  问题id
    private String title;      //  问题标题
    private String answerCount;      //  回复总数
    private String time;      //  问题发布时间
    private String answerName;      //  回答人姓名
    private String answerContent;      //  回答内容
    private String answerPhoto;      //  回答人头像

    public String getQuestionId() {
        return questionId;
    }

    public void setQuestionId(String questionId) {
        this.questionId = questionId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAnswerCount() {
        return answerCount;
    }

    public void setAnswerCount(String answerCount) {
        this.answerCount = answerCount;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getAnswerName() {
        return answerName;
    }

    public void setAnswerName(String answerName) {
        this.answerName = answerName;
    }

    public String getAnswerContent() {
        return answerContent;
    }

    public void setAnswerContent(String answerContent) {
        this.answerContent = answerContent;
    }

    public String getAnswerPhoto() {
        return answerPhoto;
    }

    public void setAnswerPhoto(String answerPhoto) {
        this.answerPhoto = answerPhoto;
    }
}
