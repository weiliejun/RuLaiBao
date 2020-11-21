//
//  GroupTableViewCell.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/11.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupListModel;
/** 返回值 */
typedef void(^GroupCellJoinClickBlock)(GroupListModel *cellModel);

@interface GroupTableViewCell : UITableViewCell
@property (nonatomic, copy) GroupCellJoinClickBlock controlClick;
-(void)InfoModel:(GroupListModel* )cellInfoModel showBtn:(NSString *)isShowBtn;
@end
