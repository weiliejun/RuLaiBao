package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class InsuranceDetail1B implements IMouldType {

    private String logo;
    private String collectionDataStatus; // 是否为收藏（valid收藏/ invalid未收藏）
    private String collectionId; // 收藏id
    private String appointmentStatus;
    private String insuranceAge; // 投保年龄
    private String insuranceOccupation; // 承保职业
    private String insurancePeriod; // 保障期限
    private String purchaseNumber; // 限购份数
    private String securityResponsibility; // 保障责任
    private String dataTerms; // 条款资料
    private String coverNotes; // 投保须知
    private String claimProcess; // 理赔流程
    private String commonProblem; // 常见问题


    private String id; // 编号
    private String type; // longTermInsurance:长期险;   shortTermInsurance:短期险
    private String name; // 产品名称
    private String minimumPremium; // 最低保费
    private String recommendations; // 推荐说明
    private String checkStatus; // 认证状态
    private String prospectus; // 计划书
    private String productLink; // 购买链接
    private String companyName; // 保险公司名称
    private String category; // 险种类别（accident:意外险;criticalIllness:重疾险;annuity:年金险;medical:医疗险;property:家财险;wholeLife:终身寿险;enterpriseGroup:企业团体)
    private String prospectusStatus; // 判断有无计划书（yes:有，no:无）
    private String productStatus; //产品状态(normal: 正常  delete删除; down: 下架)
    private String attachmentPath;
    private String promotionMoney; // 推广费
    private String promotionMoney2;
    private String promotionMoney3;
    private String promotionMoney4;
    private String promotionMoney5;
    private String shareLinkStatus; // 判断是否显示 分享链接 按钮
    private String shareLink; //分享链接

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getCollectionDataStatus() {
        return collectionDataStatus;
    }

    public void setCollectionDataStatus(String collectionDataStatus) {
        this.collectionDataStatus = collectionDataStatus;
    }

    public String getCollectionId() {
        return collectionId;
    }

    public void setCollectionId(String collectionId) {
        this.collectionId = collectionId;
    }

    public String getInsuranceAge() {
        return insuranceAge;
    }

    public void setInsuranceAge(String insuranceAge) {
        this.insuranceAge = insuranceAge;
    }

    public String getInsuranceOccupation() {
        return insuranceOccupation;
    }

    public void setInsuranceOccupation(String insuranceOccupation) {
        this.insuranceOccupation = insuranceOccupation;
    }

    public String getInsurancePeriod() {
        return insurancePeriod;
    }

    public void setInsurancePeriod(String insurancePeriod) {
        this.insurancePeriod = insurancePeriod;
    }

    public String getPurchaseNumber() {
        return purchaseNumber;
    }

    public void setPurchaseNumber(String purchaseNumber) {
        this.purchaseNumber = purchaseNumber;
    }

    public String getRecommendations() {
        return recommendations;
    }

    public void setRecommendations(String recommendations) {
        this.recommendations = recommendations;
    }

    public String getSecurityResponsibility() {
        return securityResponsibility;
    }

    public void setSecurityResponsibility(String securityResponsibility) {
        this.securityResponsibility = securityResponsibility;
    }

    public String getCoverNotes() {
        return coverNotes;
    }

    public void setCoverNotes(String coverNotes) {
        this.coverNotes = coverNotes;
    }

    public String getDataTerms() {
        return dataTerms;
    }

    public void setDataTerms(String dataTerms) {
        this.dataTerms = dataTerms;
    }

    public String getClaimProcess() {
        return claimProcess;
    }

    public void setClaimProcess(String claimProcess) {
        this.claimProcess = claimProcess;
    }

    public String getCommonProblem() {
        return commonProblem;
    }

    public void setCommonProblem(String commonProblem) {
        this.commonProblem = commonProblem;
    }

    public String getMinimumPremium() {
        return minimumPremium;
    }

    public void setMinimumPremium(String minimumPremium) {
        this.minimumPremium = minimumPremium;
    }

    public String getPromotionMoney() {
        return promotionMoney;
    }

    public void setPromotionMoney(String promotionMoney) {
        this.promotionMoney = promotionMoney;
    }

    public String getProspectus() {
        return prospectus;
    }

    public void setProspectus(String prospectus) {
        this.prospectus = prospectus;
    }

    public String getProductLink() {
        return productLink;
    }

    public void setProductLink(String productLink) {
        this.productLink = productLink;
    }

    public String getAppointmentStatus() {
        return appointmentStatus;
    }

    public void setAppointmentStatus(String appointmentStatus) {
        this.appointmentStatus = appointmentStatus;
    }

    public String getCheckStatus() {
        return checkStatus;
    }

    public void setCheckStatus(String checkStatus) {
        this.checkStatus = checkStatus;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getProspectusStatus() {
        return prospectusStatus;
    }

    public void setProspectusStatus(String prospectusStatus) {
        this.prospectusStatus = prospectusStatus;
    }

    public String getProductStatus() {
        return productStatus;
    }

    public void setProductStatus(String productStatus) {
        this.productStatus = productStatus;
    }

    public String getAttachmentPath() {
        return attachmentPath;
    }

    public void setAttachmentPath(String attachmentPath) {
        this.attachmentPath = attachmentPath;
    }

    public String getPromotionMoney2() {
        return promotionMoney2;
    }

    public void setPromotionMoney2(String promotionMoney2) {
        this.promotionMoney2 = promotionMoney2;
    }

    public String getPromotionMoney3() {
        return promotionMoney3;
    }

    public void setPromotionMoney3(String promotionMoney3) {
        this.promotionMoney3 = promotionMoney3;
    }

    public String getPromotionMoney4() {
        return promotionMoney4;
    }

    public void setPromotionMoney4(String promotionMoney4) {
        this.promotionMoney4 = promotionMoney4;
    }

    public String getPromotionMoney5() {
        return promotionMoney5;
    }

    public void setPromotionMoney5(String promotionMoney5) {
        this.promotionMoney5 = promotionMoney5;
    }

    public String getShareLinkStatus() {
        return shareLinkStatus;
    }

    public void setShareLinkStatus(String shareLinkStatus) {
        this.shareLinkStatus = shareLinkStatus;
    }

    public String getShareLink() {
        return shareLink;
    }

    public void setShareLink(String shareLink) {
        this.shareLink = shareLink;
    }
}