package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

/**
 *  互动消息 实体类
 * Created by junde on 2018/4/24.
 */

public class InteractiveNewsList2B implements IMouldType {

    private String type;       // 消息类型 question：跳转到提问详情；answer：跳转到回答详情；topic：跳转到话题详情；course：跳转到课程详情；
    private String createTime;  // 创建时间
    private String isRead;  // 已读状态（yes:已读；no:未读）
    private String themeContent;  // 被回复的主题内容
    private String replyContent;  // 回复内容
    private String replyPhoto;  //回复人头像
    private String replyName;  //回复人姓名
    private String targetName;  //被回复人姓名
    private String param1;  //跳转参数1
    private String param2;  //跳转参数2(详情接口如不需要则为空白字符串)

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getIsRead() {
        return isRead;
    }

    public void setIsRead(String isRead) {
        this.isRead = isRead;
    }

    public String getThemeContent() {
        return themeContent;
    }

    public void setThemeContent(String themeContent) {
        this.themeContent = themeContent;
    }

    public String getReplyContent() {
        return replyContent;
    }

    public void setReplyContent(String replyContent) {
        this.replyContent = replyContent;
    }

    public String getReplyPhoto() {
        return replyPhoto;
    }

    public void setReplyPhoto(String replyPhoto) {
        this.replyPhoto = replyPhoto;
    }

    public String getReplyName() {
        return replyName;
    }

    public void setReplyName(String replyName) {
        this.replyName = replyName;
    }

    public String getTargetName() {
        return targetName;
    }

    public void setTargetName(String targetName) {
        this.targetName = targetName;
    }

    public String getParam1() {
        return param1;
    }

    public void setParam1(String param1) {
        this.param1 = param1;
    }

    public String getParam2() {
        return param2;
    }

    public void setParam2(String param2) {
        this.param2 = param2;
    }
}
