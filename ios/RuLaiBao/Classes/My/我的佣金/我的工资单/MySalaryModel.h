//
//  MySalaryModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/21.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MySalaryModel : NSObject
/** id */
@property (nonatomic,copy) NSString *mySalaryId;
/** 总佣金 */
@property (nonatomic,copy) NSString *totalCommission;
/** 净收入 */
@property (nonatomic,copy) NSString *totalIncome;
/** 扣税 */
@property (nonatomic,copy) NSString *totalTax;
/** 工资月份 */
@property (nonatomic,copy) NSString *wageMonth;

+ (instancetype)mySalaryModelWithDictionary:(NSDictionary *)KVCDic;

@end

NS_ASSUME_NONNULL_END
