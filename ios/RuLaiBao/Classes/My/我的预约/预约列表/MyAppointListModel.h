//
//  MyAppointListModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/5.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAppointListModel : NSObject
/** 预约Id */
@property (nonatomic,copy) NSString *Id;
/** 审核状态 */
@property (nonatomic,copy) NSString *statusStr;
/** 保险金额 */
@property (nonatomic,copy) NSString *insuranceAmount;
/** 预约产品名称 */
@property (nonatomic,copy) NSString *productName;

+ (instancetype)appointListModelWithDictionary:(NSDictionary *)KVCDic;

@end
