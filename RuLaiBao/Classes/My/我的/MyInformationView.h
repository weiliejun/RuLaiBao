//
//  MyInformationView.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyListModel;

typedef void(^BtnClickBlock)(NSString *pid);

typedef void(^CommisionClickBlock)(NSString *pid);

@interface MyInformationView : UIView

@property (nonatomic, copy) BtnClickBlock btnClickBlock;

@property (nonatomic, copy) CommisionClickBlock commisionClickBlock;

- (void)setLabelWithInfoDict:(MyListModel *)model;

@end
