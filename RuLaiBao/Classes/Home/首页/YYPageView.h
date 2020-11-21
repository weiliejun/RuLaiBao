//
//  YYView.h
//  YYPageView
//
//  Created by kingstartimes on 2018/3/28.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageViewModel;

typedef void(^BtnClickBlock)(NSString *pid);

@interface YYPageView : UIView

@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, copy) BtnClickBlock btnClickBlock;

- (void)setPageViewModel:(PageViewModel *)pageModel;

@end
