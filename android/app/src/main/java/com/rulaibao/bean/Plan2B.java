package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

import java.util.ArrayList;

public class Plan2B implements IMouldType {
	private MouldList<Plan3B> list;
	private ArrayList<String> companyList;
	private String flag;
	private String message;
	private String checkStatus;

	public MouldList<Plan3B> getList() {
		return list;
	}

	public void setList(MouldList<Plan3B> list) {
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

	public ArrayList<String> getCompanyList() {
		return companyList;
	}

	public void setCompanyList(ArrayList<String> companyList) {
		this.companyList = companyList;
	}

	public String getCheckStatus() {
		return checkStatus;
	}

	public void setCheckStatus(String checkStatus) {
		this.checkStatus = checkStatus;
	}
}
