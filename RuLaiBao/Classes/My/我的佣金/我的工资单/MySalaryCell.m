//
//  MySalaryCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MySalaryCell.h"
#import "Configure.h"
#import "MySalaryModel.h"


@interface MySalaryCell ()
/** 左侧竖条 */
@property(nonatomic, weak) UILabel *monthLabel;
/** 净收入金额 */
@property(nonatomic, weak) UILabel *incomeLabel;
/** 总佣金 */
@property(nonatomic, weak) UILabel *totalCommissionLabel;
/** 扣税 */
@property(nonatomic, weak) UILabel *deductTaxLabel;
/** 竖线 */
@property(nonatomic, weak) UILabel *line;
/** 暂无数据 */
@property(nonatomic, weak) UILabel *noDataLabel;

@end


@implementation MySalaryCell

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
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(Width_Window-20);
        make.height.mas_equalTo(90);
    }];
    
    //左侧竖条
    UIView *monthBGView = [[UIView alloc]init];
    monthBGView.backgroundColor = [UIColor colorWithRed:165/255.0 green:208/255.0 blue:255/255.0 alpha:1.0];
    [bgView addSubview:monthBGView];
    [monthBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(0);
        make.top.equalTo(bgView.mas_top).offset(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(90);
    }];
    
    UILabel *monthLabel = [[UILabel alloc]init];
    monthLabel.backgroundColor = [UIColor colorWithRed:165/255.0 green:208/255.0 blue:255/255.0 alpha:1.0];
    monthLabel.text = @"五\n月";
    monthLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行模式自动换行
    monthLabel.numberOfLines = 0;
    monthLabel.textColor = [UIColor whiteColor];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.font = [UIFont systemFontOfSize:16];
    [monthBGView addSubview:monthLabel];
    self.monthLabel = monthLabel;
    [monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthBGView.mas_left).offset(10);
        make.top.equalTo(monthBGView.mas_top).offset(0);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(90);
    }];
    
    //净收入
    UILabel *inLabel = [[UILabel alloc]init];
    inLabel.text = @"净收入";
    inLabel.textColor = [UIColor customTitleColor];
    inLabel.textAlignment = NSTextAlignmentCenter;
    inLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:inLabel];
    [inLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthBGView.mas_right).offset(0);
        make.top.equalTo(bgView.mas_top).offset(20);
        make.width.mas_equalTo(Width_Window/2-60);
        make.height.mas_equalTo(20);
    }];
    
    //净收入金额
    UILabel *incomeLabel = [[UILabel alloc]init];
    incomeLabel.text = @"0.00元";
    incomeLabel.textColor = [UIColor customTitleColor];
    incomeLabel.textAlignment = NSTextAlignmentCenter;
    incomeLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:incomeLabel];
    self.incomeLabel = incomeLabel;
    [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthBGView.mas_right).offset(0);
        make.top.equalTo(inLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(Width_Window/2-60);
        make.height.mas_equalTo(20);
    }];
    
    //竖线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithRed:165/255.0 green:208/255.0 blue:255/255.0 alpha:1.0];
    [bgView addSubview:line];
    self.line = line;
    line.hidden = NO;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(Width_Window/2-10);
        make.top.equalTo(bgView.mas_top).offset(20);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(50);
    }];
    
    //总佣金
    UILabel *totalCommissionLabel = [[UILabel alloc]init];
    totalCommissionLabel.text = @"总佣金:0.00元";
    totalCommissionLabel.textColor = [UIColor customTitleColor];
    totalCommissionLabel.textAlignment = NSTextAlignmentLeft;
    totalCommissionLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:totalCommissionLabel];
    self.totalCommissionLabel = totalCommissionLabel;
    [totalCommissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(20);
        make.top.equalTo(bgView.mas_top).offset(20);
        make.width.mas_equalTo(Width_Window/2-40);
        make.height.mas_equalTo(20);
    }];
    
    //扣税
    UILabel *deductTaxLabel = [[UILabel alloc]init];
    deductTaxLabel.text = @"扣    税:0.00元";
    deductTaxLabel.textColor = [UIColor customTitleColor];
    deductTaxLabel.textAlignment = NSTextAlignmentLeft;
    deductTaxLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:deductTaxLabel];
    self.deductTaxLabel = deductTaxLabel;
    [deductTaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(20);
        make.top.equalTo(totalCommissionLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(Width_Window/2-40);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - 设置数据
- (void)setMySalaryModelWithDictionary:(MySalaryModel *)model {
    //截取月份(yyyy-MM)
    NSString *string = [NSString stringWithFormat:@"%@",model.wageMonth];
    NSString *monthStr = [string substringFromIndex:5];
    NSString *str = [self ChineseWithInteger:[monthStr integerValue]];
    if ([monthStr integerValue] < 11) {
        self.monthLabel.text = [NSString stringWithFormat:@"%@\n\n月",str];
        
    }else {
        self.monthLabel.text = [NSString stringWithFormat:@"%@\n月",str];
        
    }
    
    // 净收入金额
    self.incomeLabel.text = [NSString stringWithFormat:@"%@元",model.totalIncome];
    // 总佣金
    self.totalCommissionLabel.text = [NSString stringWithFormat:@"总佣金：%@元",model.totalCommission];
    // 扣税
    self.deductTaxLabel.text = [NSString stringWithFormat:@"扣    税：%@元",model.totalTax];

}

#pragma mark - 数字转换为汉字
-(NSString *)ChineseWithInteger:(NSInteger)integer {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
    formatter.locale = locale;
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:(int)integer]];
    return string;
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
