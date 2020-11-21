//
//  AppointmentCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/17.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyAppointmentCell.h"
#import "Configure.h"
#import "MyAppointListModel.h"

@interface MyAppointmentCell ()
@property (nonatomic, weak) UILabel *nameLabel;//名称
@property (nonatomic, weak) UILabel *statusLabel;//状态
@property (nonatomic, weak) UILabel *moneyLabel;//金额

@end

@implementation MyAppointmentCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

#pragma mark - 创建Cell
- (void)createCell{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.mas_equalTo(@(Width_Window-20));
        make.height.mas_equalTo(@100);
    }];
    
    //名称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"---";
    nameLabel.textColor = [UIColor customTitleColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.top.equalTo(bgView.mas_top).offset(15);
        make.width.mas_equalTo(@(Width_Window-120));
        make.height.mas_equalTo(@20);
    }];
    
    //状态
    UILabel *statusLabel = [[UILabel alloc]init];
    statusLabel.text = @"--";
    statusLabel.textColor = [UIColor customDetailColor];
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:statusLabel];
    self.statusLabel = statusLabel;
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(Width_Window-100);
        make.top.equalTo(bgView.mas_top).offset(15);
        make.width.mas_equalTo(@(70));
        make.height.mas_equalTo(@20);
    }];
    
    //横线
    UILabel *horizontal = [[UILabel alloc]init];
    horizontal.backgroundColor = [UIColor customLineColor];
    [bgView addSubview:horizontal];
    [horizontal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(0);
        make.top.equalTo(bgView.mas_top).offset(50);
        make.width.mas_equalTo(@(Width_Window-20));
        make.height.mas_equalTo(@1);
    }];
    
   //金额
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.text = @"0.00元";
    moneyLabel.textColor = [UIColor customDetailColor];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    moneyLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.top.equalTo(nameLabel.mas_bottom).offset(30);
        make.width.mas_equalTo(@(Width_Window-40));
        make.height.mas_equalTo(@20);
    }];
}

- (void)setMyAppointListModelWithDictionary:(MyAppointListModel *)model{
    //名称
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.productName];
    //状态
    self.statusLabel.text = [NSString stringWithFormat:@"%@",model.statusStr];
    //金额
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",model.insuranceAmount];
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
