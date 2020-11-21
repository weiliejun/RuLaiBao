package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;

public class CheckVersionBean implements IMouldType {
	private String type;

	public CheckVersionBean(String type) {
		setType(type);
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

}
