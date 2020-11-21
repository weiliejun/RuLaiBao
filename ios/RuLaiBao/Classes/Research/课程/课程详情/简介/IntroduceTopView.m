//
//  IntroduceTopView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "IntroduceTopView.h"
#import "Configure.h"
#import "IntroduceModel.h"

@interface IntroduceTopView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *jobLabel;
@property (nonatomic, weak) UILabel *nameLabel;
@end

@implementation IntroduceTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        [self addUILayout];
    }
    return self;
}

-(void)setIntroduceInfoModel:(IntroduceModel *)introduceInfoModel{
    _introduceInfoModel = introduceInfoModel;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:introduceInfoModel.headPhoto] placeholderImage:[UIImage imageNamed:@"information_header"]];
    self.jobLabel.text = [NSString stringWithFormat:@"%@",introduceInfoModel.position];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",introduceInfoModel.realName];
}


#pragma mark - UI
-(void)createUI{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"information_header"];
    [self addSubview:imageView];
    
    UILabel *jobLabel = [[UILabel alloc]init];
    jobLabel.font = [UIFont systemFontOfSize:18.0];
    jobLabel.textColor = [UIColor customTitleColor];
    [self addSubview:jobLabel];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = [UIFont systemFontOfSize:18.0];
    nameLabel.textColor = [UIColor customTitleColor];
    [self addSubview:nameLabel];
    
    _imageView = imageView;
    _jobLabel = jobLabel;
    _nameLabel = nameLabel;
}

-(void)addUILayout{
    WeakSelf
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(strongSelf.mas_top).offset(20);
        make.left.equalTo(strongSelf.mas_left).offset(20);
        make.width.height.mas_equalTo(@60);
    }];
    
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(strongSelf.mas_top).offset(25);
        make.left.equalTo(strongSelf.imageView.mas_right).offset(10);
        make.right.equalTo(strongSelf.mas_right).offset(-10);
        make.height.mas_equalTo(@25);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(strongSelf.jobLabel.mas_bottom).offset(5);
        make.left.equalTo(strongSelf.imageView.mas_right).offset(10);
        make.right.equalTo(strongSelf.mas_right).offset(-10);
        make.height.mas_equalTo(@25);
    }];
}
-(void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    //圆角
    self.imageView.layer.cornerRadius = self.imageView.width/2;
    self.imageView.layer.masksToBounds = YES;
    //优化
    self.imageView.layer.shouldRasterize = YES;
    self.imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
