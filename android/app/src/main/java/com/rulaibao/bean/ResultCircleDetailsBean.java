package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 圈子详情  数据(不含话题列表)
public class ResultCircleDetailsBean implements IMouldType {


    /**
     *
     * "appCircle": {
     "circleDes": "圈子1",
     "circleId": "18032709463185347070",
     "circleName": "圈子1",
     "circlePhoto": "http://192.168.1.82:9091/upload/rulaibao/appCircle/picture/18032709463185347070/18032709463185356480.jpg",
     "isJoin": "yes",
     "isManager": "yes",
     "memberCount": "0",
     "topicCount": "0"
     },
     "flag": "true",
     "msg": "获取成功",
     "topAppTopicTotal": 1,
     "topAppTopics": [{
     "topicContent": "今天保险有什么新险种？",
     "topicId": "18032709463185347071"
     }]
     *
     *
     */

    private ResultCircleDetailsItemBean appCircle;
    private String flag;
    private String message;
    private String topAppTopicTotal;

    private MouldList<ResultCircleDetailsTopItemBean> topAppTopics;


    public ResultCircleDetailsItemBean getAppCircle() {
        return appCircle;
    }

    public void setAppCircle(ResultCircleDetailsItemBean appCircle) {
        this.appCircle = appCircle;
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

    public String getTopAppTopicTotal() {
        return topAppTopicTotal;
    }

    public void setTopAppTopicTotal(String topAppTopicTotal) {
        this.topAppTopicTotal = topAppTopicTotal;
    }

    public MouldList<ResultCircleDetailsTopItemBean> getTopAppTopics() {
        return topAppTopics;
    }

    public void setTopAppTopics(MouldList<ResultCircleDetailsTopItemBean> topAppTopics) {
        this.topAppTopics = topAppTopics;
    }
}