package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

public class ResultClassDetailsDiscussItemBean implements IMouldType{

    private String cid;     //  评论的id
    private String commentContent;     //  评论内容
    private String commentTime;     //  评论时间
    private String commentName;     //  评论人姓名
    private String commentId;     //  评论人id
    private String commentPhoto;     //  评论人头像

    private MouldList<ResultClassDetailsDiscussItemReplyBean> replys;

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

    public MouldList<ResultClassDetailsDiscussItemReplyBean> getReplys() {
        return replys;
    }

    public void setReplys(MouldList<ResultClassDetailsDiscussItemReplyBean> replys) {
        this.replys = replys;
    }
}
