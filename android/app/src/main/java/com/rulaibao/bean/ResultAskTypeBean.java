package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 问答类型
public class ResultAskTypeBean implements IMouldType {


	private String total;
	private String flag;
	private String message;
	private MouldList<ResultAskTypeItemBean> list;


    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
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

    public MouldList<ResultAskTypeItemBean> getList() {
        return list;
    }

    public void setList(MouldList<ResultAskTypeItemBean> list) {
        this.list = list;
    }
}
