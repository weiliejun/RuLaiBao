package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *    佣金明细列表 实体类
 * Created by hong on 2018/11/13.
 */

public class CommissionDetailList1B implements IMouldType {

    private MouldList<CommissionDetailList2B> list; // 保单列表
    private String flag;
    private String msg;
    private String message;

    public MouldList<CommissionDetailList2B> getList() {
        return list;
    }

    public void setList(MouldList<CommissionDetailList2B> list) {
        this.list = list;
    }
}
