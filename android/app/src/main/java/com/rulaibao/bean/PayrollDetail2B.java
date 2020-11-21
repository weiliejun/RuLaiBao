package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;

/**
 *  工资单详情 实体类
 */
public class PayrollDetail2B implements IMouldType {
    private String id; //
    private String status; // 发放状态
    private String valueaddedTax; // 增值税
    private String individualTax; // 个人所得税
    private String additionalTax; // 附加税
    private String commission; // 佣金
    private String income; // 到账金额
    private String bankcardNo; // 银行卡号

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getValueaddedTax() {
        return valueaddedTax;
    }

    public void setValueaddedTax(String valueaddedTax) {
        this.valueaddedTax = valueaddedTax;
    }

    public String getIndividualTax() {
        return individualTax;
    }

    public void setIndividualTax(String individualTax) {
        this.individualTax = individualTax;
    }

    public String getAdditionalTax() {
        return additionalTax;
    }

    public void setAdditionalTax(String additionalTax) {
        this.additionalTax = additionalTax;
    }

    public String getCommission() {
        return commission;
    }

    public void setCommission(String commission) {
        this.commission = commission;
    }

    public String getIncome() {
        return income;
    }

    public void setIncome(String income) {
        this.income = income;
    }

    public String getBankcardNo() {
        return bankcardNo;
    }

    public void setBankcardNo(String bankcardNo) {
        this.bankcardNo = bankcardNo;
    }
}