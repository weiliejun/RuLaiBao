//
//  InsuranceCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/3.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "InsuranceCell.h"
#import "Configure.h"
#import "InsuranceListModel.h"
#import "InsuranceSearchModel.h"

@interface InsuranceCell ()
@property (nonatomic, weak) UILabel *nameLabel;//产品名称
@property (nonatomic, weak) UILabel *companyLabel;//保险公司
@property (nonatomic, weak) UILabel *insuranceFeeLabel;//最低保费
@property (nonatomic, weak) UILabel *popularFeeLabel;//推广费
@property (nonatomic, weak) UILabel *sloganLabel;//标语
@property (nonatomic, weak) UIImageView *leftImage;//认证图标

@end


@implementation InsuranceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creataCell];
    }
    return self;
}

#pragma mark - 创建cell
- (void)creataCell{
    //产品名称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"盛世年年年金保险C款";
    nameLabel.textColor = [UIColor customTitleColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@20);
    }];
    //横线1
    UILabel *horizontal1 = [[UILabel alloc]init];
    horizontal1.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:horizontal1];
    [horizontal1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@(Width_Window-20));
        make.height.mas_equalTo(@1);
    }];
    //保险公司
    UILabel *companyLabel = [[UILabel alloc]init];
    companyLabel.text = @"国华人寿";
    companyLabel.textColor = [UIColor customDetailColor];
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:companyLabel];
    self.companyLabel = companyLabel;
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(nameLabel.mas_bottom).offset(25);
        make.width.mas_equalTo(@((Width_Window-40)/3));
        make.height.mas_equalTo(@20);
    }];
    UILabel *companyLabel2 = [[UILabel alloc]init];
    companyLabel2.text = @"保险公司";
    companyLabel2.textColor = [UIColor lightGrayColor];
    companyLabel2.textAlignment = NSTextAlignmentCenter;
    companyLabel2.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:companyLabel2];
    [companyLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(companyLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(@((Width_Window-40)/3));
        make.height.mas_equalTo(@20);
    }];
    //竖线1
    UILabel *vertical1 = [[UILabel alloc]init];
    vertical1.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:vertical1];
    [vertical1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Width_Window/3);
        make.top.equalTo(companyLabel.mas_top).offset(5);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@40);
    }];
    
    //最低保费
    UILabel *insuranceFeeLabel = [[UILabel alloc]init];
    insuranceFeeLabel.text = @"100元起";
    insuranceFeeLabel.textColor = [UIColor customDetailColor];
    insuranceFeeLabel.textAlignment = NSTextAlignmentCenter;
    insuranceFeeLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:insuranceFeeLabel];
    self.insuranceFeeLabel = insuranceFeeLabel;
    [insuranceFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyLabel.mas_right).offset(5);
        make.top.equalTo(nameLabel.mas_bottom).offset(25);
        make.width.mas_equalTo(@((Width_Window-40)/3));
        make.height.mas_equalTo(@20);
    }];
    UILabel *insuranceFeeLabel2 = [[UILabel alloc]init];
    insuranceFeeLabel2.text = @"最低保费";
    insuranceFeeLabel2.textColor = [UIColor lightGrayColor];
    insuranceFeeLabel2.textAlignment = NSTextAlignmentCenter;
    insuranceFeeLabel2.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:insuranceFeeLabel2];
    [insuranceFeeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyLabel.mas_right).offset(5);
        make.top.equalTo(insuranceFeeLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(@((Width_Window-40)/3));
        make.height.mas_equalTo(@20);
    }];
    //竖线2
    UILabel *vertical2 = [[UILabel alloc]init];
    vertical2.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:vertical2];
    [vertical2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Width_Window*2/3);
        make.top.equalTo(companyLabel.mas_top).offset(5);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@40);
    }];
    
    //推广费
    UILabel *popularFeeLabel = [[UILabel alloc]init];
    popularFeeLabel.text = @"25%";
    popularFeeLabel.textColor = [UIColor customLightYellowColor];
    popularFeeLabel.textAlignment = NSTextAlignmentCenter;
    popularFeeLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:popularFeeLabel];
    self.popularFeeLabel = popularFeeLabel;
    [popularFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(nameLabel.mas_bottom).offset(25);
        make.width.mas_equalTo(@((Width_Window-40)/3));
        make.height.mas_equalTo(@20);
    }];
    
    UIImageView *leftImage = [[UIImageView alloc]init];
    leftImage.image = [UIImage imageNamed:@"uncertify"];
    leftImage.layer.masksToBounds = YES;
    leftImage.layer.cornerRadius = 7;
    leftImage.hidden = YES;
    [self.contentView addSubview:leftImage];
    self.leftImage = leftImage;
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(popularFeeLabel.mas_left).offset(-2);
        make.top.equalTo(nameLabel.mas_bottom).offset(27);
        make.width.mas_equalTo(@14);
        make.height.mas_equalTo(@14);
    }];

    UILabel *popularFeeLabel2 = [[UILabel alloc]init];
    popularFeeLabel2.text = @"推广费";
    popularFeeLabel2.textColor = [UIColor lightGrayColor];
    popularFeeLabel2.textAlignment = NSTextAlignmentCenter;
    popularFeeLabel2.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:popularFeeLabel2];
    [popularFeeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(insuranceFeeLabel2.mas_right).offset(5);
        make.top.equalTo(popularFeeLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(@((Width_Window-40)/3));
        make.height.mas_equalTo(@20);
    }];
    //标语
    UILabel *sloganLabel = [[UILabel alloc]init];
    sloganLabel.text = @"千金一诺得利一生，财富相伴幸福永恒";
    sloganLabel.textColor = [UIColor lightGrayColor];
    sloganLabel.textAlignment = NSTextAlignmentLeft;
    sloganLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:sloganLabel];
    self.sloganLabel = sloganLabel;
    [sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(companyLabel2.mas_bottom).offset(15);
        make.width.mas_equalTo(@(Width_Window-30));
        make.height.mas_equalTo(@20);
    }];
    
    //横线2
    UILabel *horizontal2 = [[UILabel alloc]init];
    horizontal2.backgroundColor = [UIColor customBackgroundColor];
    [self.contentView addSubview:horizontal2];
    [horizontal2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.top.equalTo(sloganLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@(Width_Window));
        make.height.mas_equalTo(@10);
    }];
}

#pragma mark - 产品列表
- (void)setInsuranceListModelWithDictionary:(InsuranceListModel *)model{
    //产品名称
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    //保险公司
    self.companyLabel.text = [NSString stringWithFormat:@"%@",model.companyName];
    //最低保费
    if ([model.minimumPremium isEqualToString:@""]) {
        self.insuranceFeeLabel.text = @"--元起";
        
    } else {
        self.insuranceFeeLabel.text = [NSString stringWithFormat:@"%@元起",model.minimumPremium];
    }
    //标语
    self.sloganLabel.text = [NSString stringWithFormat:@"%@",model.recommendations];
    
    //判断登录和认证状态
    //计算text的layout
    if ([StoreTool getLoginStates]) {//登录
        if ([model.checkStatus isEqualToString:@"success"]) {//success认证成功
            self.leftImage.hidden = YES;
            //推广费
            self.popularFeeLabel.text = [NSString stringWithFormat:@"%@%%",model.promotionMoney];
            self.popularFeeLabel.textColor = [UIColor customLightYellowColor];
            self.popularFeeLabel.font = [UIFont systemFontOfSize:16];
            [self.popularFeeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-15);
                make.width.mas_equalTo(@((Width_Window-40)/3));
            }];
        }else{//init未认证（未填写认证信息），submit待认证(提交认证信息待审核)，fail - 认证失败
            self.leftImage.hidden = NO;
            self.leftImage.image = [UIImage imageNamed:@"uncertify"];
            
            self.popularFeeLabel.text = @"认证可见";
            self.popularFeeLabel.textColor = [UIColor customDetailColor];
            self.popularFeeLabel.font = [UIFont systemFontOfSize:16];
            [self.popularFeeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-Width_Window/6+(75+14)/2);
                make.width.mas_equalTo(@(75));
            }];
        }
    }else{
        //未登录
        self.popularFeeLabel.text = @"认证可见";
        self.popularFeeLabel.textColor = [UIColor customDetailColor];
        self.popularFeeLabel.font = [UIFont systemFontOfSize:16];
        [self.popularFeeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-Width_Window/6+(75+14)/2);
            make.width.mas_equalTo(@(75));
        }];
        
        self.leftImage.hidden = NO;
        
        if ([model.checkStatus isEqualToString:@"success"]) {
            //success认证成功
            self.leftImage.image = [UIImage imageNamed:@"certify"];
            
        }else{
            //init未认证（未填写认证信息），submit待认证(提交认证信息待审核)，fail - 认证失败
            self.leftImage.image = [UIImage imageNamed:@"uncertify"];
        }
    }
    
    //判断有无标语
    if (![model.recommendations isEqualToString:@""]) {
        //有标语
        self.sloganLabel.hidden = NO;
        self.sloganLabel.text = [NSString stringWithFormat:@"%@",model.recommendations];
        
    }else{
        //无标语
        self.sloganLabel.hidden = YES;
    }
}

#pragma mark - 搜索列表
- (void)setSearchListModelWithDictionary:(InsuranceSearchModel *)model{
    //产品名称
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    //保险公司
    self.companyLabel.text = [NSString stringWithFormat:@"%@",model.companyName];
    //最低保费
    if ([model.minimumPremium isEqualToString:@""]) {
        self.insuranceFeeLabel.text = @"--元起";
    } else {
        self.insuranceFeeLabel.text = [NSString stringWithFormat:@"%@元起",model.minimumPremium];
    }
    
    //标语
    self.sloganLabel.text = [NSString stringWithFormat:@"%@",model.recommendations];
    
    //判断登录和认证状态
    //计算text的layout
    if ([StoreTool getLoginStates]) {//登录
        if ([model.checkStatus isEqualToString:@"success"]) {//success认证成功
            self.leftImage.hidden = YES;
            //推广费
            self.popularFeeLabel.text = [NSString stringWithFormat:@"%@%%",model.promotionMoney];
            self.popularFeeLabel.textColor = [UIColor customLightYellowColor];
            self.popularFeeLabel.font = [UIFont systemFontOfSize:16];
            [self.popularFeeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-15);
                make.width.mas_equalTo(@((Width_Window-40)/3));
            }];
        }else{//init未认证（未填写认证信息），submit待认证(提交认证信息待审核)，fail - 认证失败
            self.leftImage.hidden = NO;
            self.leftImage.image = [UIImage imageNamed:@"uncertify"];
            
            self.popularFeeLabel.text = @"认证可见";
            self.popularFeeLabel.textColor = [UIColor customDetailColor];
            self.popularFeeLabel.font = [UIFont systemFontOfSize:16];
            [self.popularFeeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-Width_Window/6+(75+14)/2);
                make.width.mas_equalTo(@(75));
            }];
        }
    }else{
        //未登录
        self.popularFeeLabel.text = @"认证可见";
        self.popularFeeLabel.textColor = [UIColor customDetailColor];
        self.popularFeeLabel.font = [UIFont systemFontOfSize:16];
        [self.popularFeeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-Width_Window/6+(75+14)/2);
            make.width.mas_equalTo(@(75));
        }];
        
        self.leftImage.hidden = NO;
        
        if ([model.checkStatus isEqualToString:@"success"]) {
            //success认证成功
            self.leftImage.image = [UIImage imageNamed:@"certify"];
            
        }else{
            //init未认证（未填写认证信息），submit待认证(提交认证信息待审核)，fail - 认证失败
            self.leftImage.image = [UIImage imageNamed:@"uncertify"];
        }
    }
    
    //判断有无标语
    if (![model.recommendations isEqualToString:@""]) {
        //有标语
        self.sloganLabel.hidden = NO;
        self.sloganLabel.text = [NSString stringWithFormat:@"%@",model.recommendations];
        
    }else{
        //无标语
        self.sloganLabel.hidden = YES;
    }
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
