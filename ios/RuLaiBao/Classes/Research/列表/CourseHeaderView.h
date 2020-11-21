//
//  CourseHeaderView.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//
/*!
 精品课程头部
 */
#import <UIKit/UIKit.h>
/** 点击 */
typedef void(^ExchangeBtnBlock)(void);
@interface CourseHeaderView : UICollectionReusableView
//组
@property (nonatomic, strong) NSIndexPath *indexPath;
//点击事件
@property (nonatomic, copy) ExchangeBtnBlock exchangeBtnBlock;

//动画
@property (nonatomic, assign) BOOL isAnimation;
@end
