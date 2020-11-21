package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

public class PolicyPlan3B implements IMouldType {
    private String orderId;
    private String insuranceName;
    private String companyLogo;
    private String status;
    private String customerName;
    private String paymentedPremiums;
    private String insurancePeriod;

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getInsuranceName() {
        return insuranceName;
    }

    public void setInsuranceName(String insuranceName) {
        this.insuranceName = insuranceName;
    }

    public String getCompanyLogo() {
        return companyLogo;
    }

    public void setCompanyLogo(String companyLogo) {
        this.companyLogo = companyLogo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPaymentedPremiums() {
        return paymentedPremiums;
    }

    public void setPaymentedPremiums(String paymentedPremiums) {
        this.paymentedPremiums = paymentedPremiums;
    }

    public String getInsurancePeriod() {
        return insurancePeriod;
    }

    public void setInsurancePeriod(String insurancePeriod) {
        this.insurancePeriod = insurancePeriod;
    }
}

