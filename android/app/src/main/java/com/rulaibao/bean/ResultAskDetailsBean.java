package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 问答详情
public class ResultAskDetailsBean implements IMouldType {


	private String total;
	private String flag;
	private String message;
	private ResultAskDetailsItemBean appQuestion;
	private String code;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

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

    public ResultAskDetailsItemBean getAppQuestion() {
        return appQuestion;
    }

    public void setAppQuestion(ResultAskDetailsItemBean appQuestion) {
        this.appQuestion = appQuestion;
    }
}
