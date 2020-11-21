package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *    保单记录 实体类
 * Created by junde on 2018/4/16.
 */

public class PolicyRecordList1B implements IMouldType {

    private String total; // Status条件下的总条数
    private String allTotal; // 保单列表中全部数量=待审核+已承保+问题件+回执签收
    private String initTotal; // 待审核
    private String payedTotal; // 已承保
    private String rejectedTotal; // 问题件
    private String receiptSignedTotal; // 回执签收
    private MouldList<PolicyRecordList2B> list; // 保单列表
    private String flag;
    private String msg;
    private String message;

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }

    public String getAllTotal() {
        return allTotal;
    }

    public void setAllTotal(String allTotal) {
        this.allTotal = allTotal;
    }

    public String getInitTotal() {
        return initTotal;
    }

    public void setInitTotal(String initTotal) {
        this.initTotal = initTotal;
    }

    public String getPayedTotal() {
        return payedTotal;
    }

    public void setPayedTotal(String payedTotal) {
        this.payedTotal = payedTotal;
    }

    public String getRejectedTotal() {
        return rejectedTotal;
    }

    public void setRejectedTotal(String rejectedTotal) {
        this.rejectedTotal = rejectedTotal;
    }

    public String getReceiptSignedTotal() {
        return receiptSignedTotal;
    }

    public void setReceiptSignedTotal(String receiptSignedTotal) {
        this.receiptSignedTotal = receiptSignedTotal;
    }

    public MouldList<PolicyRecordList2B> getList() {
        return list;
    }

    public void setList(MouldList<PolicyRecordList2B> list) {
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

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
