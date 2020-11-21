//
//  PlanModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanModel : NSObject
/** 保险LOGO地址 */
@property (nonatomic,copy)NSString *companyLogo;
/** 客户姓名 */
@property (nonatomic,copy)NSString *customerName;
/** 保险名称 */
@property (nonatomic,copy)NSString *insuranceName;
/** 保险期限 */
@property (nonatomic,copy)NSString *insurancePeriod;
/** 保单ID */
@property (nonatomic,copy)NSString *orderId;
/** 已交保费 */
@property (nonatomic,copy)NSString *paymentedPremiums;
/** 保单状态 */
@property (nonatomic,copy)NSString *status;


+ (instancetype)planListModelWithDictionary:(NSDictionary *)KVCDic;

@end
