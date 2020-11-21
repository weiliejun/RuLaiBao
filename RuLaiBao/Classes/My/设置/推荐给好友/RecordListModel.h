//
//  RecordListModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/27.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordListModel : NSObject
/** 姓名 */
@property (nonatomic,copy)NSString *realName;
/** 手机号 */
@property (nonatomic,copy)NSString *mobile;
/** 认证状态 */
@property (nonatomic,copy)NSString *checkStatus;


+ (instancetype)recordListModelWithDictionary:(NSDictionary *)KVCDic;


@end
