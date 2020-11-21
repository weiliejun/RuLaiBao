//
//  DetailAnswerHeaderView.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupTopicCommentModel.h"

@class DetailAnswerHeaderView,TYAttributedLabel;

/** 回复返回值 */
typedef void(^ReplyBtnClickBlock)(DetailAnswerHeaderView *headView);
typedef void(^CommentImageClickBlock)(NSString *imageUrl);

@interface DetailAnswerHeaderView : UITableViewHeaderFooterView

@property(nonatomic,retain)GroupTopicCommentModel *model;

@property (nonatomic, copy) ReplyBtnClickBlock replyBtnClickBlock;

@property (nonatomic, copy) CommentImageClickBlock commentImageClickBlock;

//用于设置代理方法
@property (nonatomic, weak, readonly) TYAttributedLabel *detailHeaderLabel;
@end
