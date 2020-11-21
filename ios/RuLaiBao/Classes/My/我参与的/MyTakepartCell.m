//
//  MyTakepartCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyTakepartCell.h"
#import "Configure.h"
#import "MyAskedModel.h"
#import "MyTalkModel.h"


@interface MyTakepartCell ()
@property (nonatomic, weak) UILabel *nameLabel;//问题名称

@end

@implementation MyTakepartCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

#pragma mark - 创建Cell
- (void)createCell{
    //问题名称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"中纪委发文谈鲁炜落马:十九大后”首虎“？";
    nameLabel.textColor = [UIColor customTitleColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo(@(Width_Window-35));
        make.height.mas_equalTo(@20);
    }];
    
    //箭头
    UIImageView *rightArrow = [[UIImageView alloc]init];
    rightArrow.image = [UIImage imageNamed:@"arrow_r"];
    [self.contentView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_right).offset(-18);
        make.top.equalTo(self.contentView.mas_top).offset(18);
        make.width.mas_equalTo(@8);
        make.height.mas_equalTo(@14);
    }];
    
    //横线
    UILabel *horizontal = [[UILabel alloc]init];
    horizontal.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:horizontal];
    [horizontal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.top.equalTo(self.contentView.mas_top).offset(50);
        make.width.mas_equalTo(@(Width_Window));
        make.height.mas_equalTo(@1);
    }];
    
}

- (void)setAskedListModelWithDictionary:(MyAskedModel *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.title];
    
}

- (void)setTalkListModelWithDictionary:(MyTalkModel *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.topicContent];
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
