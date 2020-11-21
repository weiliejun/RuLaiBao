package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

/**
 *    推荐记录 实体类
 * Created by junde on 2018/4/16.
 */

public class RecommendRecordList2B implements IMouldType {

    private String mobile; // 推荐的人的手机号
    private String realName; // 推荐的人的姓名
    private String checkStatus; // 认证状态

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getCheckStatus() {
        return checkStatus;
    }

    public void setCheckStatus(String checkStatus) {
        this.checkStatus = checkStatus;
    }
}
