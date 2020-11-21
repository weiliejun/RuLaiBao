package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 * Created by junde on 2018/4/21.
 */

public class CommissionNewsList1B implements IMouldType {

    private MouldList<CommissionNewsList2B> list; // 消息列表
    private String total;   //  总数
    private String flag;
    private String msg;

    public MouldList<CommissionNewsList2B> getList() {
        return list;
    }

    public void setList(MouldList<CommissionNewsList2B> list) {
        this.list = list;
    }

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }
}
