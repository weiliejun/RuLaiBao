package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;

public class ResultRecommendInfoContentBean implements IMouldType {

	private String recommendCode; // 推荐码
	private String total; // 推荐朋友总数
	private String totalAmount; // 推荐奖励金额

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

	public String getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(String totalAmount) {
		this.totalAmount = totalAmount;
	}
}