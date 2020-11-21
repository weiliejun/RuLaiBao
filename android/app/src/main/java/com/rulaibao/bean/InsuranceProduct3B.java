package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class InsuranceProduct3B implements IMouldType {
    private String title; //
    private String name; //
    private String price; //
    private String rate; //

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getRate() {
        return rate;
    }

    public void setRate(String rate) {
        this.rate = rate;
    }
}

