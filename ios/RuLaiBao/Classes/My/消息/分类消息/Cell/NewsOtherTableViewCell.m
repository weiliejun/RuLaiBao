//
//  NewsOtherTableViewCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/21.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "NewsOtherTableViewCell.h"

#import "Configure.h"
#import "NewsTypeModel.h"

@interface NewsOtherTableViewCell ()
/** title */
@property (nonatomic, weak) UILabel *titleLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *detailLabel;

@end
@implementation NewsOtherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self customUI];
    }
    return self;
}

-(void)setNewsCellModel:(NewsTypeModel *)newsCellModel{
    self.titleLabel.text = [NSString stringWithFormat:@"%@",newsCellModel.topic];
    self.detailLabel.text = [NSString stringWithFormat:@"[%@]%@",newsCellModel.createTime,newsCellModel.content];
}

- (void)customUI{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, Width_Window-20, 35)];
    titleLabel.textColor = [UIColor customNavBarColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.bottom, Width_Window-20, 24)];
    detailLabel.textColor = [UIColor customDetailColor];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:detailLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 69, Width_Window-20, 1)];
    lineView.backgroundColor = [UIColor customBackgroundColor];
    [self.contentView addSubview:lineView];
    
    _titleLabel = titleLabel;
    _detailLabel = detailLabel;
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
