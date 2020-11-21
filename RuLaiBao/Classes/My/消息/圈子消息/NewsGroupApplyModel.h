//
//  NewsGroupApplyModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/9.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsGroupApplyModel : NSObject
/*
 {
 applyCircleId = 18032709463185347070;
 applyCircleName = "\U5708\U5b501";
 applyId = 18032709463185347070;
 applyPhoto = "http://192.168.1.82:9091/upload/rulaibao/appCircle/picture/18032709463185347070/18032709463185356480.jpg";
 applyUserId = 18032709463185347076;
 applyUserName = leige;
 auditStatus = agree;
 }
 */
/** 消息id */
@property (nonatomic, copy) NSString *applyId;
/** 申请人id */
@property (nonatomic, copy) NSString *applyUserId;
/** 申请加入圈子的id */
@property (nonatomic, copy) NSString *applyCircleId;
/** 申请加入圈子的名称 */
@property (nonatomic, copy) NSString *applyCircleName;
/** 审核状态（submit:待加入；agree:已加入） */
@property (nonatomic, copy) NSString *auditStatus;
/** 申请人名字 */
@property (nonatomic, copy) NSString *applyUserName;
/** 申请人头像 */
@property (nonatomic, copy) NSString *applyPhoto;

@end
