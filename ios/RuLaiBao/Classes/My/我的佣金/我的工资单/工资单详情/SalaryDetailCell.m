//
//  SalaryDetailCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/14.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "SalaryDetailCell.h"
#import "Configure.h"


@interface SalaryDetailCell ()
/** 左侧竖线 */
@property (nonatomic,weak) UILabel *colorLine;
/** 左侧标题 */
@property (nonatomic,weak) UILabel *titleLabel;


@end

@implementation SalaryDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

#pragma mark - 创建cell
- (void)createCell {
    //左侧
    UILabel *colorLine = [[UILabel alloc]init];
    colorLine.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:colorLine];
    self.colorLine = colorLine;
    [colorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"佣金收入";
    titleLabel.textColor = [UIColor customTitleColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo(Width_Window/2-30);
        make.height.mas_equalTo(20);
    }];
    
    //右侧内容
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.text = @"0.00元";
    detailLabel.textColor = [UIColor customTitleColor];
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:detailLabel];
    self.detailLabel = detailLabel;
    self.detailLabel.hidden = NO;
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo(Width_Window/2-20);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - 设置标题
- (void)setTitle:(NSString *)titleStr {
    self.titleLabel.text = titleStr;
}

#pragma mark - 设置颜色
- (void)setLineColor:(NSString *)colorStr {
    if ([colorStr isEqualToString:@"green"]) {
        self.colorLine.backgroundColor = [UIColor greenColor];
        
    } else if ([colorStr isEqualToString:@"blue"]) {
        self.colorLine.backgroundColor = [UIColor blueColor];
        
    }  else if ([colorStr isEqualToString:@"red"]) {
        self.colorLine.backgroundColor = [UIColor redColor];
        
    } else {
        self.colorLine.backgroundColor = [UIColor whiteColor];
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
