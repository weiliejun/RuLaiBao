package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;

/**
 *  我的佣金
 */
public class MyCommission2B implements IMouldType {
    private String totalCommission; // 累计佣金（0.00）
    private String unCommissioned; // 待发佣金（0.00）
    private String commissioned; // 已发佣金（0.00）

    public String getTotalCommission() {
        return totalCommission;
    }

    public void setTotalCommission(String totalCommission) {
        this.totalCommission = totalCommission;
    }

    public String getUnCommissioned() {
        return unCommissioned;
    }

    public void setUnCommissioned(String unCommissioned) {
        this.unCommissioned = unCommissioned;
    }

    public String getCommissioned() {
        return commissioned;
    }

    public void setCommissioned(String commissioned) {
        this.commissioned = commissioned;
    }
}