package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 圈子详情  话题列表
public class ResultCircleDetailsTopicListBean implements IMouldType {


    private String total;
    private String flag;
    private String message;
    private MouldList<ResultCircleDetailsTopicItemBean> appTopics;

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

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }

    public MouldList<ResultCircleDetailsTopicItemBean> getAppTopics() {
        return appTopics;
    }

    public void setAppTopics(MouldList<ResultCircleDetailsTopicItemBean> appTopics) {
        this.appTopics = appTopics;
    }
}