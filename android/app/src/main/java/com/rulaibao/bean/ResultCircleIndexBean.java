package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 圈子首页数据
public class ResultCircleIndexBean implements IMouldType {

    private String flag;
    private String message;
    private MouldList<ResultCircleIndexItemBean> myAppCircle;
    private String myAppCircleTotal;
    private MouldList<ResultCircleIndexItemBean> myJoinAppCircle;
    private String myJoinAppCircleTotal;
    private MouldList<ResultCircleIndexItemBean> myRecomAppCircle;
    private String myRecomAppCircleTotal;


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

    public MouldList<ResultCircleIndexItemBean> getMyAppCircle() {
        return myAppCircle;
    }

    public void setMyAppCircle(MouldList<ResultCircleIndexItemBean> myAppCircle) {
        this.myAppCircle = myAppCircle;
    }

    public String getMyAppCircleTotal() {
        return myAppCircleTotal;
    }

    public void setMyAppCircleTotal(String myAppCircleTotal) {
        this.myAppCircleTotal = myAppCircleTotal;
    }

    public MouldList<ResultCircleIndexItemBean> getMyJoinAppCircle() {
        return myJoinAppCircle;
    }

    public void setMyJoinAppCircle(MouldList<ResultCircleIndexItemBean> myJoinAppCircle) {
        this.myJoinAppCircle = myJoinAppCircle;
    }

    public String getMyJoinAppCircleTotal() {
        return myJoinAppCircleTotal;
    }

    public void setMyJoinAppCircleTotal(String myJoinAppCircleTotal) {
        this.myJoinAppCircleTotal = myJoinAppCircleTotal;
    }

    public MouldList<ResultCircleIndexItemBean> getMyRecomAppCircle() {
        return myRecomAppCircle;
    }

    public void setMyRecomAppCircle(MouldList<ResultCircleIndexItemBean> myRecomAppCircle) {
        this.myRecomAppCircle = myRecomAppCircle;
    }

    public String getMyRecomAppCircleTotal() {
        return myRecomAppCircleTotal;
    }

    public void setMyRecomAppCircleTotal(String myRecomAppCircleTotal) {
        this.myRecomAppCircleTotal = myRecomAppCircleTotal;
    }
}