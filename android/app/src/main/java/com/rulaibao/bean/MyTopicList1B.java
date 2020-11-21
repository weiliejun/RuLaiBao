package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 * Created by junde on 2018/5/4.
 */

public class MyTopicList1B implements IMouldType {

    private String total; // 总数
    private MouldList<MyTopicList2B> list; // 话题列表
    private String flag;
    private String msg;

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }

    public MouldList<MyTopicList2B> getList() {
        return list;
    }

    public void setList(MouldList<MyTopicList2B> list) {
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
}
