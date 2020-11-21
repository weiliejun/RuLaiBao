package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *    待发佣金列表 实体类
 * Created by hong on 2018/11/08.
 */

public class CommissionList1B implements IMouldType {

    private MouldList<CommissionList2B> commisionList; // 保单列表
    private String flag;
    private String msg;
    private String message;

    public MouldList<CommissionList2B> getCommisionList() {
        return commisionList;
    }

    public void setCommisionList(MouldList<CommissionList2B> commisionList) {
        this.commisionList = commisionList;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
