package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 研修首页 课程
public class ResultClassIndexBean implements IMouldType {

    /**
     *
     * "courseRecommend": {
     "courseId": "18040809331701583466",
     "courseLogo": "1",
     "courseName": "aa",
     "courseTime": "2018-04-10",
     "courseVideo": "aaaaaaaaaaaa",
     "position": "0000000",
     "speechmakeName": "leige",
     "typeCode": "123456",
     "typeName": ""
     },
     "qualityCourseList": [{
     "courseId": "18032709463185347070",
     "courseLogo": "1",
     "courseName": "儿童保障基金",
     "courseTime": "2018-03-30",
     "courseVideo": "https://v.qq.com/x/page/y0637r23h19.html",
     "position": "0000000",
     "speechmakeName": "leige",
     "typeCode": "126666",
     "typeName": ""
     }, {
     "courseId": "19932709463185347070",
     "courseLogo": "1",
     "courseName": "老人医疗保障",
     "courseTime": "2018-03-30",
     "courseVideo": "https://v.qq.com/x/page/y0637r23h19.html",
     "position": "0000000",
     "speechmakeName": "leige",
     "typeCode": "126666",
     "typeName": ""
     }, {
     "courseId": "18042317460375639293",
     "courseLogo": "1",
     "courseName": "感冒测试",
     "courseTime": "2018-04-26",
     "courseVideo": "https://v.qq.com/x/page/y0637r23h19.html",
     "position": "呆好不呢新增保单险种类别产品名称11",
     "speechmakeName": "呆好不呢新增保单险种类别产品名称11",
     "typeCode": "126666",
     "typeName": ""
     }, {
     "courseId": "18042410091182866690",
     "courseLogo": "2",
     "courseName": "测试logo",
     "courseTime": "2018-04-27",
     "courseVideo": "https://v.qq.com/iframe/player.html?vid=t0635gds69",
     "position": "呆好不呢新增保单险种类别产品名称11",
     "speechmakeName": "呆好不呢新增保单险种类别产品名称11",
     "typeCode": "126666",
     "typeName": ""
     }]
     *
     */

    private ResultClassIndexRecommendBean courseRecommend;
    private MouldList<ResultClassIndexQualityBean> qualityCourseList; // 精品课程列表
    private MouldList<ResultClassIndexItemBean> courseList; // 课程列表
    private MouldList<ResultClassIndexItemBean> courseTypeList; // 课程类型列表
    private int count; // 精品课程数量

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public MouldList<ResultClassIndexItemBean> getCourseList() {
        return courseList;
    }

    public void setCourseList(MouldList<ResultClassIndexItemBean> courseList) {
        this.courseList = courseList;
    }

    public MouldList<ResultClassIndexItemBean> getCourseTypeList() {
        return courseTypeList;
    }

    public void setCourseTypeList(MouldList<ResultClassIndexItemBean> courseTypeList) {
        this.courseTypeList = courseTypeList;
    }

    public ResultClassIndexRecommendBean getCourseRecommend() {
        return courseRecommend;
    }

    public void setCourseRecommend(ResultClassIndexRecommendBean courseRecommend) {
        this.courseRecommend = courseRecommend;
    }

    public MouldList<ResultClassIndexQualityBean> getQualityCourseList() {
        return qualityCourseList;
    }

    public void setQualityCourseList(MouldList<ResultClassIndexQualityBean> qualityCourseList) {
        this.qualityCourseList = qualityCourseList;
    }
}