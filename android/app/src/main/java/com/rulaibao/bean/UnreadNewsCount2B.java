package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;


// 未读消息
public class UnreadNewsCount2B implements IMouldType {
	private String insurance;// 保单消息
	private String commission; // 佣金消息
	private String comment; // 互动消息
	private String circle; // 圈子新成员
	private String otherMessage; // 其它消息


    public String getInsurance() {
        return insurance;
    }

    public void setInsurance(String insurance) {
        this.insurance = insurance;
    }

    public String getCommission() {
        return commission;
    }

    public void setCommission(String commission) {
        this.commission = commission;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getCircle() {
        return circle;
    }

    public void setCircle(String circle) {
        this.circle = circle;
    }

    public String getOtherMessage() {
        return otherMessage;
    }

    public void setOtherMessage(String otherMessage) {
        this.otherMessage = otherMessage;
    }
}
