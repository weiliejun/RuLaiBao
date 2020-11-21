//
//  DetailAnswerHeaderView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "DetailAnswerHeaderView.h"
#import "Configure.h"
#import "GroupTopicCommentModel.h"
#import "TYAttributedLabel.h"

@interface DetailAnswerHeaderView ()
@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) TYAttributedLabel *detailHeaderLabel;
@property (nonatomic, weak) UIButton *replyBtn;

@property (nonatomic, weak) UIImageView *photoImageV;
@end

@implementation DetailAnswerHeaderView
- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createCellUI];
    }
    return self;
}
-(void)setModel:(GroupTopicCommentModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.commentPhoto] placeholderImage:[UIImage imageNamed:@"information_header"] options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.commentName];
    _timeLabel.text = [NSString stringWithFormat:@"%@",model.commentTime];

    self.detailHeaderLabel.textContainer = model.commentTextContainer;
    self.detailHeaderLabel.frame = model.frameLayout;
    
    if (!CGRectEqualToRect(model.commentPhotoRect, CGRectZero)) {
        self.photoImageV.frame = model.commentPhotoRect;
        [self.photoImageV sd_setImageWithURL:[NSURL URLWithString:model.commentLinkPhoto] placeholderImage:[UIImage imageNamed:@""]];
        
        self.replyBtn.frame = CGRectMake(Width_Window-60, self.photoImageV.bottom + 5, 50, 30);
    }else{
        [_photoImageV removeFromSuperview];
        _photoImageV = nil;
        self.replyBtn.frame = CGRectMake(Width_Window-60, self.detailHeaderLabel.bottom + 5, 50, 30);
    }
}

#pragma mark - createUI
-(void)createCellUI{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, Width_Window-20, 1)];
    lineView.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:lineView];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    imageV.image = [UIImage imageNamed:@"information_header"];
    imageV.layer.cornerRadius = 20.f;
    imageV.layer.masksToBounds = YES;
    //优化
    imageV.layer.shouldRasterize = YES;
    imageV.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.contentView addSubview:imageV];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageV.right+10, 10, Width_Window-10-40-10-10-100-10, 40)];
    nameLabel.textColor = [UIColor customTitleColor];
    nameLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:nameLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right+10, 10, 100, 40)];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor customDetailColor];
    timeLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:timeLabel];
    
    TYAttributedLabel *detailLabel = [[TYAttributedLabel alloc]init];
    //与cell的进行区分
    detailLabel.tag = 10086;
    detailLabel.numberOfLines = 0;
    detailLabel.textColor = [UIColor customTitleColor];
    [self.contentView addSubview:detailLabel];
    
    UIButton *replyBtn = [[UIButton alloc]init];
    [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    [replyBtn setTitleColor:[UIColor customBlueColor] forState:UIControlStateNormal];
    [replyBtn addTarget:self action:@selector(replyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:replyBtn];
    
    _imageV = imageV;
    _nameLabel = nameLabel;
    _timeLabel = timeLabel;
    _detailHeaderLabel = detailLabel;
    _replyBtn = replyBtn;
}
-(void)replyBtnClick{
    //回调
    if (self.replyBtnClickBlock != nil) {
        self.replyBtnClickBlock(self);
    }
}

#pragma mark - 懒加载
- (UIImageView *)photoImageV{
    if (_photoImageV == nil) {
        //只会在话题详情中存在
        UIImageView *photoImageV = [[UIImageView alloc]init];
        photoImageV.contentMode = UIViewContentModeScaleAspectFill;
        photoImageV.clipsToBounds = YES;
        [self.contentView addSubview:photoImageV];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [photoImageV addGestureRecognizer:tapGesture];
        photoImageV.userInteractionEnabled = YES;
        
        _photoImageV = photoImageV;
    }
    return _photoImageV;
}
- (void)clickImage{
    if (self.commentImageClickBlock) {
        self.commentImageClickBlock(self.model.commentLinkPhotoBig);
    }
}
@end
