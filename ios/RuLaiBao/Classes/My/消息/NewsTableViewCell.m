//
//  NewsTableViewCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "Configure.h"

@interface NewsTableViewCell ()
/** title */
@property (nonatomic, strong) UILabel *titleLabel;
/** 简介 */
@property (nonatomic, strong) UILabel *detailLabel;

@end
@implementation NewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self customUI];
    }
    return self;
}

- (void)customUI{
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    self.titleLabel.textColor = [UIColor customTitleColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width_Window-50, 15, 20, 20)];
    self.detailLabel.textColor = [UIColor whiteColor];
    self.detailLabel.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:0 / 255.0 blue:1 / 255.0 alpha:1.0];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.adjustsFontSizeToFitWidth = YES;
    self.detailLabel.layer.cornerRadius = 10;
    self.detailLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.detailLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 49, Width_Window-20, 1)];
    lineView.backgroundColor = [UIColor customBackgroundColor];
    [self.contentView addSubview:lineView];
}

-(void)setNewsCellInfo:(NSString *)newsInfoStr{
    self.titleLabel.text = [NSString stringWithFormat:@"%@",newsInfoStr];
}
-(void)setNewsInfoNum:(NSString *)newsNum{
    NSString *strNum = [NSString stringWithFormat:@"%@",newsNum];
    if([strNum isEqualToString:@"0"]){
        self.detailLabel.hidden = YES;
    }else{
        self.detailLabel.hidden = NO;
        self.detailLabel.text = strNum;
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
