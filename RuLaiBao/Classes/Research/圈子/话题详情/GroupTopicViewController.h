//
//  GroupTopicViewController.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/12.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"

@class GroupDetailTopicModel;

@interface GroupTopicViewController : MainViewController

@property (nonatomic, strong) GroupDetailTopicModel *topicDetailModel;

/*!
 第三方数据传来
 */
/** 话题ID */
@property (nonatomic, copy) NSString *appTopicId;
@end
