package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class OK2B implements IMouldType {
	private String flag;
	private String message;

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
