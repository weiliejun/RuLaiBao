package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *    续保提醒列表 实体类
 * Created by junde on 2018/5/3.
 */

public class RenewalReminderList1B implements IMouldType {

    private MouldList<RenewalReminderList2B> list; // 提醒列表
    private String flag;
    private String msg;
    private String message; // 提示信息

    public MouldList<RenewalReminderList2B> getList() {
        return list;
    }

    public void setList(MouldList<RenewalReminderList2B> list) {
        this.list = list;
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
