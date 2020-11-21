//
//  GroupDetailInterModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GroupListModel,GroupDetailTopicModel;
@interface GroupDetailInterModel : NSObject

@property (nonatomic, strong) GroupListModel *appCircle;
/** 置顶话题列表 */
@property (nonatomic, strong) NSArray <GroupDetailTopicModel *>*topAppTopics;

@end
