package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *  工资单列表 实体类
 */
public class PayrollList2B implements IMouldType {

	private String id; // 工资
	private String wageMonth; // 工资月份
	private String totalTax;  // 扣税
	private String totalCommission; // 总佣金
	private String totalIncome; // 净收入

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getWageMonth() {
		return wageMonth;
	}

	public void setWageMonth(String wageMonth) {
		this.wageMonth = wageMonth;
	}

	public String getTotalTax() {
		return totalTax;
	}

	public void setTotalTax(String totalTax) {
		this.totalTax = totalTax;
	}

	public String getTotalCommission() {
		return totalCommission;
	}

	public void setTotalCommission(String totalCommission) {
		this.totalCommission = totalCommission;
	}

	public String getTotalIncome() {
		return totalIncome;
	}

	public void setTotalIncome(String totalIncome) {
		this.totalIncome = totalIncome;
	}
}
