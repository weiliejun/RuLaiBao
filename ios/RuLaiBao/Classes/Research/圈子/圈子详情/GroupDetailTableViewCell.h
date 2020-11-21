//
//  GroupDetailTableViewCell.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/5.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GroupDetailCellControlType){
    GroupDetailCellControlTypeMsg     = 1000,//消息
    GroupDetailCellControlTypeLink           ,//点赞
};

@class GroupDetailTableViewCell;
/** 返回值 */
typedef void(^GroupDetailControlClickBlock)(GroupDetailCellControlType index, GroupDetailTableViewCell *detailCell);

@class GroupDetailTopicModel;
@interface GroupDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) GroupDetailTopicModel *groupDetailModel;
@property (nonatomic, assign) BOOL isLikeSelect;

@property (nonatomic, copy) GroupDetailControlClickBlock controlClick;
@end
