//
//  DetailQuestionTopView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/9.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "DetailQuestionTopView.h"
#import "Configure.h"
#import "QAListModel.h"

@interface DetailQuestionTopView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *headImageV;
@property (nonatomic, weak) UILabel *authorLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UILabel *detailLabel;
@end

@implementation DetailQuestionTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        //此处若变换label的字间距或者行间距，请重写布局，不可使用layout
        [self addUILayout];
    }
    return self;
}
-(void)setQuestionModel:(QAListModel *)questionModel{
    if (questionModel == nil) {
        WeakSelf
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            StrongSelf
            make.top.mas_equalTo(strongSelf.mas_top).offset(0);
        }];
        [self.headImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            StrongSelf
            make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }];
        [self.authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            StrongSelf
            make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }];
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            StrongSelf
            make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            StrongSelf
            make.top.mas_equalTo(strongSelf.headImageV.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }];
        [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            StrongSelf
            make.top.mas_equalTo(strongSelf.lineView.mas_bottom).offset(0);
             make.bottom.mas_equalTo(strongSelf.mas_bottom).offset(0).priority(500);
        }];
        return;
    }else{
        WeakSelf
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            StrongSelf
            make.top.mas_equalTo(strongSelf.mas_top).offset(10);
        }];
        [self.headImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            StrongSelf
            make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(40);
        }];
        [self.authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            StrongSelf
            make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(30);
        }];
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            StrongSelf
            make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(30);
        }];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            StrongSelf
            make.top.mas_equalTo(strongSelf.headImageV.mas_bottom).offset(10);
            make.height.mas_equalTo(1);
        }];
        [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            StrongSelf
            make.top.mas_equalTo(strongSelf.lineView.mas_bottom).offset(10);
            make.bottom.mas_equalTo(strongSelf.mas_bottom).offset(-10).priority(500);
        }];
        
    }
    _questionModel = questionModel;
    
    self.titleLabel.text = [[NSString stringWithFormat:@"%@",questionModel.title]isEqualToString:@"(null)"] ? @"" : [NSString stringWithFormat:@"%@",questionModel.title];
    self.authorLabel.text = [[NSString stringWithFormat:@"%@",questionModel.userName]isEqualToString:@"(null)"] ? @"" : [NSString stringWithFormat:@"%@",questionModel.userName];
    self.timeLabel.text = [[NSString stringWithFormat:@"%@",questionModel.time]isEqualToString:@"(null)"] ? @"0000:00:00" : [NSString stringWithFormat:@"%@",questionModel.time];
    self.detailLabel.text = [[NSString stringWithFormat:@"%@",questionModel.descript]isEqualToString:@"(null)"] ? @"" : [NSString stringWithFormat:@"%@",questionModel.descript];
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload;
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:questionModel.userPhoto] placeholderImage:[UIImage imageNamed:@"information_header"] options:options];
}

-(void)createUI{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.preferredMaxLayoutWidth = self.width-20;
    [self addSubview:titleLabel];
    
    UIImageView *headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    headImageV.image = [UIImage imageNamed:@"information_header"];
    headImageV.layer.cornerRadius = 20.f;
    headImageV.layer.masksToBounds = YES;
    //优化
    headImageV.layer.shouldRasterize = YES;
    headImageV.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:headImageV];
    
    UILabel *authorLabel = [[UILabel alloc]init];
    authorLabel.font = [UIFont systemFontOfSize:16.0];
    authorLabel.textColor = [UIColor customTitleColor];
    [self addSubview:authorLabel];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = [UIFont systemFontOfSize:14.0];
    timeLabel.textColor = [UIColor customDetailColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:timeLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor customLineColor];
    [self addSubview:lineView];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:16.0];
    detailLabel.textColor = [UIColor customTitleColor];
    detailLabel.preferredMaxLayoutWidth = self.width-20;
    [self addSubview:detailLabel];
    
    _titleLabel = titleLabel;
    _headImageV = headImageV;
    _authorLabel = authorLabel;
    _timeLabel = timeLabel;
    _lineView = lineView;
    _detailLabel = detailLabel;
}

-(void)addUILayout{
    WeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.mas_top).offset(0);
        make.left.mas_equalTo(strongSelf.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
    }];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(strongSelf.mas_left).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(0);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(strongSelf.headImageV.mas_right).offset(10);
        make.right.mas_equalTo(strongSelf.timeLabel.mas_left).offset(-10);
        make.height.mas_equalTo(0);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
        make.width.mas_lessThanOrEqualTo(170);
        make.height.mas_equalTo(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.headImageV.mas_bottom).offset(0);
        make.left.mas_equalTo(strongSelf.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
        make.height.mas_equalTo(0);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.lineView.mas_bottom).offset(0);
        make.left.mas_equalTo(strongSelf.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
        make.bottom.mas_equalTo(strongSelf.mas_bottom).offset(0).priority(500);
    }];
    /** 此处可以自适应宽度，title不可以被压缩，所以最小也得全部显示 */
    [self.authorLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];//不可以被压缩，尽量显示完整
    [self.authorLabel setContentHuggingPriority:UILayoutPriorityRequired/*抱紧*/
                                       forAxis:UILayoutConstraintAxisVertical];
}

@end
