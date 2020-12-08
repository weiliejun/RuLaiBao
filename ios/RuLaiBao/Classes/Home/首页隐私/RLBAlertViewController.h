//
//  RLBAlertViewController.h
//  RuLaiBao
//
//  Created by qiu on 2020/12/1.
//  Copyright © 2020 junde. All rights reserved.
//

#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RLBAlertViewController : MainViewController

/** 按钮点击回调 */
@property (nonatomic, copy) void (^RLBAlertVCHide)(void);
@end

NS_ASSUME_NONNULL_END
