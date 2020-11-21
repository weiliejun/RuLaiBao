//
//  MyCustomCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyCustomCell.h"
#import "Configure.h"

@interface MyCustomCell ()
/** 左侧图像 */
@property (nonatomic, weak) UIImageView *leftImageView;
/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
///** 数字 */
//@property (nonatomic, weak) UILabel *rightLabel;

@end

@implementation MyCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createCell];
    }
    return self;
}

#pragma mark - 设置续约提醒数目
//- (void)setTotalNumStr:(NSString *)totalNumStr {
//    _totalNumStr = totalNumStr;
//    self.rightLabel.hidden = NO;
//    self.rightLabel.text = totalNumStr;
//}

#pragma mark - 设置数据
- (void)setInfoDict:(NSDictionary *)infoDict {
    _infoDict = infoDict;
    self.leftImageView.image = [UIImage imageNamed:infoDict[@"imageName"]];
    self.titleLabel.text = infoDict[@"title"];
}

#pragma mark - 创建Cell
- (void)createCell {
    // 左侧图像
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.image = [UIImage imageNamed:@"houseImage"];
    [self.contentView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo(@(20));
        make.height.mas_equalTo(@20);
    }];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor customTitleColor];
    titleLabel.text = @"我的预约";
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.mas_equalTo(@(180));
        make.height.mas_equalTo(@30);
    }];
    
    // 右侧数字
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.font = [UIFont systemFontOfSize:15];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.text = @"";
    rightLabel.adjustsFontSizeToFitWidth = YES;
    rightLabel.backgroundColor = [UIColor redColor];
    rightLabel.layer.masksToBounds = YES;
    rightLabel.layer.cornerRadius = 10;
    rightLabel.hidden = YES;
    [self.contentView addSubview:rightLabel];
    self.rightLabel = rightLabel;
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Width_Window - 48);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo(@(20));
        make.height.mas_equalTo(@20);
    }];
    
    // 右侧箭头
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    arrowImageView.image = [UIImage imageNamed:@"arrow_r"];
    [self.contentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Width_Window - 18);
        make.top.equalTo(self.contentView.mas_top).offset(18);
        make.width.mas_equalTo(@(8));
        make.height.mas_equalTo(@14);
    }];
    
    //横线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(49);
        make.width.mas_equalTo(@(Width_Window-30));
        make.height.mas_equalTo(@1);
    }];
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
