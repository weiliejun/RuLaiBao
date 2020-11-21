//
//  UnpayCommissionModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/20.
//  Copyright © 2018年 junde. All rights reserved.
//

/**
 * 已发佣金和待发佣金共用
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnpayCommissionModel : NSObject
/** 保单id */
@property (nonatomic, copy) NSString *orderId;
/** 佣金id */
@property (nonatomic, copy) NSString *commissionId;
/** 产品id */
@property (nonatomic, copy) NSString *productId;
/** 产品名称 */
@property (nonatomic, copy) NSString *productName;
/** 用户ID */
@property (nonatomic, copy) NSString *userId;
/** 用户名称 */
@property (nonatomic, copy) NSString *userName;
/** 保险LOGO地址 */
@property (nonatomic, copy) NSString *companyLogo;
/** 已交保费 */
@property (nonatomic, copy) NSString *paymentedPremiums;
/** 保险期限 */
@property (nonatomic, copy) NSString *insurancePeriod;

+ (instancetype)unpayCommissionModelWithDictionary:(NSDictionary *)KVCDic;

@end

NS_ASSUME_NONNULL_END
