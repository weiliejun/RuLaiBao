package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *  工资单列表 实体类
 */
public class PayrollList1B implements IMouldType {


	private MouldList<PayrollList2B> newList;
	private String total;
	private String flag;
	private String message;

    public MouldList<PayrollList2B> getNewList() {
        return newList;
    }

    public void setNewList(MouldList<PayrollList2B> newList) {
        this.newList = newList;
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
