package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 * Created by junde on 2018/5/5.
 */

public class PlatformBulletinList1B implements IMouldType {

    private MouldList<PlatformBulletinList2B> list; // 公告列表
    private String total;     //  总数

    public MouldList<PlatformBulletinList2B> getList() {
        return list;
    }

    public void setList(MouldList<PlatformBulletinList2B> list) {
        this.list = list;
    }

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }
}
