package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

public class PolicyPlan2B implements IMouldType {
	private MouldList<PolicyPlan3B> list;
	private String flag;
	private String message;

	public MouldList<PolicyPlan3B> getList() {
		return list;
	}

	public void setList(MouldList<PolicyPlan3B> list) {
		this.list = list;
	}

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
