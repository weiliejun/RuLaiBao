package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class ResultCircleDetailsTopItemBean implements IMouldType {

    private String topicId;     //  话题id
    private String topicContent;     //  话题内容

    public String getTopicId() {
        return topicId;
    }

    public void setTopicId(String topicId) {
        this.topicId = topicId;
    }

    public String getTopicContent() {
        return topicContent;
    }

    public void setTopicContent(String topicContent) {
        this.topicContent = topicContent;
    }
}
