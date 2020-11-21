//
//  PPTViewController.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "MainViewController.h"

@interface PPTViewController : MainViewController

//课程ID -- 上页面传来
@property (nonatomic, copy) NSString *courseDetailId;

@property (nonatomic, assign) CGFloat viewHeight;
@end
