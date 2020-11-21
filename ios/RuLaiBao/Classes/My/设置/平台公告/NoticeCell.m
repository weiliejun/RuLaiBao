//
//  NoticeCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/20.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "NoticeCell.h"
#import "Configure.h"
#import "NoticeModel.h"

@interface NoticeCell ()
@property (nonatomic, weak) UILabel *titleLabel;//名称
@property (nonatomic, weak) UILabel *timeLabel;//时间
@property (nonatomic, weak) UILabel *detailedLabel;//内容

@end

@implementation NoticeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

#pragma mark - 创建Cell
- (void)createCell{
    //名称
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"公告通知标题";
    titleLabel.textColor = [UIColor customNavBarColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo(@(Width_Window*2/3-20));
        make.height.mas_equalTo(@20);
    }];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"05-04 12:30";
    timeLabel.textColor = [UIColor customNavBarColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Width_Window*2/3);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-38);
        make.height.mas_equalTo(@20);
    }];
    
   //内容
    UILabel *detailedLabel = [[UILabel alloc]init];
    detailedLabel.text = @"回复内容";
    detailedLabel.textColor = [UIColor customDetailColor];
    detailedLabel.textAlignment = NSTextAlignmentLeft;
    detailedLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:detailedLabel];
    self.detailedLabel = detailedLabel;
    [detailedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-38);
        make.height.mas_equalTo(@20);
    }];
    
    // 右侧箭头
    UIImageView *arrowImage = [[UIImageView alloc]init];
    arrowImage.contentMode = UIViewContentModeScaleAspectFill;
    arrowImage.image = [UIImage imageNamed:@"arrow_r"];
    [self.contentView addSubview:arrowImage];
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_right).offset(-18);
        make.top.equalTo(self.contentView.mas_top).offset(28);
        make.width.mas_equalTo(@(8));
        make.height.mas_equalTo(@14);
    }];
    
    //横线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, 49, Width_Window-30, 1)];
    line.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_bottom).offset(-1);
        make.width.mas_equalTo(@(Width_Window-20));
        make.height.mas_equalTo(@1);
    }];
}

- (void)setNoticeModelWithDictionary:(NoticeModel *)model{
    //名称
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.topic];
    //时间
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.publishTime];
    //内容
    self.detailedLabel.text = [NSString stringWithFormat:@"%@",model.descriptionStr];
    
    //判断是否已读
    if ([model.readState isEqualToString:@"no"]) {
        self.titleLabel.textColor = [UIColor customNavBarColor];
        self.timeLabel.textColor = [UIColor customNavBarColor];
        
    }else {
        self.titleLabel.textColor = [UIColor customDetailColor];
        self.timeLabel.textColor = [UIColor customDetailColor];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end



