//
//  ProspectusCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/2.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "ProspectusCell.h"
#import "Configure.h"
//计划书列表
#import "ProspectusModel.h"
//搜索列表
#import "SearchListModel.h"

@interface ProspectusCell ()
@property (nonatomic, strong)UIImageView *leftImage;//左侧图片
@property (nonatomic, strong) UILabel *nameLabel;//产品名称
@property (nonatomic, strong) UILabel *sloganLabel;//标语

@end

@implementation ProspectusCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        [self creataCell];
    }
    return self;
}

#pragma mark - 创建cell
- (void)creataCell{
    //左侧图片
    UIImageView *leftImage = [[UIImageView alloc]init];
    leftImage.image = [UIImage imageNamed:@"listDefault"];
    leftImage.contentMode = UIViewContentModeScaleAspectFill;
    leftImage.clipsToBounds = YES;
    leftImage.backgroundColor = [UIColor customBackgroundColor];
    [self.contentView addSubview:leftImage];
    self.leftImage = leftImage;
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@60);
    }];
    
    //产品名称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"盛世年年年金保险C款";
    nameLabel.textColor = [UIColor customTitleColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImage.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@30);
    }];
    
    //标语
    UILabel *sloganLabel = [[UILabel alloc]init];
    sloganLabel.text = @"千金一诺得利一生，财富相伴幸福永恒";
    sloganLabel.textColor = [UIColor customDetailColor];
    sloganLabel.textAlignment = NSTextAlignmentLeft;
    sloganLabel.font = [UIFont systemFontOfSize:14];
    self.sloganLabel = sloganLabel;
    [self.contentView addSubview:sloganLabel];
    [sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImage.mas_right).offset(10);
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@20);
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.top.equalTo(sloganLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(@(Width_Window));
        make.height.mas_equalTo(@1);
    }];
}

#pragma mark - 计划书
- (void)setProspectusModelWithDictionary:(ProspectusModel *)model{
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"listDefault"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.sloganLabel.text = [NSString stringWithFormat:@"%@",model.recommendations];
}

#pragma mark - 搜索列表
- (void)setSearchListModelWithDictionary:(SearchListModel *)model{
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"listDefault"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.sloganLabel.text = [NSString stringWithFormat:@"%@",model.recommendations];
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
