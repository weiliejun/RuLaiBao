//
//  GroupTableViewCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/11.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "GroupTableViewCell.h"
#import "Configure.h"
#import "UIImage+extend.h"
#import "GroupListModel.h"

@interface GroupTableViewCell ()

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *msgLabel;
@property (nonatomic, weak) UIButton *logBtn;

@property (nonatomic, strong) GroupListModel *model;
@end

@implementation GroupTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCellUI];
    }
    return self;
}

-(void)InfoModel:(GroupListModel* )cellInfoModel showBtn:(NSString *)isShowBtn{
    _model = cellInfoModel;
    _nameLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.circleName];
    _msgLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.circleDesc];
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:cellInfoModel.circlePhoto] placeholderImage:[UIImage imageNamed:@"YX_QZ_G"] options:options];
    
    if ([isShowBtn isEqualToString:@"yes"]) {
        self.logBtn.hidden = NO;
        self.nameLabel.frame = CGRectMake(_imageV.right +10, 20, Width_Window - _imageV.right-10-90, 30);
        self.msgLabel.frame = CGRectMake(_imageV.right +10, _nameLabel.bottom, Width_Window - _imageV.right-10-90, 25);
        [self.logBtn setTitle:@"+ 加入" forState:UIControlStateNormal];
//        if ([cellInfoModel.isApply isEqualToString:@"no"]) {
//            [self.logBtn setTitle:@"+ 加入" forState:UIControlStateNormal];
//            self.logBtn.selected = NO;
//        }else{
//            [self.logBtn setTitle:@"+ 加入" forState:UIControlStateNormal];
//            self.logBtn.selected = YES;
//        }
    }else{
        self.logBtn.hidden = YES;
        self.nameLabel.frame = CGRectMake(_imageV.right +10, 20, Width_Window - _imageV.right-10-10, 30);
        self.msgLabel.frame = CGRectMake(_imageV.right +10, _nameLabel.bottom, Width_Window - _imageV.right-10-10, 25);
    }
}

-(void)createCellUI{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 60, 60)];
    imageV.image = [UIImage imageNamed:@"YX_QZ_G"];
    imageV.layer.cornerRadius = 30.f;
    imageV.layer.masksToBounds = YES;
    //优化
    imageV.layer.shouldRasterize = YES;
    imageV.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.contentView addSubview:imageV];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = [UIFont systemFontOfSize:18.0];
    nameLabel.textColor = [UIColor customNavBarColor];
    [self.contentView addSubview:nameLabel];
    
    UILabel *msgLabel = [[UILabel alloc]init];
    msgLabel.font = [UIFont systemFontOfSize:16.0];
    msgLabel.textColor = [UIColor customDetailColor];
    [self.contentView addSubview:msgLabel];
    
    UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logBtn.frame = CGRectMake(Width_Window-80, 35, 70, 30);
    [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [logBtn setBackgroundImage:[UIImage pureColorImageWithSize:logBtn.frame.size color:[UIColor customLightYellowColor] cornRadius:15] forState:UIControlStateNormal];
    [logBtn setBackgroundImage:[UIImage pureColorImageWithSize:logBtn.frame.size color:[UIColor customDetailColor] cornRadius:15] forState:UIControlStateSelected];
    [logBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:logBtn];
    
    _imageV = imageV;
    _nameLabel = nameLabel;
    _msgLabel = msgLabel;
    _logBtn = logBtn;
}
-(void)btnClick{
    if (self.logBtn.isSelected) {
        return;
    }
    if (self.controlClick != nil) {
        self.controlClick(self.model);
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
