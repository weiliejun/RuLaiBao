//
//  SelectBtnView.h
//  SelectBtnView
//
//  Created by kingstartimes on 2018/3/8.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectBtnViewDelegate<NSObject>
@optional
- (void)selectViewBtnClick:(NSMutableString *)string;

@end

@interface SelectBtnView : UIView

- (instancetype)initWithBtnStr:(NSString *)btnStr;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) id<SelectBtnViewDelegate> delegate;

@end
