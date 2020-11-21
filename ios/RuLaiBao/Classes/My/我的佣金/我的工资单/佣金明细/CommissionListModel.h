//
//  CommissionListModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/21.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommissionListModel : NSObject
/** 交易记录id */
@property (nonatomic, copy) NSString *commissionListId;
/** 产品名称 */
@property (nonatomic, copy) NSString *productName;
/** 保单编号 */
@property (nonatomic, copy) NSString *orderCode;
/** 获得佣金 */
@property (nonatomic, copy) NSString *commissionGained;
/** 结佣日期 */
@property (nonatomic, copy) NSString *commissionTime;

+ (instancetype)commissionListModelWithDictionary:(NSDictionary *)KVCDic;

@end

NS_ASSUME_NONNULL_END
