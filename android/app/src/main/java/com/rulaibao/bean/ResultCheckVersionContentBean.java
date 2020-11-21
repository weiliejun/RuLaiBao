package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;

public class ResultCheckVersionContentBean implements IMouldType {
	private String version;
	private String url;

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

}
