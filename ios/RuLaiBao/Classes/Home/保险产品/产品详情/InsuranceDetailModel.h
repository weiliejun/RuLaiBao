//
//  InsuranceDetailModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/3.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsuranceDetailModel : NSObject
/** 认证状态 */
@property (nonatomic,copy) NSString *checkStatus;
/** 编号 */
@property (nonatomic,copy) NSString *Id;
/** 封面 */
@property (nonatomic,copy) NSString *logo;
/** 产品名称 */
@property (nonatomic,copy) NSString *name;
/** 险种类别 */
@property (nonatomic,copy) NSString *category;
/** longTermInsurance:长期险;shortTermInsurance:短期险*/
@property (nonatomic,copy)NSString *type;
/** companyName */
@property (nonatomic,copy) NSString *companyName;
/** message */
@property (nonatomic,copy) NSString *message;

/** 是否为收藏（valid收藏/ invalid未收藏） */
@property (nonatomic,copy) NSString *collectionDataStatus;
/** 收藏id */
@property (nonatomic,copy)NSString *collectionId;

/** 投保年龄 */
@property (nonatomic,copy) NSString *insuranceAge;
/** 承保职业 */
@property (nonatomic,copy)NSString *insuranceOccupation;
/** 保障期限 */
@property (nonatomic,copy)NSString *insurancePeriod;
/** 限购份数 */
@property (nonatomic,copy) NSString *purchaseNumber;
/** 推荐说明 */
@property (nonatomic,copy) NSString *recommendations;

/** 保障责任 */
@property (nonatomic,copy)NSString *securityResponsibility;
/** 投保须知 */
@property (nonatomic,copy) NSString *coverNotes;
/** 条款资料 */
@property (nonatomic,copy) NSString *dataTerms;
/** 理赔流程 */
@property (nonatomic,copy) NSString *claimProcess;
/** 常见问题 */
@property (nonatomic,copy)NSString *commonProblem;

/** 保低保费 */
@property (nonatomic,copy) NSString *minimumPremium;
/** 推广费 */
@property (nonatomic,copy)NSString *promotionMoney;
/** 计划书 */
@property (nonatomic,copy)NSString *prospectus;
/** 购买链接 */
@property (nonatomic,copy) NSString *productLink;

/** 预约id 当预约id为空时 产品未预约 */
@property (nonatomic,copy) NSString *appointmentStatus;


+ (instancetype)insuranceDetailModelWithDictionary:(NSDictionary *)KVCDic;


@end
