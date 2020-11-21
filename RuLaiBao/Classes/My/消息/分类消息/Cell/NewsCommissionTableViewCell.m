//
//  NewsCommissionTableViewCell.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "NewsCommissionTableViewCell.h"
#import "Configure.h"

#import "NewsTypeModel.h"
@interface NewsCommissionTableViewCell ()
/** title */
@property (nonatomic, weak) UILabel *titleLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 💰 */
@property (nonatomic, weak) UILabel *numLabel;

@end
@implementation NewsCommissionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self customUI];
    }
    return self;
}

-(void)setNewsCellModel:(NewsTypeModel *)newsCellModel{
    _newsCellModel = newsCellModel;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",newsCellModel.topic];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",newsCellModel.createTime];
    self.numLabel.text = [NSString stringWithFormat:@"%@",newsCellModel.content];
}

- (void)customUI{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 170, 30)];
    titleLabel.textColor = [UIColor customNavBarColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.bottom, 170, 24)];
    timeLabel.textColor = [UIColor customDetailColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:timeLabel];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right+10, 20,Width_Window-titleLabel.right-40, 30)];
    numLabel.textColor = [UIColor customNavBarColor];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:numLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 69, Width_Window-20, 1)];
    lineView.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:lineView];
    
    _titleLabel = titleLabel;
    _timeLabel = timeLabel;
    _numLabel = numLabel;
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
