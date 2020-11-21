package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class CycleIndex2B implements IMouldType {
    private String picture; // 图片地址
    private String targetUrl; // url
    private String name;
    private String linkType;


    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public String getTargetUrl() {
        return targetUrl;
    }

    public void setTargetUrl(String targetUrl) {
        this.targetUrl = targetUrl;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLinkType() {
        return linkType;
    }

    public void setLinkType(String linkType) {
        this.linkType = linkType;
    }
}