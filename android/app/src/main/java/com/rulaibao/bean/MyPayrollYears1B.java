package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

import java.util.List;

/**
 *  我的资单 年份
 */
public class MyPayrollYears1B implements IMouldType {

	private List wageYears;

    public List getWageYears() {
        return wageYears;
    }

    public void setWageYears(List wageYears) {
        this.wageYears = wageYears;
    }
}
