package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 研修首页 热门回答

public class ResultHotAskBean implements IMouldType {

    private String flag;
    private MouldList<ResultHotAskItemBean> list;
    private String message;
    private String total;

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public MouldList<ResultHotAskItemBean> getList() {
        return list;
    }

    public void setList(MouldList<ResultHotAskItemBean> list) {
        this.list = list;
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