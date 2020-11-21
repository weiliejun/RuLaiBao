package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class ResultClassIndexQualityBean implements IMouldType{

    /**
     * "courseId": "18042410091182866690",
     "courseLogo": "2",
     "courseName": "测试logo",
     "courseTime": "2018-04-27",
     "courseVideo": "https://v.qq.com/iframe/player.html?vid=t0635gds69",
     "position": "呆好不呢新增保单险种类别产品名称11",
     "speechmakeName": "呆好不呢新增保单险种类别产品名称11",
     "typeCode": "126666",
     "typeName": ""
     *
     */

    private String courseId;        //  课程id
    private String courseName;        //  课程姓名
    private String courseLogo;        //  课程封面
    private String speechmakeId;        //  演讲人id

    public String getSpeechmakeId() {
        return speechmakeId;
    }

    public void setSpeechmakeId(String speechmakeId) {
        this.speechmakeId = speechmakeId;
    }

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
}
