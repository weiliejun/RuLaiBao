//
//  ChooseBankViewController.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/15.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ChooseBankViewController;

@protocol ChooseBankDelegate <NSObject>

@optional

-(void)ChooseBankViewController:(ChooseBankViewController *)viewController didPassValueWithStr:(NSString *)str;

@end

@interface ChooseBankViewController : UIViewController

@property (nonatomic, assign) id<ChooseBankDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
