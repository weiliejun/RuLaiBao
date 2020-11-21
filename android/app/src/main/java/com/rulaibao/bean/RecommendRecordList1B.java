package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;
import com.rulaibao.network.types.MouldList;

/**
 *    推荐记录 实体类
 * Created by junde on 2018/4/16.
 */

public class RecommendRecordList1B implements IMouldType {

    private String total; // 推荐朋友总数
    private MouldList<RecommendRecordList2B> recommendList; // 推荐记录
    private String flag;
    private String msg;

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }

    public MouldList<RecommendRecordList2B> getRecommendList() {
        return recommendList;
    }

    public void setRecommendList(MouldList<RecommendRecordList2B> recommendList) {
        this.recommendList = recommendList;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
