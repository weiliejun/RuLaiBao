package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *    我的收藏列表 实体类
 * Created by junde on 2018/5/7.
 */

public class MyCollectionList1B implements IMouldType {

    private MouldList<MyCollectionList2B> list; // 提问列表
    private String flag;
    private String msg;

    public MouldList<MyCollectionList2B> getList() {
        return list;
    }

    public void setList(MouldList<MyCollectionList2B> list) {
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
