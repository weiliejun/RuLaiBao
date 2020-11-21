//
//  CourseCollectionViewCell.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CourseListModel;
@interface CourseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CourseListModel *cellInfoModel;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
