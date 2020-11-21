//
//  PPTTableFooterView.h
//  RuLaiBao
//
//  Created by qiu on 2018/9/3.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TitleControlClickBlock)(void);

@interface PPTTableFooterView : UIView

- (instancetype)initWithFrame:(CGRect)frame
              backgroundColor:(UIColor *)backgroundColor
                   titleFrame:(CGRect)titleFrame
            titleLabelBGColor:(UIColor *)labelBGColor
                    titleText:(NSString *)titleText
              titleClickBlock:(TitleControlClickBlock)clickBlock;

//修改title
@property (nonatomic, copy) NSString *titleText;

@end
