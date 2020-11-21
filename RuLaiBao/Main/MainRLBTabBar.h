//
//  MainRLBTabBar.h
//  RuLaiBao
//
//  Created by qiu on 2018/12/5.
//  Copyright © 2018 junde. All rights reserved.
//

/*!
 1.此tabbar主要是为了解决12.1版本时的pop回来时的跳动问题
 2.或者在AppDelegate中实现此方法：[[UITabBar appearance] setTranslucent:NO];
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainRLBTabBar : UITabBar

@end

NS_ASSUME_NONNULL_END
