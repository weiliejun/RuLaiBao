//
//  GroupDetailTopicModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//
/*!
 话题详情model
 */
#import <Foundation/Foundation.h>
/*
 {
     circleId = 18032709463185347070;
     circleName = "\U5708\U5b501";
     commentCount = 39;
     createTime = "2018-05-09 11:39:42";
     creatorName = "\U5c0f\U51af\U51af110";
     creatorPhoto = "http://192.168.1.82:9091/upload/rulaibao/user/photo/18022227666660552139/headPhoto/smallPhoto18051614360017541127.jpg";
     isJoin = no;
     isManager = no;
     isTop = no;
     likeCount = 5;
     likeStatus = no;
     topicContent = "\U6211\U7684\U8bdd\U9898\U600e\U4e48\U90fd\U6ca1\U6709\U4e86";
     topicId = 18050911394290540824;
 };
*/
/** 话题model */
@interface GroupDetailTopicModel : NSObject
/** 话题id */
@property (nonatomic, copy) NSString *topicId;
/** 话题内容 */
@property (nonatomic, copy) NSString *topicContent;
/** 评论总数 */
@property (nonatomic, copy) NSString *commentCount;
/** 点赞总数 */
@property (nonatomic, copy) NSString *likeCount;
/** 话题创建时间 */
@property (nonatomic, copy) NSString *createTime;
/** 话题发表人 */
@property (nonatomic, copy) NSString *creatorName;
/** 话题发表人头像 */
@property (nonatomic, copy) NSString *creatorPhoto;
/** 点赞状态（yes:已点赞；no:未点赞；） */
@property (nonatomic, copy) NSString *likeStatus;
/** 是否已加入圈子（yes:已加入；no:未加入）*/
@property (nonatomic, copy) NSString *isJoin;
/*!
 在详情中使用
 */
/** 圈子ID -- 么有 */
@property (nonatomic, copy) NSString *circleId;
/** 圈子名称 */
@property (nonatomic, copy) NSString *circleName;
/** 是否为圈子管理者（yes:是；no:否；） */
@property (nonatomic, copy) NSString *isManager;
/** 是否置顶（yes:是；no:否；） */
@property (nonatomic, copy) NSString *isTop;

@end


