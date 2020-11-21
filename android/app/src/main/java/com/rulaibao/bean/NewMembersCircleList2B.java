package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

/**
 *  圈子新成员 实体类
 * Created by junde on 2018/4/24.
 */

public class NewMembersCircleList2B implements IMouldType {

    private String applyId; //  消息id
    private String applyUserId; // 申请人id
    private String applyCircleName; // 申请加入圈子的名称
    private String applyCircleId; // 申请加入圈子的id
    private String auditStatus; // 审核状态（submit:待加入；agree:已加入；refuse:已拒绝）
    private String applyUserName; // 申请人名字
    private String applyPhoto;  //  申请人头像

    public String getApplyId() {
        return applyId;
    }

    public void setApplyId(String applyId) {
        this.applyId = applyId;
    }

    public String getApplyUserId() {
        return applyUserId;
    }

    public void setApplyUserId(String applyUserId) {
        this.applyUserId = applyUserId;
    }

    public String getApplyCircleName() {
        return applyCircleName;
    }

    public void setApplyCircleName(String applyCircleName) {
        this.applyCircleName = applyCircleName;
    }

    public String getApplyCircleId() {
        return applyCircleId;
    }

    public void setApplyCircleId(String applyCircleId) {
        this.applyCircleId = applyCircleId;
    }

    public String getAuditStatus() {
        return auditStatus;
    }

    public void setAuditStatus(String auditStatus) {
        this.auditStatus = auditStatus;
    }

    public String getApplyUserName() {
        return applyUserName;
    }

    public void setApplyUserName(String applyUserName) {
        this.applyUserName = applyUserName;
    }

    public String getApplyPhoto() {
        return applyPhoto;
    }

    public void setApplyPhoto(String applyPhoto) {
        this.applyPhoto = applyPhoto;
    }
}
