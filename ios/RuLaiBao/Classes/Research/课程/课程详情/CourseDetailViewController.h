//
//  CourseDetailViewController.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "MainViewController.h"
/** 无数据回调刷新 */
typedef void(^DetailDataNoDataTipBlock)(void);
@interface CourseDetailViewController : MainViewController

/** 课程ID */
@property (nonatomic, copy) NSString *courseId;
/** 演讲人ID */
@property (nonatomic, copy) NSString *speechmakeId;

/** 无数据回调刷新上个页面 */
@property (nonatomic, copy) DetailDataNoDataTipBlock noDataBlock;
@end
