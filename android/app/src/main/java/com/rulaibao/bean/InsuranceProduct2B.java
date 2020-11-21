package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

public class InsuranceProduct2B implements IMouldType {
	private String id; //产品id
	private String name; //产品名称
	private String companyName; //公司名称
	private String minimumPremium; //最低保费
	private String recommendations; //推荐语
	private String promotionMoney; //推广费
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

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getMinimumPremium() {
		return minimumPremium;
	}

	public void setMinimumPremium(String minimumPremium) {
		this.minimumPremium = minimumPremium;
	}

	public String getRecommendations() {
		return recommendations;
	}

	public void setRecommendations(String recommendations) {
		this.recommendations = recommendations;
	}

	public String getPromotionMoney() {
		return promotionMoney;
	}

	public void setPromotionMoney(String promotionMoney) {
		this.promotionMoney = promotionMoney;
	}

	public String getCheckStatus() {
		return checkStatus;
	}

	public void setCheckStatus(String checkStatus) {
		this.checkStatus = checkStatus;
	}
}
