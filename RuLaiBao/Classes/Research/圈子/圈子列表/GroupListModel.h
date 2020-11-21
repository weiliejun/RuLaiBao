//
//  GroupListModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
{
    circleDesc = "\U5708\U5b501";
    circleId = 18032709463185347070;
    circleName = "\U5708\U5b501";
    circlePhoto = "http://192.168.1.82:9091/upload/rulaibao/appCircle/picture/18032709463185347070/18032709463185356480.jpg";
    isApply = no;
}
 */
@interface GroupListModel : NSObject
/** 圈子id */
@property (nonatomic, copy) NSString *circleId;
/** 圈子名称 */
@property (nonatomic, copy) NSString *circleName;
/** 圈子描述 */
@property (nonatomic, copy) NSString *circleDesc;
/** 圈子头像 */
@property (nonatomic, copy) NSString *circlePhoto;
/** 是否申请 */
@property (nonatomic, copy) NSString *isApply;

/** 圈子会员总数 */
@property (nonatomic, copy) NSString *memberCount;
/** 圈子话题总数 */
@property (nonatomic, copy) NSString *topicCount;
/** 是否为圈子管理者（yes:是；no:否；） */
@property (nonatomic, copy) NSString *isManager;
/** 是否已经加入该圈子（yes:是；no:否；） */
@property (nonatomic, copy) NSString *isJoin;
/** 置顶话题总数 */
@property (nonatomic, copy) NSString *topAppTopicTotal;
/** 是否需要验证（yes:是；no:否；） */
@property (nonatomic, copy) NSString *isNeedAduit;
@end
