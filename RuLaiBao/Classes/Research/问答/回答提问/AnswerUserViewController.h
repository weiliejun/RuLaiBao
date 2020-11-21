//
//  AnswerUserViewController.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/11.
//  Copyright © 2018年 junde. All rights reserved.
//

/*!
 问答页面
 */
#import "MainViewController.h"
@class QAListModel;
@interface AnswerUserViewController : MainViewController
@property (nonatomic, strong) QAListModel *detailModel;
@end
