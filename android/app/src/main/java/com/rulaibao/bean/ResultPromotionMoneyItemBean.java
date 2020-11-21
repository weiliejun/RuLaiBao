package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class ResultPromotionMoneyItemBean implements IMouldType{

    private String promotionMoney;        //  推广费

    public String getPromotionMoney() {
        return promotionMoney;
    }

    public void setPromotionMoney(String promotionMoney) {
        this.promotionMoney = promotionMoney;
    }
}
