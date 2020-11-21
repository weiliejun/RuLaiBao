//
//  QuestionUserViewController.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/11.
//  Copyright © 2018年 junde. All rights reserved.
//

/*!
 我要提问页面
 */
#import "MainViewController.h"
/** 点赞后个数回调 */
typedef void(^QuestionAddSuccessBlock)(void);
@interface QuestionUserViewController : MainViewController

@property (nonatomic, strong) NSArray *strArray;

@property (nonatomic, copy) QuestionAddSuccessBlock addBlock;
@end
