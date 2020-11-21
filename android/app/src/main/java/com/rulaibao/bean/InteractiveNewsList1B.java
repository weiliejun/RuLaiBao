package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *  互动消息 实体类
 * Created by junde on 2018/5/10.
 */

public class InteractiveNewsList1B implements IMouldType {

    private MouldList<InteractiveNewsList2B> list;
    private String total; //  总数
    private String flag;
    private String message;

    public MouldList<InteractiveNewsList2B> getList() {
        return list;
    }

    public void setList(MouldList<InteractiveNewsList2B> list) {
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
