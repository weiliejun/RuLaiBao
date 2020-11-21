package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class HomeViewPager2B implements IMouldType {
    private String id;
    private String name;
    private String recommendations;
    private String promotionMoney;
    private String recommenCover;
    private String checkStatus; //认证状态

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRecommendations() {
        return recommendations;
    }

    public void setRecommendations(String recommendations) {
        this.recommendations = recommendations;
    }

    public String getCheckStatus() {
        return checkStatus;
    }

    public void setCheckStatus(String checkStatus) {
        this.checkStatus = checkStatus;
    }

    public String getPromotionMoney() {
        return promotionMoney;
    }

    public void setPromotionMoney(String promotionMoney) {
        this.promotionMoney = promotionMoney;
    }

    public String getRecommenCover() {
        return recommenCover;
    }

    public void setRecommenCover(String recommenCover) {
        this.recommenCover = recommenCover;
    }
}