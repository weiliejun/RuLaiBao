//
//  GroupDetailTableViewCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/5.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "GroupDetailTableViewCell.h"
#import "Configure.h"

#import "GroupDetailTopicModel.h"

@interface GroupDetailTableViewCell ()

@property (nonatomic, weak) UIImageView *headImageV;
@property (nonatomic, weak) UILabel *authorLabel;
@property (nonatomic, weak) UILabel *msgLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIControl *msgControl;
@property (nonatomic, weak) UILabel *msgNumLabel;
@property (nonatomic, weak) UIControl *linkControl;
@property (nonatomic, weak) UILabel *linkNumLabel;
@property (nonatomic, weak) UIImageView *linkImageV;
@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, assign) NSInteger likeCount;
@end

@implementation GroupDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCellUI];
        [self createUILayout];
    }
    return self;
}
-(void)setGroupDetailModel:(GroupDetailTopicModel *)groupDetailModel{
    _groupDetailModel = groupDetailModel;
    
    self.authorLabel.text = [NSString stringWithFormat:@"%@",groupDetailModel.creatorName];
    self.msgLabel.text = [NSString stringWithFormat:@"%@",groupDetailModel.topicContent];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",groupDetailModel.createTime];
    self.msgNumLabel.text = [NSString stringWithFormat:@"%@",groupDetailModel.commentCount];
    self.linkNumLabel.text = [NSString stringWithFormat:@"%@",groupDetailModel.likeCount];
    self.likeCount = [groupDetailModel.likeCount integerValue];
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload;
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:groupDetailModel.creatorPhoto] placeholderImage:[UIImage imageNamed:@"information_header"] options:options];
    
    if ([[NSString stringWithFormat:@"%@",groupDetailModel.likeStatus] isEqualToString:@"yes"]) {
        self.linkImageV.highlighted = YES;
        self.linkNumLabel.textColor = [UIColor customDeepYellowColor];
    }else{
        self.linkImageV.highlighted = NO;
        self.linkNumLabel.textColor = [UIColor customTitleColor];
    }
}
-(void)setIsLikeSelect:(BOOL)isLikeSelect{
    _isLikeSelect = isLikeSelect;
    if (isLikeSelect) {
        //变化图标和数字
        self.linkImageV.highlighted = YES;
        self.likeCount ++;
        self.linkNumLabel.text = [NSString stringWithFormat:@"%ld",self.likeCount];
        self.linkNumLabel.textColor = [UIColor customDeepYellowColor];
    }else{
        self.likeCount --;
        self.linkImageV.highlighted = NO;
        self.linkNumLabel.text = [NSString stringWithFormat:@"%ld",self.likeCount];
        self.linkNumLabel.textColor = [UIColor customTitleColor];
    }
}

#pragma mark - UI & layout
-(void)createCellUI{
    UIImageView *headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    headImageV.image = [UIImage imageNamed:@"information_header"];
    headImageV.layer.cornerRadius = 20.f;
    headImageV.layer.masksToBounds = YES;
    //优化
    headImageV.layer.shouldRasterize = YES;
    headImageV.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.contentView addSubview:headImageV];
    
    UILabel *authorLabel = [[UILabel alloc]init];
    authorLabel.font = [UIFont systemFontOfSize:16.0];
    authorLabel.textColor = [UIColor customTitleColor];
    [self.contentView addSubview:authorLabel];
    
    UILabel *msgLabel = [[UILabel alloc]init];
    msgLabel.font = [UIFont systemFontOfSize:18.0];
    msgLabel.textColor = [UIColor customTitleColor];
    msgLabel.numberOfLines = 3;
    [self.contentView addSubview:msgLabel];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = [UIFont systemFontOfSize:16.0];
    timeLabel.textColor = [UIColor customDetailColor];
    [self.contentView addSubview:timeLabel];
    
    UIControl *msgControl = [[UIControl alloc]init];
    msgControl.tag = GroupDetailCellControlTypeMsg;
    msgControl.userInteractionEnabled = NO;
    [msgControl addTarget:self action:@selector(linkControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:msgControl];
    
    UIImageView *msgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 20, 20)];
    msgImageV.image = [UIImage imageNamed:@"YX_Reply"];
    [msgControl addSubview:msgImageV];
    
    UILabel *msgNumLabel = [[UILabel alloc]init];
    msgNumLabel.font = [UIFont systemFontOfSize:16.0];
    msgNumLabel.textColor = [UIColor customDetailColor];
    [msgControl addSubview:msgNumLabel];
    
    UIControl *linkControl = [[UIControl alloc]init];
    linkControl.tag = GroupDetailCellControlTypeLink;
    [linkControl addTarget:self action:@selector(linkControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:linkControl];
    
    UIImageView *linkImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 20, 20)];
    linkImageV.image = [UIImage imageNamed:@"YX_Like"];
    linkImageV.highlightedImage = [UIImage imageNamed:@"YX_Like_Select"];
    [linkControl addSubview:linkImageV];
    
    UILabel *linkNumLabel = [[UILabel alloc]init];
    linkNumLabel.textColor = [UIColor customDetailColor];
    [linkControl addSubview:linkNumLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:lineView];
    
    _headImageV = headImageV;
    _authorLabel = authorLabel;
    _msgLabel = msgLabel;
    _timeLabel = timeLabel;
    _msgControl = msgControl;
    _msgNumLabel = msgNumLabel;
    _linkControl = linkControl;
    _linkNumLabel = linkNumLabel;
    _linkImageV = linkImageV;
    _lineView = lineView;
}

-(void)linkControlClick:(UIControl *)sender{
    if (sender.tag == GroupDetailCellControlTypeMsg) {
        return;
    }
    if (sender.tag == GroupDetailCellControlTypeLink) {
        if (self.linkImageV.isHighlighted) {
            return;
        }
    }
    if (self.controlClick != nil) {
        self.controlClick(sender.tag, self);
    }
}
#pragma mark - 添加约束
-(void)createUILayout{
    WeakSelf
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.left.equalTo(strongSelf.contentView).offset(10);
        make.height.width.mas_equalTo(40);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.contentView.mas_top).offset(10);
        make.left.mas_equalTo(strongSelf.headImageV.mas_right).offset(10);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(40);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.headImageV.mas_bottom).offset(10);
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.msgLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
        make.width.mas_lessThanOrEqualTo(170);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(strongSelf.contentView.mas_bottom).offset(-10).priority(500);
    }];
    [self.linkControl mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.msgLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    [self.linkNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.mas_equalTo(strongSelf.linkControl.mas_left).offset(25);
        make.top.mas_equalTo(strongSelf.linkControl.mas_top).offset(5);
        make.bottom.mas_equalTo(strongSelf.linkControl.mas_bottom).offset(-5);
        make.right.mas_equalTo(strongSelf.linkControl.mas_right).offset(0);
    }];
    
    [self.msgControl mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.msgLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(strongSelf.linkControl.mas_left).offset(-10);
        make.left.mas_greaterThanOrEqualTo(strongSelf.timeLabel.mas_right).offset(10);
        make.height.mas_equalTo(30);
    }];
    [self.msgNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.mas_equalTo(strongSelf.msgControl.mas_left).offset(25);
        make.top.mas_equalTo(strongSelf.msgControl.mas_top).offset(5);
        make.bottom.mas_equalTo(strongSelf.msgControl.mas_bottom).offset(-5);
        make.right.mas_equalTo(strongSelf.msgControl.mas_right).offset(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(strongSelf.contentView.mas_bottom).offset(0);
    }];
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
