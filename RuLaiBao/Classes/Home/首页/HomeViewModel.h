//
//  HomeViewModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/28.
//  Copyright © 2018年 junde. All rights reserved.
//
/** 热销 */
#import <Foundation/Foundation.h>

@interface HomeViewModel : NSObject
/** 认证状态 */
@property (nonatomic,copy) NSString *checkStatus;
/** 公司名称 */
@property (nonatomic,copy) NSString *companyName;
/** Id */
@property (nonatomic,copy) NSString *Id;
/** 最低保费 */
@property (nonatomic,copy) NSString *minimumPremium;
/** 产品名称 */
@property (nonatomic,copy) NSString *name;
/** 推广费 */
@property (nonatomic,copy) NSString *promotionMoney;
/** 推荐语 */
@property (nonatomic,copy)NSString *recommendations;

+ (instancetype)homeViewModelWithDictionary:(NSDictionary *)KVCDic;


@end
