//
//  NewsTypeModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/8.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsTypeModel : NSObject
/*!
 {
     busiPriv = 18050811452863621362;
     busiType = commission;
     content = "+1.00";
     createTime = "2018-05-08 11:45:28";
     id = 18050811452868061153;
     status = unread;
     topic = "\U4f63\U91d1\U6536\U76ca";
 },
 */

/** 公告id */
@property (nonatomic, copy) NSString *newsId;
/** 消息名称 */
@property (nonatomic, copy) NSString *topic;
/** 状态：unread未读，read 已读 */
@property (nonatomic, copy) NSString *status;
/** 创建时间 */
@property (nonatomic, copy) NSString *createTime;
/** 消息内容 */
@property (nonatomic, copy) NSString *content;
/** 消息业务类型 */
@property (nonatomic, copy) NSString *busiType;
/** 存放佣金保单产品id  */
@property (nonatomic, copy) NSString *busiPriv;

@end

