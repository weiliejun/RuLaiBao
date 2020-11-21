//
//  YYView.m
//  YYPageView
//
//  Created by kingstartimes on 2018/3/28.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "YYPageView.h"
#import "Configure.h"
#import "QLColorLabel.h"

#import "PageViewModel.h"

@interface YYPageView()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sloganLabel;

@end

@implementation YYPageView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma mark - 创建cell
- (void)createUI{
    UILabel *percentLabel = [[UILabel alloc]init];
    percentLabel.textColor = [UIColor customDeepYellowColor];
    percentLabel.font = [UIFont systemFontOfSize:20];
    percentLabel.textAlignment = NSTextAlignmentCenter;
    percentLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:percentLabel];
    self.percentLabel = percentLabel;
    [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(30);
        make.width.mas_equalTo(@(Width_Window/3));
        make.height.mas_equalTo(@50);
    }];
    
    UIImageView *leftImage = [[UIImageView alloc]init];
    leftImage.image = [UIImage imageNamed:@"uncertify"];
    leftImage.layer.masksToBounds = YES;
    leftImage.layer.cornerRadius = 7;
    leftImage.hidden = YES;
    [self addSubview:leftImage];
    self.leftImage = leftImage;
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(percentLabel.mas_left).offset(-2);
        make.top.equalTo(self.mas_top).offset(48);
        make.width.mas_equalTo(@14);
        make.height.mas_equalTo(@14);
    }];

    //竖线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor customLineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(Width_Window/3+20);
        make.top.equalTo(self.mas_top).offset(30);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@45);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"---";
    nameLabel.textColor = [UIColor customTitleColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(Width_Window/3+35);
        make.top.equalTo(self.mas_top).offset(20);
        make.width.mas_equalTo(@(Width_Window*2/3-50));
        make.height.mas_equalTo(@20);
    }];
    
    UILabel *sloganLabel = [[UILabel alloc]init];
    sloganLabel.text = @"---";
    sloganLabel.textColor = [UIColor customDetailColor];
    sloganLabel.font = [UIFont systemFontOfSize:14];
    sloganLabel.textAlignment = NSTextAlignmentLeft;
    sloganLabel.numberOfLines = 0;
    [self addSubview:sloganLabel];
    self.sloganLabel = sloganLabel;
    
    [sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(Width_Window/3+35);
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(@(Width_Window*2/3-50));
        make.height.mas_equalTo(@40);
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick)];
    gesture.delegate = self;
    gesture.numberOfTapsRequired =1;
    [self addGestureRecognizer:gesture];
}

- (void)setPageViewModel:(PageViewModel *)pageModel{
    self.percentLabel.text = [NSString stringWithFormat:@"%@%%",pageModel.promotionMoney];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",pageModel.name];
    self.sloganLabel.text = [NSString stringWithFormat:@"%@",pageModel.recommendations];
//    self.sloganLabel.frame = CGRectMake(Width_Window/3+35, self.nameLabel.bottom+10, Width_Window*2/3-50, [NSString sizeWithFont:[UIFont systemFontOfSize:14] Size:CGSizeMake(Width_Window*2/3-50, MAXFLOAT) Str:self.sloganLabel.text].height);
    
    //判断登录和认证状态
    //计算text的layout
    if ([StoreTool getLoginStates]) {//登录
        if ([pageModel.checkStatus isEqualToString:@"success"]) {//success认证成功
            self.leftImage.hidden = YES;
            //推广费
            self.percentLabel.text = [NSString stringWithFormat:@"%@%%",pageModel.promotionMoney];
            self.percentLabel.textColor = [UIColor customLightYellowColor];
            self.percentLabel.font = [UIFont systemFontOfSize:20];
            [self.percentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(10);
                make.top.equalTo(self.mas_top).offset(30);
                make.width.mas_equalTo(@(Width_Window/3));
                make.height.mas_equalTo(@50);
            }];
            
        }else{//init未认证（未填写认证信息），submit待认证(提交认证信息待审核)，fail - 认证失败
            self.leftImage.hidden = NO;
            self.leftImage.image = [UIImage imageNamed:@"uncertify"];

            self.percentLabel.text = @"认证可见";
            self.percentLabel.textColor = [UIColor customDetailColor];
            self.percentLabel.font = [UIFont systemFontOfSize:16];
            [self.percentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset((Width_Window/6-75/2+10));
                make.top.equalTo(self.mas_top).offset(45);
                make.width.mas_equalTo(@75);
                make.height.mas_equalTo(@20);
            }];
        }
    }else{
        //未登录
        self.percentLabel.text = @"认证可见";
        self.percentLabel.textColor = [UIColor customDetailColor];
        self.percentLabel.font = [UIFont systemFontOfSize:16];
        [self.percentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset((Width_Window/6-75/2+10));
            make.top.equalTo(self.mas_top).offset(45);
            make.width.mas_equalTo(@75);
            make.height.mas_equalTo(@20);
        }];

        self.leftImage.hidden = NO;

        if ([pageModel.checkStatus isEqualToString:@"success"]) {
            //success认证成功
            self.leftImage.image = [UIImage imageNamed:@"certify"];

        }else{
            //init未认证（未填写认证信息），submit待认证(提交认证信息待审核)，fail - 认证失败
            self.leftImage.image = [UIImage imageNamed:@"uncertify"];
        }
    }
}

-(void)viewClick{
    if (self.btnClickBlock != nil) {
        self.btnClickBlock(_infoDict[@"name"]);
    }
}

@end
