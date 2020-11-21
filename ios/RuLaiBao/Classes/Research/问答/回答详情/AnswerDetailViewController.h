//
//  AnswerDetailViewController.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"

/** 点赞后个数回调 */
typedef void(^BackLikeSuccessBlock)(void);

@class DetailQuestionModel;
@interface AnswerDetailViewController : MainViewController

/** 点赞返回，只需要添加一个点赞数 */
@property (nonatomic, copy) BackLikeSuccessBlock likeSuccessBlock;

/** 问题ID */
@property (nonatomic, copy) NSString *questionId;
/** 请求回答内容 */
@property (nonatomic, strong) DetailQuestionModel *answerDetailModel;

/*!
 第三方数据传来
 */
/** 回答ID */
@property (nonatomic, copy) NSString *answerId;
@end
