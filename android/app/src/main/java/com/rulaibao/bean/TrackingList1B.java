package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *    交易记录 实体类
 * Created by junde on 2018/4/16.
 */

public class TrackingList1B implements IMouldType {

    private String totalCommission; // 累计佣金（元）
    private String total; // 交易总条数（新增字段）
    private MouldList<TrackingList2B> recordList; // 交易记录
    private String flag;
    private String msg;

    public String getTotalCommission() {
        return totalCommission;
    }

    public void setTotalCommission(String totalCommission) {
        this.totalCommission = totalCommission;
    }

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }

    public MouldList<TrackingList2B> getRecordList() {
        return recordList;
    }

    public void setRecordList(MouldList<TrackingList2B> recordList) {
        this.recordList = recordList;
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
