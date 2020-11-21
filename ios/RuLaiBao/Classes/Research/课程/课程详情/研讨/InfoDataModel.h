//
//  InfoDataModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/8.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReplyModel;
@interface InfoDataModel : NSObject
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

/** 存放回复的数组 */
@property (nonatomic, strong) NSArray <ReplyModel *>*replys;

//是否显示回复
@property(nonatomic,copy) NSString *btnHidden;

/** 评论详情的处理字符串 */
@property(nonatomic,strong)NSMutableAttributedString *mutablAttrStr;

/** 回复的数组 */
@property (nonatomic, strong) NSArray *textContainers;

-(instancetype)initWithDic:(NSDictionary *)dic SpeechmanId:(NSString *)speechmanId;
@end
