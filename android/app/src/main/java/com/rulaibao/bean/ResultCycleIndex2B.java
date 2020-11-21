package com.rulaibao.bean;


import com.rulaibao.network.types.IMouldType;

// 首页、发现轮播图共用 (用于接收后台返回图片地址)
public class ResultCycleIndex2B implements IMouldType {
    private String picture; // 图片地址
    private String linkType; //  url:h5页面跳转；appProject:海外项目详情；appHouse:房源详情； appVideo:路演视频详情; appInvestGuide:投资指南; none:无跳转;
    private String targetUrl; // url时是链接，其他情况为相关id

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public String getLinkType() {
        return linkType;
    }

    public void setLinkType(String linkType) {
        this.linkType = linkType;
    }

    public String getTargetUrl() {
        return targetUrl;
    }

    public void setTargetUrl(String targetUrl) {
        this.targetUrl = targetUrl;
    }
}