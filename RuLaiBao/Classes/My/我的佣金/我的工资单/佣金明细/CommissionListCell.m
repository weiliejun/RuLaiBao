//
//  CommissionListCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/14.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "CommissionListCell.h"
#import "Configure.h"
#import "CommissionListModel.h"
#import "ChangeNumber.h"


@interface CommissionListCell ()

/** 产品名称 */
@property (nonatomic, strong) UILabel *productNameLabel;
/** 收益时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 收益金额 */
@property (nonatomic, strong) UILabel *moneyLabel;


@end

@implementation CommissionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

#pragma mark - 创建cell
- (void)createCell {
    // 产品名称
    UILabel *productNameLabel = [[UILabel alloc]init];
    productNameLabel.text = @"--";
    productNameLabel.textColor = [UIColor customTitleColor];
    productNameLabel.textAlignment = NSTextAlignmentLeft;
    productNameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:productNameLabel];
    self.productNameLabel = productNameLabel;
    [productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.mas_equalTo(Width_Window/2+10);
        make.height.mas_equalTo(20);
    }];
    
    // 收益时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"收益日期：2018-11-15";
    timeLabel.textColor = [UIColor customDetailColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(productNameLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(Width_Window/2+10);
        make.height.mas_equalTo(20);
    }];
    
    // 收益金额
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.text = @"+0.00元";
    moneyLabel.textColor = [UIColor customTitleColor];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Width_Window/2+20);
        make.top.equalTo(self.contentView.mas_top).offset(22);
        make.width.mas_equalTo(Width_Window/2-50);
        make.height.mas_equalTo(20);
    }];
    
    //横线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_bottom).offset(-1);
        make.width.mas_equalTo(Width_Window-20);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - 设置交易明细列表数据
- (void)setCommissionListModelWithDictionary:(CommissionListModel *)model {
    // 产品名称
    self.productNameLabel.text = [NSString stringWithFormat:@"%@",model.productName];
    // 收益日期
    self.timeLabel.text = [NSString stringWithFormat:@"收益日期：%@",model.commissionTime];

    // 收益金额
    NSString *moneyStr = [[ChangeNumber alloc]changeNumber:model.commissionGained];
    self.moneyLabel.text = [NSString stringWithFormat:@"+%@",moneyStr];
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
