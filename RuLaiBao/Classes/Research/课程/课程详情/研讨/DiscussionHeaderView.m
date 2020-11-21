//
//  DiscussionHeaderView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/8.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "DiscussionHeaderView.h"
#import "Configure.h"

@interface DiscussionHeaderView ()
@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *detailLabel;
@property (nonatomic, weak) UIButton *replyBtn;
@end

@implementation DiscussionHeaderView
- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createCellUI];
    }
    return self;
}
-(void)setModel:(InfoDataModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.commentPhoto] placeholderImage:[UIImage imageNamed:@"information_header"]];
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.commentName];
    _timeLabel.text = [NSString stringWithFormat:@"%@",model.commentTime];
    self.detailLabel.attributedText = model.mutablAttrStr;
    self.detailLabel.frame = model.frameLayout;
    
    if ([model.btnHidden isEqualToString:@"true"]) {
        self.replyBtn.hidden = YES;
    }else{
        self.replyBtn.hidden = NO;
        self.replyBtn.frame = CGRectMake(Width_Window-60, self.detailLabel.bottom + 5, 50, 30);
    }
}

#pragma mark - createUI
-(void)createCellUI{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    imageV.image = [UIImage imageNamed:@"information_header"];
    imageV.layer.cornerRadius = 20.f;
    imageV.layer.masksToBounds = YES;
    //优化
    imageV.layer.shouldRasterize = YES;
    imageV.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.contentView addSubview:imageV];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageV.right+10, 10, Width_Window-10-40-10-100-10-10, 40)];
    nameLabel.textColor = [UIColor customTitleColor];
    nameLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:nameLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right+10, 10, 100, 40)];
    timeLabel.textColor = [UIColor customDetailColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:KFontTimeSize];
    [self.contentView addSubview:timeLabel];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.numberOfLines = 0;
    detailLabel.textColor = [UIColor customTitleColor];
    detailLabel.font = [UIFont systemFontOfSize:18.0];
    [self.contentView addSubview:detailLabel];
    
    UIButton *replyBtn = [[UIButton alloc]init];
    [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:KFontTimeSize];
    [replyBtn setTitleColor:[UIColor customBlueColor] forState:UIControlStateNormal];
    [replyBtn addTarget:self action:@selector(replyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:replyBtn];
    
    _imageV = imageV;
    _nameLabel = nameLabel;
    _timeLabel = timeLabel;
    _detailLabel = detailLabel;
    _replyBtn = replyBtn;
}
-(void)replyBtnClick{
    //回调
    if (self.replyBtnClickBlock != nil) {
        self.replyBtnClickBlock(self);
    }
}

@end
