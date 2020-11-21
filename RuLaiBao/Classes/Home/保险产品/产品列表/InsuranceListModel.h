//
//  InsuranceListModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/3.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsuranceListModel : NSObject
/** 认证状态 */
@property (nonatomic,copy) NSString *checkStatus;
/** id */
@property (nonatomic,copy) NSString *Id;
/** 保险公司名称 */
@property (nonatomic,copy) NSString *companyName;
/** 保险名称 */
@property (nonatomic,copy) NSString *name;
/** 保低保费 */
@property (nonatomic,copy) NSString *minimumPremium;
/** 推广费 (0到100，不加百分号) */
@property (nonatomic,copy) NSString *promotionMoney;
/** 推荐说明 */
@property (nonatomic,copy) NSString *recommendations;


+ (instancetype)insuranceListModelWithDictionary:(NSDictionary *)KVCDic;

@end
