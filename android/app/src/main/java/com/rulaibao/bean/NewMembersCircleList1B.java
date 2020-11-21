package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *  圈子新成员 实体类
 * Created by junde on 2018/4/24.
 */

public class NewMembersCircleList1B implements IMouldType {

    private MouldList<NewMembersCircleList2B> list;
    private String total; //  总数
    private String flag;
    private String message;

    public MouldList<NewMembersCircleList2B> getList() {
        return list;
    }

    public void setList(MouldList<NewMembersCircleList2B> list) {
        this.list = list;
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
}
