package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;


// 推荐app给好友
public class Recommend1B implements IMouldType {
	private String recommendCode;// 推荐码
	private String total; // 推荐朋友总数

    public String getRecommendCode() {
        return recommendCode;
    }

    public void setRecommendCode(String recommendCode) {
        this.recommendCode = recommendCode;
    }

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }
}
