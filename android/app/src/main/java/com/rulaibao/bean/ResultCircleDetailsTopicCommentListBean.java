package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 圈子详情  话题详情 评论列表
public class ResultCircleDetailsTopicCommentListBean implements IMouldType {


    private String flag;
    private String message;
    private String total;
    private MouldList<ResultCircleDetailsTopicCommentItemBean> list;

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

    public MouldList<ResultCircleDetailsTopicCommentItemBean> getList() {
        return list;
    }

    public void setList(MouldList<ResultCircleDetailsTopicCommentItemBean> list) {
        this.list = list;
    }
}