package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 圈子详情  话题详情
public class ResultCircleDetailsTopicDetailsBean implements IMouldType {


    private String flag;
    private String message;
    private ResultCircleDetailsTopicDetailsItemBean appTopic;
    private String code;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

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

    public ResultCircleDetailsTopicDetailsItemBean getAppTopic() {
        return appTopic;
    }

    public void setAppTopic(ResultCircleDetailsTopicDetailsItemBean appTopic) {
        this.appTopic = appTopic;
    }
}