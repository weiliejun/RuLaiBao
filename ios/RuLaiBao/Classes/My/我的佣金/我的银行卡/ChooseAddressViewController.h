//
//  ChooseAddressViewController.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/16.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ChooseAddressViewController;

/*!
 @protocol
 @abstract    选择地址的一个protocol
 @discussion  实现选择地址的功能
 */
@protocol ChooseAddressDelegate <NSObject>

@optional
-(void)viewController:(ChooseAddressViewController *)viewController didPassingAddWithStr:(NSArray *)infoArr;
@end

@interface ChooseAddressViewController : UIViewController

@property (nonatomic, assign) id<ChooseAddressDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
