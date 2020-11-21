//
//  NewsInterModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/11.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsInterModel : NSObject

/*!
 {
     createTime = "05-11 15:59";
     id = 18051115594762797800;
     isRead = yes;
     param1 = 18050911394290540824;
     param2 = "";
     replyContent = "\U56de\U590d\U6211\Uff1a\U55e8";
     replyName = "\U5c0f\U51af\U51af110";
     replyPhoto = "http://192.168.1.82:9091/upload/user/photo/18022227666660552139/headPhoto/smallPhoto.jpg";
     targetName = Yuan;
     themeContent = "\U8bc4\U8bba\Uff1a\U62a5\U9519\U4e86\U554a";
     type = topic;
 }
 **param1:跳转参数1(主字符串)
   param2:跳转参数2(详情接口如不需要则为空白字符串,主要是客户详情回复时使用)
 question：跳转到提问详情；
 answer：跳转到回答详情；
 topic：跳转到话题详情；
 course：跳转到课程详情；
 */
/** 互动消息id */
@property (nonatomic, copy) NSString *messageId;
/** 主参数传值 */
@property (nonatomic, copy) NSString *param1;
/** 辅助参数传值 */
@property (nonatomic, copy) NSString *param2;
/** 消息类型 */
@property (nonatomic, copy) NSString *messageType;
/** 创建时间 */
@property (nonatomic, copy) NSString *createTime;
/** 已读状态（yes:已读；no:未读） */
@property (nonatomic, copy) NSString *isRead;
/** 被回复的主题内容 */
@property (nonatomic, copy) NSString *themeContent;
/** 回复内容 */
@property (nonatomic, copy) NSString *replyContent;
/** 回复人头像 */
@property (nonatomic, copy) NSString *replyPhoto;
/** 回复人姓名 */
@property (nonatomic, copy) NSString *replyName;
/** 被回复人姓名 */
@property (nonatomic, copy) NSString *targetName;

@end
