package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *    预约列表 实体类
 * Created by junde on 2018/4/19.
 */

public class PolicyBookingList1B implements IMouldType {

    private int totalCount; // 产品预约总数  confirmed：表示已确认；confirming：待确认 refuse：已驳回；canceled：已取消
    private String confirmedCount; // 已确认数量
    private String confirmingCount; // 待确认数量
    private String refuseCount; // 已驳回数量
    private String canceledCount; // 已取消数量
    private MouldList<PolicyBookingList2B> list; // 预约列表
    private String flag;
    private String msg;

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public String getConfirmedCount() {
        return confirmedCount;
    }

    public void setConfirmedCount(String confirmedCount) {
        this.confirmedCount = confirmedCount;
    }

    public String getConfirmingCount() {
        return confirmingCount;
    }

    public void setConfirmingCount(String confirmingCount) {
        this.confirmingCount = confirmingCount;
    }

    public String getRefuseCount() {
        return refuseCount;
    }

    public void setRefuseCount(String refuseCount) {
        this.refuseCount = refuseCount;
    }

    public String getCanceledCount() {
        return canceledCount;
    }

    public void setCanceledCount(String canceledCount) {
        this.canceledCount = canceledCount;
    }

    public MouldList<PolicyBookingList2B> getList() {
        return list;
    }

    public void setList(MouldList<PolicyBookingList2B> list) {
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
