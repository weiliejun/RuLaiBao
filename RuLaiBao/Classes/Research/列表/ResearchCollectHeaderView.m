//
//  ResearchCollectHeaderView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "ResearchCollectHeaderView.h"
#import "Configure.h"
#import "CourseListModel.h"

@interface ResearchCollectHeaderView()
//底部
@property (nonatomic, weak) UIControl *control;
//最新课程
@property (nonatomic, weak) UILabel *titleLabel;
//背景image
@property (nonatomic, weak) UIImageView *imageView;
//时间
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIImageView *grayView;
//主讲人
@property (nonatomic, weak) UILabel *nameLabel;
//主讲人职位
@property (nonatomic, weak) UILabel *jobLabel;
//课程名称
@property (nonatomic, weak) UILabel *courseLabel;

@end

@implementation ResearchCollectHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self addUILayout];
    }
    return self;
}

-(void)setInfoModel:(CourseListModel *)infoModel{
    _infoModel = infoModel;
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",infoModel.courseTime];
    _nameLabel.text = [NSString stringWithFormat:@"%@",infoModel.speechmakeName];
    _jobLabel.text = [NSString stringWithFormat:@"%@",infoModel.position];
    _courseLabel.text = [NSString stringWithFormat:@"【%@】",infoModel.courseName];
    
    NSArray *locationArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"];
    //传过来的是数字，从本地图片库中取
    NSString *imageNum = [NSString stringWithFormat:@"%@",infoModel.courseLogo];
    if (![locationArr containsObject:imageNum]) {
        //默认
        imageNum = @"4";
    }
    _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"YX_Default_%@",imageNum]];
}

#pragma mark - 设置界面元素
- (void)setupUI {
    UIControl *control = [[UIControl alloc]init];
    control.backgroundColor = [UIColor whiteColor];
    [control addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"课程推荐";
    titleLabel.textColor = [UIColor customTitleColor];
    titleLabel.font = [UIFont systemFontOfSize:KFontTitleSize];
    [control addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"YX_Default_6"];
    [control addSubview:imageView];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor customDetailColor];
    timeLabel.font = [UIFont systemFontOfSize:KFontDetailSize];
    [control addSubview:timeLabel];
    
    UIImageView *grayView = [[UIImageView alloc]init];
    grayView.image = [UIImage imageNamed:@"YX_Gradient"];
    [imageView addSubview:grayView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:KFontTimeSize];
    [grayView addSubview:nameLabel];
    
    UILabel *jobLabel = [[UILabel alloc]init];
    jobLabel.textColor = [UIColor whiteColor];
    jobLabel.font = [UIFont systemFontOfSize:KFontTimeSize];
    [grayView addSubview:jobLabel];
    
    UILabel *courseLabel = [[UILabel alloc]init];
    courseLabel.font = [UIFont systemFontOfSize:20.0];
    courseLabel.textColor = [UIColor whiteColor];
    [grayView addSubview:courseLabel];
    
    _control = control;
    _titleLabel = titleLabel;
    _imageView = imageView;
    _timeLabel = timeLabel;
    _grayView = grayView;
    _nameLabel = nameLabel;
    _jobLabel = jobLabel;
    _courseLabel = courseLabel;
}

-(void)controlClick:(UIControl *)sender{
    if (self.infoModel == nil) {
        return;
    }
    if (self.controlClick != nil) {
        self.controlClick();
    }
}

- (void)addUILayout {
    WeakSelf
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(strongSelf.control.mas_top).offset(10);
        make.left.equalTo(strongSelf.control.mas_left).offset(10);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@150);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(strongSelf.control.mas_top).offset(10);
        make.right.equalTo(strongSelf.control.mas_right).offset(-10);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@120);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(strongSelf.control.mas_left).offset(10);
        make.top.equalTo(strongSelf.titleLabel.mas_bottom).offset(5);
        make.right.equalTo(strongSelf.control.mas_right).offset(-10);
        make.bottom.equalTo(strongSelf.control.mas_bottom).offset(-10);
    }];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.right.bottom.equalTo(strongSelf.imageView);
        make.height.mas_equalTo(80);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(strongSelf.grayView.mas_left).offset(10);
        make.bottom.equalTo(strongSelf.grayView.mas_bottom).offset(-10);
        make.height.mas_equalTo(@20);
    }];
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(strongSelf.nameLabel.mas_right).offset(10);
        make.bottom.equalTo(strongSelf.grayView.mas_bottom).offset(-10);
        make.right.mas_lessThanOrEqualTo(strongSelf.grayView.mas_right).offset(-10);
        make.height.mas_equalTo(@20);
    }];
    [self.courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(strongSelf.grayView.mas_left).offset(0);
        make.bottom.equalTo(strongSelf.nameLabel.mas_top).offset(0);
        make.right.equalTo(strongSelf.grayView.mas_right).offset(-10);
        make.height.mas_equalTo(@30);
    }];
}
@end
