//
//  CustomButton.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/17.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BtnAnimationStopBlock)(void);

@interface CustomButton : UIButton

@property (nonatomic, copy) BtnAnimationStopBlock btnStopBlock;

#pragma mark - 请求中
-(void)startAnimation:(NSString *)loadingStr;
#pragma mark - 请求结束
-(void)stopAnimationWithSuccess:(NSString *)stopStr;
-(void)stopAnimationWithFail:(NSString *)stopStr;
#pragma mark - 加载时是否disable按钮 default:YES
@property(nonatomic,assign)BOOL disableWhenLoad;

@end
