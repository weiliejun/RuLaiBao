//
//  SelfSizingCollectCell.m
//  PYSearchExample
//
//  Created by qiu on 2018/3/19.
//  Copyright © 2018年 CoderKo1o. All rights reserved.
//

#import "SelfSizingCollectCell.h"
#import "Configure.h"

#import "Masonry.h"
#define itemHeight 40
@implementation SelfSizingCollectCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        // 用约束来初始化控件:
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.textLabel.layer.masksToBounds = YES;
        self.textLabel.layer.cornerRadius = 15;
        self.textLabel.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0].CGColor;
        self.textLabel.layer.borderWidth = 1;
        
        [self.contentView addSubview:self.textLabel];
#pragma mark — 如果使用CGRectMake来布局,是需要在preferredLayoutAttributesFittingAttributes方法中去修改textlabel的frame的
        // self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        
#pragma mark — 如果使用约束来布局,则无需在preferredLayoutAttributesFittingAttributes方法中去修改cell上的子控件l的frame
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark — 实现自适应文字宽度的关键步骤:item的layoutAttributes
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGRect rect = [self.textLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT+10, itemHeight) options:NSStringDrawingTruncatesLastVisibleLine|   NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    rect.size.width +=25;
    rect.size.height+=15;
    attributes.frame = rect;
    
//    self.contentView.layer.cornerRadius = 2.0f;
    return attributes;
}
//此方法预计会影响性能，在此处不用
//-(void)createRoundedRectWithView:(UIView *)view ViewRect:(CGRect)viewRect{
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(2, 2)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = viewRect;
//    maskLayer.path = maskPath.CGPath;
//    view.layer.mask = maskLayer;
//}
@end
