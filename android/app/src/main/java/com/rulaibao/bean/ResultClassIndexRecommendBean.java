package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class ResultClassIndexRecommendBean implements IMouldType{

    private String courseId;        //  课程id
    private String courseName;      //  课程名称
    private String speechmakeName;      //  演讲人姓名
    private String speechmakeId;        //  演讲人id
    private String position;            //  从业岗位
    private String courseTime;          //  课程时间
    private String courseLogo;          //  课程封面

    public String getCourseLogo() {
        return courseLogo;
    }

    public void setCourseLogo(String courseLogo) {
        this.courseLogo = courseLogo;
    }

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getSpeechmakeName() {
        return speechmakeName;
    }

    public void setSpeechmakeName(String speechmakeName) {
        this.speechmakeName = speechmakeName;
    }

    public String getSpeechmakeId() {
        return speechmakeId;
    }

    public void setSpeechmakeId(String speechmakeId) {
        this.speechmakeId = speechmakeId;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getCourseTime() {
        return courseTime;
    }

    public void setCourseTime(String courseTime) {
        this.courseTime = courseTime;
    }
}
