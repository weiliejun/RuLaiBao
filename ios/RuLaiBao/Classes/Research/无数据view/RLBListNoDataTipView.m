//
//  RLBListNoDataTipView.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/9.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "RLBListNoDataTipView.h"

@interface RLBListNoDataTipView ()
@property (nonatomic, weak) UIImageView *tipImageView;
@property (nonatomic, weak) UILabel *tipLabel;
@end

@implementation RLBListNoDataTipView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
              backgroundColor:(UIColor *)backgroundColor
                   imageFrame:(CGRect)imageFrame
                    imageName:(NSString *)imageName
                   titleFrame:(CGRect)titleFrame
                      tipText:(NSString *)tipText {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = backgroundColor;
        [self setupUIWithFrame:frame imageFrame:imageFrame titleFrame:titleFrame tipText:tipText imageName:imageName];
    }
    return self;
}

#pragma mark - 设置界面元素
- (void)setupUIWithFrame:(CGRect)frame imageFrame:(CGRect)imageFrame titleFrame:(CGRect)titleFrame tipText:(NSString *)tipText imageName:(NSString *)imageName {
    
    UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:imageFrame];
    tipImageView.image = [UIImage imageNamed:imageName];
    [self addSubview:tipImageView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:titleFrame];
    tipLabel.text = tipText;
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:16.0];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLabel];
    
    _tipImageView = tipImageView;
    _tipLabel = tipLabel;
}

-(void)changeImageViewWithImageName:(NSString *)imageName TipLabel:(NSString *)tipLabelStr{
    _tipImageView.image = [UIImage imageNamed:imageName];
    _tipLabel.text = tipLabelStr;
}

@end
