package com.rulaibao.bean;

import com.rulaibao.network.types.IMouldType;

/**
 *    佣金明细列表 实体类
 * Created by hong on 2018/11/13.
 */

public class CommissionDetailList2B implements IMouldType {

    private String orderId; // 保单ID
    private String insuranceName; // 保险名称
    private String companyLogo; // 保险LOGO地址
    private String insurancPeremiums; // 已交保费
    private String status; // 保单状态
    private String customerName; // 客户姓名
    private String paymentedPremiums; // 已交保费
    private String insurancePeriod; // 保险期限

}
