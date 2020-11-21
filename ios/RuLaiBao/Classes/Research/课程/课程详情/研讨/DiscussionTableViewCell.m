//
//  DiscussionTableViewCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/8.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "DiscussionTableViewCell.h"
#import "Configure.h"
#import "TYAttributedLabel.h"

#define kGAP 10

@interface DiscussionTableViewCell ()

@property (nonatomic, weak) TYAttributedLabel *label;

@end

@implementation DiscussionTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *image = [UIImage imageNamed:@"discussionLike"];
        image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
        self.backgroundView = [[UIImageView alloc]initWithImage:image];
        
        TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label];
        _label = label;
    }
    return self;
}

-(void)setContainer:(TYTextContainer *)container{
    self.label.textContainer = container;
    [self.label setFrameWithOrign:CGPointMake(5, 10) Width:CGRectGetWidth(self.frame)];
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
