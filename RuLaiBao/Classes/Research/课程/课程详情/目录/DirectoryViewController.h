//
//  DirectoryViewController.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "MainViewController.h"

@interface DirectoryViewController : MainViewController

//演讲人ID -- 上页面传来
@property (nonatomic, copy) NSString *speechmakeId;
/** 页面高度 */
@property (nonatomic, assign) CGFloat viewHeight;
@end
