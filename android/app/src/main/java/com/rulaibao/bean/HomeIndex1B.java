package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

// 首页
public class HomeIndex1B implements IMouldType {
	private String check;
	private String code;
	private HomeIndex2B data;
	private String msg;

	public String getCheck() {
		return check;
	}

	public void setCheck(String check) {
		this.check = check;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public HomeIndex2B getData() {
		return data;
	}

	public void setData(HomeIndex2B data) {
		this.data = data;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}
}
