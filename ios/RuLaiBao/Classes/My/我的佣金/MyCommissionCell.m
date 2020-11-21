//
//  MyCommissionCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyCommissionCell.h"
#import "Configure.h"

@interface  MyCommissionCell ()

/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 说明 */
@property (nonatomic, weak) UILabel *detailLabel;

@end


@implementation MyCommissionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   self = [super initWithStyle:style
         reuseIdentifier:reuseIdentifier];
    if (self ) {
        [self createCell];
    }
    return self;
}

#pragma mark - 创建cell
- (void)createCell {
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor customNavBarColor];
    titleLabel.text = @"我的工资单";
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.width.mas_equalTo(Width_Window-50);
        make.height.mas_equalTo(20);
    }];
    
    //说明
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = [UIColor customDetailColor];
    detailLabel.text = @"查看各月的佣金情况";
    detailLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:detailLabel];
    self.detailLabel = detailLabel;
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(Width_Window-50);
        make.height.mas_equalTo(20);
    }];
    
    //横线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.top.equalTo(self.contentView.mas_top).offset(69);
        make.width.mas_equalTo(Width_Window);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)setTitleWithTitleStr:(NSString *)titleStr detailStr:(NSString *)detailStr {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",titleStr];
    self.detailLabel.text = [NSString stringWithFormat:@"%@",detailStr];
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
