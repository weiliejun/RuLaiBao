//
//  MyBankCardModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyBankCardModel : NSObject

/** id */
@property (nonatomic,copy) NSString *bankCardId;
/** 所属银行 */
@property (nonatomic,copy) NSString *bank;
/** 开户行名称 */
@property (nonatomic,copy) NSString *bankName;
/** 开户行地址 */
@property (nonatomic,copy) NSString *bankAddress;
/** 银行卡号 */
@property (nonatomic,copy) NSString *bankcardNo;
/** 是否是工资卡（yes-是，no不是） */
@property (nonatomic,copy) NSString *isWageCard;


+ (instancetype)myBankCardModelWithDictionary:(NSDictionary *)KVCDic;

@end

NS_ASSUME_NONNULL_END
