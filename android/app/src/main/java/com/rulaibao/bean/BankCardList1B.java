package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *    银行卡列表 实体类
 * Created by hong on 2018/11/21.
 */

public class BankCardList1B implements IMouldType {

    private MouldList<BankCardList2B> userBankCardList; // 保单列表
    private String total;
    private String flag;
    private String msg;
    private String message;

    public MouldList<BankCardList2B> getUserBankCardList() {
        return userBankCardList;
    }

    public void setUserBankCardList(MouldList<BankCardList2B> userBankCardList) {
        this.userBankCardList = userBankCardList;
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
