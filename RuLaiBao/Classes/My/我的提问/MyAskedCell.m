//
//  MyAskedCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/17.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyAskedCell.h"
#import "Configure.h"
#import "MyAskedModel.h"

@interface MyAskedCell ()
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *numberLabel;

@end


@implementation MyAskedCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

#pragma mark - 设置Cell
- (void)createCell{
    //问题名称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"中纪委发话谈落马：十九大后”首虎“";
    nameLabel.textColor = [UIColor customNavBarColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.height.mas_equalTo(@20);
    }];
    
    //铃铛
    UIImageView *leftImage = [[UIImageView alloc]init];
    leftImage.image = [UIImage imageNamed:@"bell"];
    [self.contentView addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@20);
    }];
    
    //问题数量
    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.text = @"255";
    numberLabel.textColor = [UIColor customDetailColor];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImage.mas_right).offset(10);
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@(Width_Window-leftImage.right-20));
        make.height.mas_equalTo(@20);
    }];
    
    //箭头
    UIImageView *rightArrow = [[UIImageView alloc]init];
    rightArrow.image = [UIImage imageNamed:@"arrow_r"];
    [self.contentView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_right).offset(-18);
        make.top.equalTo(self.contentView.mas_top).offset(31);
        make.width.mas_equalTo(@8);
        make.height.mas_equalTo(@14);
    }];
    
    //横线1
    UILabel *horizontal = [[UILabel alloc]init];
    horizontal.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:horizontal];
    [horizontal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(numberLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@(Width_Window-20));
        make.height.mas_equalTo(@1);
    }];
}

- (void)setMyAskedListModelWithDictionary:(MyAskedModel *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.title];
    self.numberLabel.text = [NSString stringWithFormat:@"%@",model.answerCount];
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
