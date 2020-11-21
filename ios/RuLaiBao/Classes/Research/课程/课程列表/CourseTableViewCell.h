//
//  CourseTableViewCell.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CourseListModel;
@interface CourseTableViewCell : UITableViewCell
@property (nonatomic, strong) CourseListModel *cellInfoModel;
@end
