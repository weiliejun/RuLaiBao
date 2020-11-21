//
//  ChooseDateViewController.h
//  HaiDeHui
//
//  Created by kingstartimes on 2018/1/8.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"

@class ChooseDateViewController;

@protocol ChooseDateDelegate <NSObject>

@optional

-(void)ChooseDateViewController:(ChooseDateViewController *)viewController didPassingValueWithStr:(NSString *)str;

@end

@interface ChooseDateViewController : UIViewController

@property (nonatomic, assign) id<ChooseDateDelegate>delegate;


@end
