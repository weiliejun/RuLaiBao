package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;

// 课程详情 简介
public class ResultClassDetailsIntroductionBean implements IMouldType {


    private ResultClassDetailsIntroductionItemBean course;
    private String flag;
    private String message;

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public ResultClassDetailsIntroductionItemBean getCourse() {
        return course;
    }

    public void setCourse(ResultClassDetailsIntroductionItemBean course) {
        this.course = course;
    }
}