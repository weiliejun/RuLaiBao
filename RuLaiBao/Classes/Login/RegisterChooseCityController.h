//
//  RegisterChooseCityController.h
//  RuLaiBao
//
//  Created by qiu on 2018/11/13.
//  Copyright © 2018 junde. All rights reserved.
//

#import "MainViewController.h"

@class RegisterChooseCityController;

/*!
 @protocol
 @abstract    选择地址的一个protocol
 @discussion  实现选择地址的功能
 */
@protocol ChooseCityDelegate <NSObject>

@optional
/** 理论上此处可以只包括两个参数即可(汉字和中文)，或者一个即可(index) */
-(void)viewController:(RegisterChooseCityController *)viewController didChooseCityWithStr:(NSArray *)infoArr;
@end

@interface RegisterChooseCityController : MainViewController

@property (nonatomic, assign) id<ChooseCityDelegate> chooseDelegate;

@end
