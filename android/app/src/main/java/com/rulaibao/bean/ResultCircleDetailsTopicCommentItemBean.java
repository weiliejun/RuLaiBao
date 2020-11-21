package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

public class ResultCircleDetailsTopicCommentItemBean implements IMouldType{


    private String cid;     //  评论的id
    private String commentContent;     //  评论内容
    private String commentTime;     //  评论时间
    private String commentName;     //  评论人姓名
    private String commentId;     //  评论人id
    private String commentPhoto;     //  评论人头像
    private MouldList<ResultCircleDetailsTopicCommentReplyItemBean> replys;     //  回复列表
    private String imgCommentUrl;       //  评论图片地址
    private String linkCommentUrl;       //  评论链接地址
    private String imgCommentUrlBig;        //  评论图片地址（大图）
    private String imgCommentUrlSmall;        //  评论图片地址（小图）
    private String imgCommentHeight;        //  评论图片高度
    private String imgCommentWidth;        //  评论图片宽度

    public String getImgCommentUrlBig() {
        return imgCommentUrlBig;
    }

    public void setImgCommentUrlBig(String imgCommentUrlBig) {
        this.imgCommentUrlBig = imgCommentUrlBig;
    }

    public String getImgCommentUrlSmall() {
        return imgCommentUrlSmall;
    }

    public void setImgCommentUrlSmall(String imgCommentUrlSmall) {
        this.imgCommentUrlSmall = imgCommentUrlSmall;
    }

    public String getImgCommentHeight() {
        return imgCommentHeight;
    }

    public void setImgCommentHeight(String imgCommentHeight) {
        this.imgCommentHeight = imgCommentHeight;
    }

    public String getImgCommentWidth() {
        return imgCommentWidth;
    }

    public void setImgCommentWidth(String imgCommentWidth) {
        this.imgCommentWidth = imgCommentWidth;
    }

    public String getImgCommentUrl() {
        return imgCommentUrl;
    }

    public void setImgCommentUrl(String imgCommentUrl) {
        this.imgCommentUrl = imgCommentUrl;
    }

    public String getLinkCommentUrl() {
        return linkCommentUrl;
    }

    public void setLinkCommentUrl(String linkCommentUrl) {
        this.linkCommentUrl = linkCommentUrl;
    }

    public String getCid() {
        return cid;
    }

    public void setCid(String cid) {
        this.cid = cid;
    }

    public String getCommentContent() {
        return commentContent;
    }

    public void setCommentContent(String commentContent) {
        this.commentContent = commentContent;
    }

    public String getCommentTime() {
        return commentTime;
    }

    public void setCommentTime(String commentTime) {
        this.commentTime = commentTime;
    }

    public String getCommentName() {
        return commentName;
    }

    public void setCommentName(String commentName) {
        this.commentName = commentName;
    }

    public String getCommentId() {
        return commentId;
    }

    public void setCommentId(String commentId) {
        this.commentId = commentId;
    }

    public String getCommentPhoto() {
        return commentPhoto;
    }

    public void setCommentPhoto(String commentPhoto) {
        this.commentPhoto = commentPhoto;
    }

    public MouldList<ResultCircleDetailsTopicCommentReplyItemBean> getReplys() {
        return replys;
    }

    public void setReplys(MouldList<ResultCircleDetailsTopicCommentReplyItemBean> replys) {
        this.replys = replys;
    }
}
