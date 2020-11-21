//
//  UnpayCommissionCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "UnpayCommissionCell.h"
#import "Configure.h"
#import "UnpayCommissionModel.h"


@interface  UnpayCommissionCell ()

/** 产品名称 */
@property (nonatomic, weak) UILabel *productNameLabel;
/** 客户姓名 */
@property (nonatomic, weak) UILabel *customerNameLabel;
/** 已交保费 */
@property (nonatomic, weak) UILabel *feeLabel;
/** 保险期限 */
@property (nonatomic, weak) UILabel *timeLimitLabel;
/** 图标 */
@property (nonatomic, weak) UIImageView *logoImage;

@end


@implementation UnpayCommissionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

#pragma mark - 创建cell
- (void)createCell {
    //背景view
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.mas_equalTo(@(Width_Window-20));
        make.height.mas_equalTo(@160);
    }];
    
    //产品名称
    UILabel *productNameLabel = [[UILabel alloc]init];
    productNameLabel.text = @"---";
    productNameLabel.textColor = [UIColor customTitleColor];
    productNameLabel.textAlignment = NSTextAlignmentLeft;
    productNameLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:productNameLabel];
    self.productNameLabel = productNameLabel;
    [productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        make.top.equalTo(bgView.mas_top).offset(15);
        make.width.mas_equalTo(@(Width_Window-40));
        make.height.mas_equalTo(@20);
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor customLineColor];
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(0);
        make.top.equalTo(productNameLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(@(Width_Window-20));
        make.height.mas_equalTo(@1);
    }];
    
    //客户姓名
    UILabel *customerNameLabel = [[UILabel alloc]init];
    customerNameLabel.text = @"客户姓名：---";
    customerNameLabel.textColor = [UIColor customDetailColor];
    customerNameLabel.textAlignment = NSTextAlignmentLeft;
    customerNameLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:customerNameLabel];
    self.customerNameLabel = customerNameLabel;
    [customerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(20);
        make.top.equalTo(line.mas_bottom).offset(10);
        make.width.mas_equalTo(@(Width_Window-140));
        make.height.mas_equalTo(@20);
    }];
    
    //已交保费
    UILabel *feeLabel = [[UILabel alloc]init];
    feeLabel.text = @"已交保费：0.00元";
    feeLabel.textColor = [UIColor customDetailColor];
    feeLabel.textAlignment = NSTextAlignmentLeft;
    feeLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:feeLabel];
    self.feeLabel = feeLabel;
    [feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(20);
        make.top.equalTo(customerNameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@(Width_Window-140));
        make.height.mas_equalTo(@20);
    }];
    //保险期限
    UILabel *timeLimitLabel = [[UILabel alloc]init];
    timeLimitLabel.text = @"保险期限：--年";
    timeLimitLabel.textColor = [UIColor customDetailColor];
    timeLimitLabel.textAlignment = NSTextAlignmentLeft;
    timeLimitLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:timeLimitLabel];
    self.timeLimitLabel = timeLimitLabel;
    [timeLimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(20);
        make.top.equalTo(feeLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@(Width_Window-140));
        make.height.mas_equalTo(@20);
    }];
    
    //logo
    UIImageView *logoImage = [[UIImageView alloc]init];
    logoImage.image = [UIImage imageNamed:@"product_default"];
    [bgView addSubview:logoImage];
    self.logoImage = logoImage;
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Width_Window-100);
        make.top.equalTo(line.mas_bottom).offset(20);
        make.width.mas_equalTo(@(70));
        make.height.mas_equalTo(@70);
    }];
}

//设置待发佣金数据
- (void)setUnpayModelWithDictionary:(UnpayCommissionModel *)model {
    //产品名称
    self.productNameLabel.text = [NSString stringWithFormat:@"%@",model.productName];
    //客户姓名 */
    self.customerNameLabel.text = [NSString stringWithFormat:@"客户姓名：%@",model.userName];
    //已交保费
    self.feeLabel.text = [NSString stringWithFormat:@"已交保费：%@元",model.paymentedPremiums];
    //保险期限
    self.timeLimitLabel.text = [NSString stringWithFormat:@"保险期限：%@",model.insurancePeriod];
    //图标
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"product_default"]];
    
}

//设置已发佣金数据
- (void)setPayedModelWithDictionary:(UnpayCommissionModel *)model {
    //产品名称
    self.productNameLabel.text = [NSString stringWithFormat:@"%@",model.productName];
    //客户姓名 */
    self.customerNameLabel.text = [NSString stringWithFormat:@"客户姓名：%@",model.userName];
    //已交保费
    self.feeLabel.text = [NSString stringWithFormat:@"已交保费：%@元",model.paymentedPremiums];
    //保险期限
    self.timeLimitLabel.text = [NSString stringWithFormat:@"保险期限：%@",model.insurancePeriod];
    //图标
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"product_default"]];
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
