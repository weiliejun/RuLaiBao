//
//  GroupLimitViewController.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/12.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"
/** 权限改变后回调 */
typedef void(^BackLimitChangeBlock)(void);

@interface GroupLimitViewController : MainViewController

@property (nonatomic, copy) NSString *circleID;
@property (nonatomic, copy) NSString *auditStatus;

@property (nonatomic, copy) BackLimitChangeBlock limitChangeBlock;

@end
