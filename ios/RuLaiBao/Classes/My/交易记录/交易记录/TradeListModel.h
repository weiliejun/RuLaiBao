//
//  TradeListModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/27.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeListModel : NSObject
/** 交易记录id */
@property (nonatomic,copy)NSString *Id;
/** 产品名称 */
@property (nonatomic,copy)NSString *productName;
/** 保单编号 */
@property (nonatomic,copy)NSString *orderCode;
/** 获得佣金 */
@property (nonatomic,copy)NSString *commissionGained;


+ (instancetype)tradeListModelWithDictionary:(NSDictionary *)KVCDic;


@end
