//
//  HeaderView.h
//  InsuranceDetail
//
//  Created by kingstartimes on 2018/3/27.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InsuranceDetailModel;

typedef void(^BtnClickBlock)(NSString *pid);

@interface HeaderView : UIView

@property (nonatomic, copy) BtnClickBlock btnClickBlock;

- (void)setLabelWithInfoDict:(InsuranceDetailModel *)model;

- (void)setCollectionWithInfoDict:(NSDictionary *)dict;




@end
