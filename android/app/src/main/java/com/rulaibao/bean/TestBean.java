package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;

// 首页
public class TestBean implements IMouldType {
	private String title;
	private String bid; // 公告id
	private String message; //
	private boolean flag;		//	是否已选


	public TestBean() {
	}

	public TestBean(String title, String bid, String message, boolean flag) {
		this.title = title;
		this.bid = bid;
		this.message = message;
		this.flag = flag;
	}

	public TestBean(String title) {
		this.title = title;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getBid() {
		return bid;
	}

	public void setBid(String bid) {
		this.bid = bid;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public boolean isFlag() {
		return flag;
	}

	public void setFlag(boolean flag) {
		this.flag = flag;
	}
}
