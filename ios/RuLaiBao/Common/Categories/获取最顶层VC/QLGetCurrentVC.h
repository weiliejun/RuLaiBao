//
//  QLGetCurrentVC.h
//  JiaoKan
//
//  Created by qiu on 2019/7/8.
//  Copyright © 2019 qiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface QLGetCurrentVC : NSObject
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentActivityViewController;
@end

NS_ASSUME_NONNULL_END
