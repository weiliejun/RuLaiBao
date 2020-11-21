//
//  DetailQuestionModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/5.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailQuestionModel : NSObject
/** 问题标题 */
@property (nonatomic, copy) NSString *title;
/** 回答的id */
@property (nonatomic, copy) NSString *answerId;
/** 回答内容 */
@property (nonatomic, copy) NSString *answerContent;
/** 评论总数 */
@property (nonatomic, copy) NSString *commentCount;
/** 点赞总数 */
@property (nonatomic, copy) NSString *likeCount;
/** 回答时间 */
@property (nonatomic, copy) NSString *answerTime;
/** 回答人name */
@property (nonatomic, copy) NSString *answerName;
/** 回答人头像 */
@property (nonatomic, copy) NSString *answerPhoto;
/** 点赞状态（yes:已点赞；no:未点赞；） */
@property (nonatomic, copy) NSString *likeStatus;
@end
