//
//  DiscussionHeaderView.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/8.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoDataModel.h"

@class DiscussionHeaderView;
/** 返回值 */
typedef void(^ReplyBtnClickBlock)(DiscussionHeaderView *headView);

@interface DiscussionHeaderView : UITableViewHeaderFooterView

@property(nonatomic,retain)InfoDataModel *model;

@property (nonatomic, copy) ReplyBtnClickBlock replyBtnClickBlock;

@end
