package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class ResultClassDetailsDiscussItemReplyBean implements IMouldType{

    private String rid;     //  此条回复的id
    private String replyContent;     //  回复内容
    private String replyTime;     //  回复时间
    private String replyId;     //  回复人id
    private String replyName;     //  回复人姓名
    private String replyToId;     //  被回复人id
    private String replyToName;     //  被回复人姓名

    public String getRid() {
        return rid;
    }

    public void setRid(String rid) {
        this.rid = rid;
    }

    public String getReplyContent() {
        return replyContent;
    }

    public void setReplyContent(String replyContent) {
        this.replyContent = replyContent;
    }

    public String getReplyTime() {
        return replyTime;
    }

    public void setReplyTime(String replyTime) {
        this.replyTime = replyTime;
    }

    public String getReplyId() {
        return replyId;
    }

    public void setReplyId(String replyId) {
        this.replyId = replyId;
    }

    public String getReplyName() {
        return replyName;
    }

    public void setReplyName(String replyName) {
        this.replyName = replyName;
    }

    public String getReplyToId() {
        return replyToId;
    }

    public void setReplyToId(String replyToId) {
        this.replyToId = replyToId;
    }

    public String getReplyToName() {
        return replyToName;
    }

    public void setReplyToName(String replyToName) {
        this.replyToName = replyToName;
    }
}
