package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 课程详情 目录
public class ResultClassDetailsCatalogBean implements IMouldType {


    private MouldList<ResultClassIndexItemBean> courseList;     //  课程列表

    public MouldList<ResultClassIndexItemBean> getCourseList() {
        return courseList;
    }

    public void setCourseList(MouldList<ResultClassIndexItemBean> courseList) {
        this.courseList = courseList;
    }
}