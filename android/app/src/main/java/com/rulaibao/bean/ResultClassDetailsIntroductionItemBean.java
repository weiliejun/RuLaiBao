package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

import java.io.Serializable;

public class ResultClassDetailsIntroductionItemBean implements IMouldType,Serializable{

    private String courseId;        //  课程id
    private String realName;        //  演讲人姓名
    private String position;        //  演讲人从业岗位
    private String headPhoto;        //  演讲人头像
    private String courseName;        //  课程名称
    private String courseTime;        //  课程时间
    private String typeName;        //  类型名称
    private String courseContent;        //  课程内容
    private String courseVideo;        //  课程视频

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getHeadPhoto() {
        return headPhoto;
    }

    public void setHeadPhoto(String headPhoto) {
        this.headPhoto = headPhoto;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getCourseTime() {
        return courseTime;
    }

    public void setCourseTime(String courseTime) {
        this.courseTime = courseTime;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getCourseContent() {
        return courseContent;
    }

    public void setCourseContent(String courseContent) {
        this.courseContent = courseContent;
    }

    public String getCourseVideo() {
        return courseVideo;
    }

    public void setCourseVideo(String courseVideo) {
        this.courseVideo = courseVideo;
    }
}
