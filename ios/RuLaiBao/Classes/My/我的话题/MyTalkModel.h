//
//  MyTalkModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTalkModel : NSObject
/** 话题id */
@property (nonatomic,copy)NSString *topicId;
/** 话题内容 */
@property (nonatomic,copy)NSString *topicContent;
/** 评论总数 */
@property (nonatomic,copy)NSString *commentCount;
/** 点赞总数 */
@property (nonatomic,copy)NSString *likeCount;
/** 话题所属圈子名称 */
@property (nonatomic,copy)NSString *circleName;


+ (instancetype)myTalkListModelWithDictionary:(NSDictionary *)KVCDic;


@end
