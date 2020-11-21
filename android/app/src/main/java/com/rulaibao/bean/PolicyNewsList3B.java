package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

/**
 * Created by junde on 2018/4/21.
 */

public class PolicyNewsList3B implements IMouldType {

    private String productName;       // 产品名称
    private String date;     //  日期
    private String status;     //  状态


    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
