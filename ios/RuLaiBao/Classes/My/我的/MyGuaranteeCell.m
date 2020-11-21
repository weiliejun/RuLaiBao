//
//  MyGuaranteeCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyGuaranteeCell.h"
#import "Configure.h"


@interface MyGuaranteeCell ()

@end

@implementation MyGuaranteeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

#pragma mark - 创建Cell
- (void)createCell{
    UIControl *titleCtl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 50)];
    [titleCtl addTarget:self action:@selector(ctlClick:) forControlEvents:UIControlEventTouchUpInside];
    titleCtl.tag = 1100;
    [self.contentView addSubview:titleCtl];

    // 左侧图像
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    leftImageView.image = [UIImage imageNamed:@"guarantee"];
    [titleCtl addSubview:leftImageView];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImageView.right + 15, 10, 200, 30)];
    titleLabel.textColor = [UIColor customTitleColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"我的保单";
    [titleCtl addSubview:titleLabel];
    
    // 右侧箭头
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Width_Window - 18, 18, 8, 14)];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    arrowImageView.image = [UIImage imageNamed:@"arrow_r"];
    [titleCtl addSubview:arrowImageView];
    
    // 线
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, Width_Window - 30, 1)];
    line1.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:line1];
    
    // 添加四个按钮
    NSArray *titleArr = @[@"待审核",@"已承保",@"问题件",@"回执签收"];
    NSArray *imageArr = @[@"uncheck",@"undertake",@"problem",@"receipt"];
    CGFloat ctlWidth = Width_Window/4;
    CGFloat ctlHeight = Width_Window/4-15;
    CGFloat imageWidth = Width_Window/16;
    CGFloat spaceW = (ctlWidth-imageWidth)/2;

    for (int i = 0; i < 4; i++) {
        UIControl *ctl = [[UIControl alloc]initWithFrame:CGRectMake((i%4)*ctlWidth, line1.bottom+5, ctlWidth, ctlHeight)];
        ctl.backgroundColor = [UIColor clearColor];
        ctl.tag = i+1000;
        [ctl addTarget:self action:@selector(ctlClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:ctl];
        
        UIImageView *ctlImage = [[UIImageView alloc]initWithFrame:CGRectMake(spaceW, 10, imageWidth, imageWidth)];
        ctlImage.image = [UIImage imageNamed:imageArr[i]];
        [ctl addSubview:ctlImage];
        
        UILabel *ctlLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, ctlImage.bottom+5, ctlWidth-20, 20)];
        ctlLabel.text = titleArr[i];
        ctlLabel.textColor = [UIColor customTitleColor];
        ctlLabel.textAlignment = NSTextAlignmentCenter;
        ctlLabel.font = [UIFont systemFontOfSize:14];
        [ctl addSubview:ctlLabel];
    }
    
    //横线
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 124, Width_Window-30, 1)];
    line2.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:line2];
}

#pragma mark - 按钮点击方法
- (void)ctlClick:(UIButton *)button {
    NSInteger tag = button.tag - 1000;
    if (self.completeButtonClick) {
        self.completeButtonClick(tag);
    }
}

- (NSAttributedString *)yh_imageTextWithImage:(UIImage *)image imageWH:(CGFloat)imageWH title:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor spacing:(CGFloat)spacing {
    
    NSDictionary *titleDict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName: titleColor};
    NSDictionary *spacingDict = @{NSFontAttributeName: [UIFont systemFontOfSize:spacing]};
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, 0, imageWH, imageWH);
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSAttributedString *lineText = [[NSAttributedString alloc] initWithString:@"\n\n" attributes:spacingDict];
    
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:title attributes:titleDict];
    
    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
    [attM appendAttributedString:lineText];
    [attM appendAttributedString:text];
    
    return attM.copy;
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
