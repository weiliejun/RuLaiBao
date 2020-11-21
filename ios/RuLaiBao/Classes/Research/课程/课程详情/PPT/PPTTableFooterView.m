//
//  PPTTableFooterView.m
//  RuLaiBao
//
//  Created by qiu on 2018/9/3.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "PPTTableFooterView.h"
#import "Configure.h"
@interface PPTTableFooterView()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, copy) TitleControlClickBlock titleBlock;
@property (nonatomic, weak) UIControl *bgControl;
@end

@implementation PPTTableFooterView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
              backgroundColor:(UIColor *)backgroundColor
                   titleFrame:(CGRect)titleFrame
            titleLabelBGColor:(UIColor *)labelBGColor
                    titleText:(NSString *)titleText
              titleClickBlock:(TitleControlClickBlock)clickBlock{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = backgroundColor;
        self.titleBlock = clickBlock;
        self.titleText = titleText;
        [self ql_setupUIWithTitleFrame:titleFrame titleLabelBGColor:labelBGColor titleText:_titleText];
    }
    return self;
}
-(void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    self.titleLabel.text = titleText;
    if ([NSString isBlankString:titleText]) {
        self.titleBlock = nil;
        self.titleLabel.text = @"暂无PDF文件";
        self.titleLabel.textColor = [UIColor customDetailColor];
        self.bgControl.backgroundColor = [UIColor customLineColor];
    }
}
#pragma mark - 设置界面元素
- (void)ql_setupUIWithTitleFrame:(CGRect)titleFrame titleLabelBGColor:(UIColor *)labelBGColor titleText:(NSString *)titleText{
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-150, 30, 300, 30)];
    tipLabel.text = @"更多PPT信息请查看下方PDF文件";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor customDetailColor];
    tipLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:tipLabel];
    
    UIControl *bgControl = [[UIControl alloc] initWithFrame:titleFrame];
    bgControl.backgroundColor = [UIColor colorWithHexString:@"#fef5e5"];
    [bgControl addTarget:self action:@selector(ql_titleClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgControl];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(titleFrame)-30, CGRectGetHeight(titleFrame))];
    titleLabel.text = titleText;
    titleLabel.textColor = [UIColor colorWithHexString:@"#f5a003"];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgControl addSubview:titleLabel];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(titleFrame)-20, CGRectGetHeight(titleFrame)/2-8, 8, 12)];
    imageV.image = [UIImage imageNamed:@"arrow_r"];
    [bgControl addSubview:imageV];
    
    _bgControl = bgControl;
    _titleLabel = titleLabel;
}

-(void)ql_titleClick{
    if (self.titleBlock) {
        self.titleBlock();
    }
}
@end
