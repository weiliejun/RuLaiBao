//
//  QAListModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAListModel : NSObject
/** 问题id */
@property (nonatomic, copy) NSString *questionId;
/** 问题标题 */
@property (nonatomic, copy) NSString *title;
/** 问题描述 */
@property (nonatomic, copy) NSString *descript;
/** 问题发布时间 */
@property (nonatomic, copy) NSString *time;
/** 提问人姓名 */
@property (nonatomic, copy) NSString *userName;
/** 提问人头像 */
@property (nonatomic, copy) NSString *userPhoto;

/** 回复总数 */
@property (nonatomic, copy) NSString *answerCount;
/** 回答人姓名 */
@property (nonatomic, copy) NSString *answerName;
/** 回答内容 */
@property (nonatomic, copy) NSString *answerContent;
/** 回答人头像 */
@property (nonatomic, copy) NSString *answerPhoto;

@end
