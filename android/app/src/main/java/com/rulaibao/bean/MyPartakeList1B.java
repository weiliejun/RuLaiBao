package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *    我参与的列表 实体类
 * Created by junde on 2018/4/21.
 */

public class MyPartakeList1B implements IMouldType {

    private String total; // 总数
    private MouldList<MyAskList2B> list; // 提问列表 (“我参与的”里面的提问请求的接口出参跟“我的提问”接口出参相同故在此共用这一层)
    private String flag;
    private String msg;

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }

    public MouldList<MyAskList2B> getList() {
        return list;
    }

    public void setList(MouldList<MyAskList2B> list) {
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
