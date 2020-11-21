//
//  ReplyModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/28.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 回复列表Model
 */
@interface ReplyModel : NSObject

/** 此条回复的id */
@property(nonatomic,copy)NSString *rid;
/** 回复内容 */
@property(nonatomic,copy)NSString *replyContent;
/** 回复时间 */
@property(nonatomic,copy)NSString *replyTime;
/** 回复人id */
@property(nonatomic,copy)NSString *replyId;
/** 回复人姓名 */
@property(nonatomic,copy)NSString *replyName;
/** 被回复人id */
@property(nonatomic,copy)NSString *replyToId;
/** 被回复人姓名 */
@property(nonatomic,copy)NSString *replyToName;
-(instancetype)initReplyModelWithDic:(NSDictionary *)dic;
@end
