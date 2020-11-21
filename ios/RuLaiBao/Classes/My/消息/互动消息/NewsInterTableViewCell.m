//
//  NewsInterTableViewCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/20.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "NewsInterTableViewCell.h"
#import "Configure.h"
#import "NewsInterModel.h"

@interface NewsInterTableViewCell ()
@property (nonatomic, weak) UIImageView *headImageV;
@property (nonatomic, weak) UILabel *authorLabel;
@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *replyLabel;

@property (nonatomic, weak) UIImageView *bgImageV;
@property (nonatomic, weak) UIView *lineView;

@end

@implementation NewsInterTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCellUI];
        [self createUILayout];
    }
    return self;
}

-(void)setCellInfoModel:(NewsInterModel *)cellInfoModel{
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload;
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:cellInfoModel.replyPhoto] placeholderImage:[UIImage imageNamed:@"information_header"] options:options];
    self.authorLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.replyName];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.createTime];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.replyContent];
    self.replyLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.themeContent];
}

#pragma mark - UI
-(void)createCellUI{
    UIImageView *headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    headImageV.layer.cornerRadius = 20.f;
    headImageV.layer.masksToBounds = YES;
    //优化
    headImageV.layer.shouldRasterize = YES;
    headImageV.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.contentView addSubview:headImageV];
    
    UILabel *authorLabel = [[UILabel alloc]init];
    authorLabel.textColor = [UIColor customTitleColor];
    authorLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:authorLabel];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor customDetailColor];
    timeLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:timeLabel];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 2;
    [titleLabel sizeToFit];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textColor = [UIColor customTitleColor];
    [self.contentView addSubview:titleLabel];
    
    UIImageView *bgImageV = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"discussionLike"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    bgImageV.image = image;
    [self.contentView addSubview:bgImageV];
    
    UILabel *replyLabel = [[UILabel alloc]init];
    replyLabel.numberOfLines = 1;
    replyLabel.font = [UIFont systemFontOfSize:16.0];
    replyLabel.textColor = [UIColor customDetailColor];
    [bgImageV addSubview:replyLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:lineView];
    
    _headImageV = headImageV;
    _authorLabel = authorLabel;
    _timeLabel = timeLabel;
    _titleLabel = titleLabel;
    _bgImageV = bgImageV;
    _replyLabel = replyLabel;
    _lineView = lineView;
}
#pragma mark - 添加约束
-(void)createUILayout{
    WeakSelf
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.left.mas_equalTo(strongSelf.contentView).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.contentView.mas_top).offset(10);
        make.left.mas_equalTo(strongSelf.headImageV.mas_right).offset(10);
        make.height.mas_equalTo(40);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.contentView.mas_top).offset(10);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
        make.height.mas_equalTo(40); make.left.mas_greaterThanOrEqualTo(strongSelf.authorLabel.mas_right).offset(10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(strongSelf.contentView).offset(10);
        make.right.equalTo(strongSelf.contentView).offset(-10);
        make.top.mas_equalTo(strongSelf.headImageV.mas_bottom).offset(10);
    }];

    [self.bgImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.bottom.mas_equalTo(strongSelf.contentView.mas_bottom).offset(-10).priority(500);
    }];
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.bgImageV.mas_top).offset(10);
        make.left.mas_equalTo(strongSelf.bgImageV.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.bgImageV.mas_right).offset(-10);
        make.height.mas_equalTo(25);
        make.bottom.mas_equalTo(strongSelf.bgImageV.mas_bottom).offset(-5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(0);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(0);
        make.bottom.mas_equalTo(strongSelf.contentView.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
    }];
    
    /** 此处可以自适应宽度，title不可以被压缩，所以最小也得全部显示 */
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];//不可以被压缩，尽量显示完整
    [self.authorLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];//宽度不够时，可以被压缩
    [self.timeLabel setContentHuggingPriority:UILayoutPriorityRequired/*抱紧*/
                                        forAxis:UILayoutConstraintAxisHorizontal];
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
