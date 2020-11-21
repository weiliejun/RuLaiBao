package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

/**
 * Created by xww on 2018/9/12
 **/
public class ResultPPTFileBean implements IMouldType{

    private String courseFilePath;
    private String courseFileName;

    public String getCourseFilePath() {
        return courseFilePath;
    }

    public void setCourseFilePath(String courseFilePath) {
        this.courseFilePath = courseFilePath;
    }

    public String getCourseFileName() {
        return courseFileName;
    }

    public void setCourseFileName(String courseFileName) {
        this.courseFileName = courseFileName;
    }
}
