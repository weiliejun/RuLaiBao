//
//  NewsGroupTableViewCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "NewsGroupTableViewCell.h"
#import "Configure.h"
#import "UIImage+extend.h"
#import "NewsGroupApplyModel.h"

@interface NewsGroupTableViewCell ()
@property (nonatomic, weak) UIImageView *headImageV;
/** title */
@property (nonatomic, weak) UILabel *titleLabel;
/** 简介 */
@property (nonatomic, weak) UILabel *detailLabel;

@property (nonatomic, weak) UIButton *agreeBtn;

@end
@implementation NewsGroupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self customUI];
    }
    return self;
}
-(void)setApplyCellModel:(NewsGroupApplyModel *)applyCellModel{
    _applyCellModel = applyCellModel;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",applyCellModel.applyUserName];
    self.detailLabel.text = [NSString stringWithFormat:@"申请加入\"%@\"",applyCellModel.applyCircleName];
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload;
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:applyCellModel.applyPhoto] placeholderImage:[UIImage imageNamed:@"information_header"] options:options];
    
    if ([applyCellModel.auditStatus isEqualToString:@"agree"]) {
        self.agreeBtn.enabled = NO;
        [self.agreeBtn setTitle:@"已加入" forState:UIControlStateNormal];
        [self.agreeBtn setBackgroundImage:[UIImage pureColorImageWithSize:self.agreeBtn.frame.size color:[UIColor customDetailColor] cornRadius:15] forState:UIControlStateNormal];
    }else{
        self.agreeBtn.enabled = YES;
        [self.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [self.agreeBtn setBackgroundImage:[UIImage pureColorImageWithSize:self.agreeBtn.frame.size color:[UIColor customDeepYellowColor] cornRadius:15] forState:UIControlStateNormal];
    }
}

-(void)setIsAgreeState:(BOOL)IsAgreeState{
    self.agreeBtn.enabled = NO;
    [self.agreeBtn setTitle:@"已加入" forState:UIControlStateNormal];
    [self.agreeBtn setBackgroundImage:[UIImage pureColorImageWithSize:self.agreeBtn.frame.size color:[UIColor customDetailColor] cornRadius:15] forState:UIControlStateNormal];
}

#pragma mark - UI
- (void)customUI{
    UIImageView *headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 50, 50)];
    headImageV.image = [UIImage imageNamed:@"information_header"];
    headImageV.layer.cornerRadius = 25.f;
    headImageV.layer.masksToBounds = YES;
    //优化
    headImageV.layer.shouldRasterize = YES;
    headImageV.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.contentView addSubview:headImageV];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(headImageV.right + 10, 15, Width_Window-headImageV.right-10-10-10-80, 25)];
    titleLabel.textColor = [UIColor customTitleColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.contentView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(headImageV.right + 10,titleLabel.bottom+5, Width_Window-headImageV.right-10-10-10-80, 20)];
    detailLabel.textColor = [UIColor customDetailColor];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:detailLabel];
    
    UIButton *agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window-90, 25, 80, 30)];
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:agreeBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 69, Width_Window-20, 1)];
    lineView.backgroundColor = [UIColor customBackgroundColor];
    [self.contentView addSubview:lineView];
    
    _headImageV = headImageV;
    _titleLabel = titleLabel;
    _detailLabel = detailLabel;
    _agreeBtn = agreeBtn;
}

-(void)agreeBtnClick{
    if (self.btnClick != nil) {
        self.btnClick(self);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
