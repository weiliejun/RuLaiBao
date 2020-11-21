package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 课程详情 研讨
public class ResultClassDetailsDiscussBean implements IMouldType {

    private String flag;  //
    private String message;  //
    private String total;  //
    private MouldList<ResultClassDetailsDiscussItemBean> list;     //  课程列表


    public MouldList<ResultClassDetailsDiscussItemBean> getList() {
        return list;
    }

    public void setList(MouldList<ResultClassDetailsDiscussItemBean> list) {
        this.list = list;
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

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }
}