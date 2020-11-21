//
//  MyListModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/25.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyListModel : NSObject
/** 认证状态 */
@property (nonatomic,copy) NSString *checkStatus;
/** 头像 */
@property (nonatomic,copy) NSString *headPhoto;
/** 提醒数量 */
@property (nonatomic,copy) NSString *insuranceWarning;
/** 手机号 */
@property (nonatomic,copy) NSString *mobile;
/** 真实姓名 */
@property (nonatomic,copy) NSString *realName;
/** 推荐码 */
@property (nonatomic,copy)NSString *recommendCode;
/** 累计佣金 */
@property (nonatomic,copy)NSString *totalCommission;
/** 未读消息数量 */
@property (nonatomic,copy)NSString *messageTotal;

+ (instancetype)myListModelWithDictionary:(NSDictionary *)KVCDic;

@end
