//
//  TradeListCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "TradeListCell.h"
#import "Configure.h"
#import "TradeListModel.h"

@interface TradeListCell ()
@property (nonatomic, weak) UILabel *nameLabel;//产品名称
@property (nonatomic, weak) UILabel *numberLabel;//编号
@property (nonatomic, weak) UILabel *moneyLabel;//金额

@end

@implementation TradeListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        [self creataCell];
    }
    return self;
}

#pragma mark - 创建cell
- (void)creataCell{
    //产品名称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"国华信托 - 盛世年华年金保险";
    nameLabel.textColor = [UIColor customTitleColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.greaterThanOrEqualTo(@(Width_Window/2-20));
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    //编号
    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.text = @"2018041689302945";
    numberLabel.textColor = [UIColor customDetailColor];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(nameLabel.mas_bottom).offset(0);
        make.width.greaterThanOrEqualTo(@(Width_Window/2-20));
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    //金额
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.text = @"+200.00";
    moneyLabel.textColor = [UIColor customTitleColor];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Width_Window/2+10);
        make.top.equalTo(self.contentView.mas_top).offset(25);
        make.width.greaterThanOrEqualTo(@(Width_Window/2-20));
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    //横线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.top.equalTo(self.contentView.mas_top).offset(69);
        make.width.greaterThanOrEqualTo(@(Width_Window));
        make.height.greaterThanOrEqualTo(@1);
    }];
}

- (void)setTradeListModelWithDictionary:(TradeListModel *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.productName];
    
    if ([model.orderCode isEqualToString:@""]) {
        self.numberLabel.text = @"--";
    }else{
        self.numberLabel.text = [NSString stringWithFormat:@"%@",model.orderCode];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"+%@",model.commissionGained];
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
