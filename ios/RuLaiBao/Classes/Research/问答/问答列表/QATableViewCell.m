//
//  QATableViewCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/9.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "QATableViewCell.h"
#import "Configure.h"
#import "QAListModel.h"

@interface QATableViewCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *answerNumLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIImageView *headImageV;
@property (nonatomic, weak) UILabel *authorLabel;
@property (nonatomic, weak) UILabel *answerLabel;

@end

@implementation QATableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCellUI];
        [self createUILayout];
    }
    return self;
}
-(void)setCellInfoModel:(QAListModel *)cellInfoModel{
    _cellInfoModel = cellInfoModel;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.title];
    self.answerNumLabel.text = [NSString stringWithFormat:@"%@回答",cellInfoModel.answerCount];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.time];
    
    if([cellInfoModel.answerCount isEqualToString:@"0"]){
        self.headImageV.hidden = YES;
        self.authorLabel.hidden = YES;
        self.answerLabel.hidden = YES;
        [self.headImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.answerNumLabel.mas_bottom).offset(0);
            make.height.width.mas_equalTo(0);
        }];
        [self.authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.answerNumLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }];
        [self.answerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImageV.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }];
    }else{
        self.headImageV.hidden = NO;
        self.authorLabel.hidden = NO;
        self.answerLabel.hidden = NO;
        [self.headImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.answerNumLabel.mas_bottom).offset(10);
            make.height.width.mas_equalTo(40);
        }];
        [self.authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.answerNumLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(30);
        }];
        [self.answerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.top.mas_equalTo(self.headImageV.mas_bottom).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15).priority(500);
        }];
        
        SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload;
        [self.headImageV sd_setImageWithURL:[NSURL URLWithString:cellInfoModel.answerPhoto] placeholderImage:[UIImage imageNamed:@"information_header"] options:options];
        
        self.authorLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.answerName];
        self.answerLabel.text = [NSString stringWithFormat:@"答：%@",cellInfoModel.answerContent];
    }
}

-(void)createCellUI{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    [titleLabel sizeToFit];
    titleLabel.preferredMaxLayoutWidth = Width_Window-20;
    [self.contentView addSubview:titleLabel];
    
    UILabel *answerNumLabel = [[UILabel alloc]init];
    answerNumLabel.textColor = [UIColor customDetailColor];
    answerNumLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:answerNumLabel];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor customDetailColor];
    timeLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:timeLabel];
    
    UIImageView *headImageV = [[UIImageView alloc]init];
    headImageV.image = [UIImage imageNamed:@"information_header"];
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
    
    UILabel *answerLabel = [[UILabel alloc]init];
    answerLabel.numberOfLines = 2;
    [answerLabel sizeToFit];
    answerLabel.textColor = [UIColor customTitleColor];
    answerLabel.font = [UIFont systemFontOfSize:16.0];
    answerLabel.preferredMaxLayoutWidth = Width_Window-20;
    [self.contentView addSubview:answerLabel];
    
    _titleLabel = titleLabel;
    _answerNumLabel = answerNumLabel;
    _timeLabel = timeLabel;
    _headImageV = headImageV;
    _authorLabel = authorLabel;
    _answerLabel = answerLabel;
}
#pragma mark - 添加约束
-(void)createUILayout{
    WeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.contentView.mas_top).offset(15);
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
    }];
    [self.answerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
        make.height.mas_equalTo(30);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(10);
        make.left.mas_greaterThanOrEqualTo(strongSelf.answerNumLabel.mas_right).offset(10);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.width.mas_lessThanOrEqualTo(170);
        make.height.mas_equalTo(30);
    }];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.answerNumLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
        make.height.width.mas_equalTo(40);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.answerNumLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(strongSelf.headImageV.mas_right).offset(10);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
        make.top.mas_equalTo(strongSelf.headImageV.mas_bottom).offset(10);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.bottom.mas_equalTo(strongSelf.contentView.mas_bottom).offset(-15).priority(500);
    }];
    /** 此处可以自适应宽度，title不可以被压缩，所以最小也得全部显示 */
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];//不可以被压缩，尽量显示完整
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired/*抱紧*/
                                      forAxis:UILayoutConstraintAxisVertical];
    /** 此处可以自适应宽度，title不可以被压缩，所以最小也得全部显示 */
    [self.answerLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];//不可以被压缩，尽量显示完整
    [self.answerLabel setContentHuggingPriority:UILayoutPriorityRequired/*抱紧*/
                                       forAxis:UILayoutConstraintAxisVertical];
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
