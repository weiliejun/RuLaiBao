//
//  GroupTopicCommentModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/3.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReplyModel,TYTextContainer;
@interface GroupTopicCommentModel : NSObject
//detail
@property (nonatomic, assign) CGRect frameLayout;
///sectionHeaderView的高度
@property (nonatomic, assign) CGFloat headerHeight;

//评论人id
@property(nonatomic,copy)NSString *commentId;
//评论人名字
@property(nonatomic,copy)NSString *commentName;
//评论人头像
@property(nonatomic,copy)NSString *commentPhoto;

//评论的id
@property(nonatomic,copy)NSString *cid;
//评论的内容
@property(nonatomic,copy)NSString *commentContent;
//评论的时间
@property(nonatomic,copy)NSString *commentTime;

/*!
 新增--仅话题详情op底部评论时才会有此信息
 */
/** 评论的链接 */
@property(nonatomic,copy)NSString *commentLinkUrl;
/** 评论的图片url,小图的 -- header用*/
@property(nonatomic,copy)NSString *commentLinkPhoto;
/** 评论的图片url,大图的 -- 放大预览用 */
@property(nonatomic,copy)NSString *commentLinkPhotoBig;
/** 将评论的内容封装成container来使用 */
@property (nonatomic, strong) TYTextContainer *commentTextContainer;
@property (nonatomic, assign) CGRect commentPhotoRect;

/** 存放回复的数组 */
@property (nonatomic, strong) NSArray <ReplyModel *>*replys;

/** 回复的数组 */
@property (nonatomic, strong) NSArray *textContainers;

-(instancetype)initWithDic:(NSDictionary *)dic;

-(instancetype)handleModelWith:(ReplyModel *)replyModel fatherModel:(GroupTopicCommentModel *)fatherModel;
@end
