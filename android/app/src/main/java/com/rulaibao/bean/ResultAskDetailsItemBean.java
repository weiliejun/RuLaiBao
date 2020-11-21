package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class ResultAskDetailsItemBean implements IMouldType{

    private String questionId;      //  问题id
    private String title;           //  问题标题
    private String descript;        //  问题描述
    private String time;            //  提问时间
    private String userName;        //  提问人姓名
    private String userPhoto;       //  提问人头像

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

    public String getDescript() {
        return descript;
    }

    public void setDescript(String descript) {
        this.descript = descript;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserPhoto() {
        return userPhoto;
    }

    public void setUserPhoto(String userPhoto) {
        this.userPhoto = userPhoto;
    }
}
