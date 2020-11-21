//
//  GroupListInterModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 myAppCircle =         ();
 myAppCircleTotal = 0;
 myJoinAppCircle =         ();
 myJoinAppCircleTotal = 0;
 myRecomAppCircle =();
 myRecomAppCircleTotal = 2;
 */
@class GroupListModel;
@interface GroupListInterModel : NSObject
/** 我的圈子列表 */
@property (nonatomic, strong) NSArray <GroupListModel *> *myAppCircle;
/** 我加入的圈子列表 */
@property (nonatomic, strong) NSArray <GroupListModel *> *myJoinAppCircle;
/** 推荐的圈子列表 */
@property (nonatomic, strong) NSArray <GroupListModel *> *myRecomAppCircle;
@end
