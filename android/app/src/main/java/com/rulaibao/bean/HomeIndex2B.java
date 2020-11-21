package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

// 首页、发现轮播图共用
public class HomeIndex2B implements IMouldType {
	private MouldList<CycleIndex2B> advertiseList;//轮播图
	private MouldList<Bulletin2B> bulletinlist;//公告
	private MouldList<InsuranceProduct2B> sellList;//热销列表
	private MouldList<HomeViewPager2B> recommendlist;//重磅推荐
	private String checkStatus;

	public MouldList<CycleIndex2B> getAdvertiseList() {
		return advertiseList;
	}

	public void setAdvertiseList(MouldList<CycleIndex2B> advertiseList) {
		this.advertiseList = advertiseList;
	}

	public MouldList<InsuranceProduct2B> getSellList() {
		return sellList;
	}

	public void setSellList(MouldList<InsuranceProduct2B> sellList) {
		this.sellList = sellList;
	}

	public MouldList<HomeViewPager2B> getRecommendlist() {
		return recommendlist;
	}

	public void setRecommendlist(MouldList<HomeViewPager2B> recommendlist) {
		this.recommendlist = recommendlist;
	}

	public MouldList<Bulletin2B> getBulletinlist() {
		return bulletinlist;
	}

	public void setBulletinlist(MouldList<Bulletin2B> bulletinlist) {
		this.bulletinlist = bulletinlist;
	}

	public String getCheckStatus() {
		return checkStatus;
	}

	public void setCheckStatus(String checkStatus) {
		this.checkStatus = checkStatus;
	}
}
