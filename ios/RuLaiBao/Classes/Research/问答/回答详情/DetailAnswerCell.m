//
//  DetailAnswerCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "DetailAnswerCell.h"
#import "Configure.h"
#import "TYAttributedLabel.h"

#define kGAP 10

@interface DetailAnswerCell ()

@property (nonatomic, weak) TYAttributedLabel *label;

@end

@implementation DetailAnswerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor customLineColor];
        [self createCellUI];
    }
    return self;
}
-(void)setContainer:(TYTextContainer *)container{
    _container = container;
    self.label.textContainer = container;
    [self.label setFrameWithOrign:CGPointMake(5, 5) Width:CGRectGetWidth(self.frame)];
}
#pragma mark - UI
-(void)createCellUI{
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    //与headerview的进行区分
    label.tag = 10087;
    [self.contentView addSubview:label];
    _label = label;
}

#pragma mark cell左边缩进10，右边缩进10
-(void)setFrame:(CGRect)frame{
    CGFloat leftSpace = kGAP;
    frame.origin.x = leftSpace;
    frame.size.width = Width_Window - leftSpace - kGAP;

    [super setFrame:frame];
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
