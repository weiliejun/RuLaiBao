//
//  HeaderView.m
//  InsuranceDetail
//
//  Created by kingstartimes on 2018/3/27.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "HeaderView.h"
#import "Configure.h"
#import "InsuranceDetailModel.h"

@interface HeaderView ()

/** 上部View */
@property (nonatomic, weak) UIImageView *topView;
/** logo图片 */
@property (nonatomic, weak) UIImageView *imageView;
/** 产品名称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 收藏按钮 */
@property (nonatomic, weak) UIButton *collectBtn;

/** 下部文字所在背景View */
@property (nonatomic, weak) UIView *bottomView;
/** 年龄 */
@property (nonatomic, weak) UILabel *ageLabel;
/** 承保职业 */
@property (nonatomic, weak) UILabel *typeLabel;
/** 保障期限 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 限购份数 */
@property (nonatomic, weak) UILabel *numberLabel;
/** 推荐语 */
@property (nonatomic, weak) UILabel *warnLabel;

@end


@implementation HeaderView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 设置界面元素
- (void)setupUI {
    /**  添加头部view */
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 50, Width_Window-10, 120)];
    topView.image = [UIImage imageNamed:@"product_bg"];
    topView.layer.masksToBounds = YES;
    topView.layer.cornerRadius = 5;
    topView.userInteractionEnabled = YES;
    [self addSubview:topView];
    self.topView = topView;
    
    // logo图片
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake((Width_Window-80)/2, 10, 80, 80)];
    bgImage.layer.masksToBounds = YES;
    bgImage.layer.cornerRadius = 40;
    bgImage.image = [UIImage imageNamed:@"product_logo"];
    [self addSubview:bgImage];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 25;
    imageView.image = [UIImage imageNamed:@"logo_normal"];
    [bgImage addSubview:imageView];
    self.imageView = imageView;
    
    //收藏按钮
    UIButton *collectBtn = [[UIButton alloc]initWithFrame:CGRectMake((Width_Window-10)/2+35, 10, 60, 20)];
    [collectBtn setImage:[UIImage imageNamed:@"product_collect"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"product_collectSe"] forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    collectBtn.selected = NO;
    [topView addSubview:collectBtn];
    self.collectBtn = collectBtn;
    
    // 产品名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, Width_Window-30 , 20)];
    nameLabel.text = @"---";
    nameLabel.textColor = [UIColor customDetailColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel = nameLabel;
    [topView addSubview:nameLabel];
    
    /** 下部view */
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom+10, Width_Window, 180)];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView = bottomView;
    [self addSubview:bottomView];
    
    //年龄
    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, Width_Window/2-20 , 30)];
    ageLabel.text = @"--";
    ageLabel.textColor = [UIColor customTitleColor];
    ageLabel.font = [UIFont systemFontOfSize:15];
    ageLabel.textAlignment = NSTextAlignmentCenter;
    self.ageLabel = ageLabel;
    [bottomView addSubview:ageLabel];
    
    UIImageView *ageImage = [[UIImageView alloc]initWithFrame:CGRectMake(Width_Window/4-23, ageLabel.bottom+2, 14, 14)];
    ageImage.image = [UIImage imageNamed:@"product_age"];
    [bottomView addSubview:ageImage];
    
    UILabel *ageLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(ageImage.right+2, ageLabel.bottom, 30 , 20)];
    ageLabel2.text = @"投保年龄";
    ageLabel2.textColor = [UIColor customDetailColor];
    ageLabel2.font = [UIFont systemFontOfSize:14];
    ageLabel2.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:ageLabel2];
    
    //中间竖线
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(Width_Window/2, 10, 1, 120)];
    line1.backgroundColor = [UIColor customLineColor];
    [bottomView addSubview:line1];
    
    //承保职业
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(Width_Window/2+10, 10, Width_Window/2-20 , 30)];
    typeLabel.text = @"--";
    typeLabel.textColor = [UIColor customTitleColor];
    typeLabel.font = [UIFont systemFontOfSize:15];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel = typeLabel;
    [bottomView addSubview:typeLabel];
    
    UIImageView *typeImage = [[UIImageView alloc]initWithFrame:CGRectMake(Width_Window*3/4-43, typeLabel.bottom+2, 14, 14)];
    typeImage.image = [UIImage imageNamed:@"product_work"];
    [bottomView addSubview:typeImage];
    
    UILabel *typeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(typeImage.right+2, typeLabel.bottom, 66 , 20)];
    typeLabel2.text = @"承保职业";
    typeLabel2.textColor = [UIColor customDetailColor];
    typeLabel2.font = [UIFont systemFontOfSize:14];
    typeLabel2.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:typeLabel2];
    
    //中间横线
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, Width_Window-40, 1)];
    line2.backgroundColor = [UIColor customLineColor];
    [bottomView addSubview:line2];
    
    //保障期限
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line2.bottom+5, Width_Window/2-20 , 30)];
    timeLabel.text = @"--";
    timeLabel.textColor = [UIColor customTitleColor];
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel = timeLabel;
    [bottomView addSubview:timeLabel];
    
    UIImageView *timeImage = [[UIImageView alloc]initWithFrame:CGRectMake(Width_Window/4-41, timeLabel.bottom+2, 14, 14)];
    timeImage.image = [UIImage imageNamed:@"product_ensure"];
    [bottomView addSubview:timeImage];
    
    UILabel *timeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(timeImage.right+2, timeLabel.bottom, 66 , 20)];
    timeLabel2.text = @"保障期限";
    timeLabel2.textColor = [UIColor customDetailColor];
    timeLabel2.font = [UIFont systemFontOfSize:14];
    timeLabel2.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:timeLabel2];
    
    //限购份数
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(Width_Window/2+10, line2.bottom+5, Width_Window/2-20 , 30)];
    numberLabel.text = @"--";
    numberLabel.textColor = [UIColor customTitleColor];
    numberLabel.font = [UIFont systemFontOfSize:15];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel = numberLabel;
    [bottomView addSubview:numberLabel];
    
    UIImageView *numberImage = [[UIImageView alloc]initWithFrame:CGRectMake(Width_Window*3/4-43, numberLabel.bottom+2, 14, 14)];
    numberImage.image = [UIImage imageNamed:@"product_limit"];
    [bottomView addSubview:numberImage];
    
    UILabel *numberLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(numberImage.right+2, numberLabel.bottom, 66 , 20)];
    numberLabel2.text = @"限购份数";
    numberLabel2.textColor = [UIColor customDetailColor];
    numberLabel2.font = [UIFont systemFontOfSize:14];
    numberLabel2.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:numberLabel2];

    //warnLabel
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, numberLabel2.bottom+15, Width_Window-20 , 20)];
    warnLabel.text = @"---";
    warnLabel.textColor = [UIColor customDetailColor];
    warnLabel.font = [UIFont systemFontOfSize:13];
    warnLabel.textAlignment = NSTextAlignmentLeft;
    warnLabel.numberOfLines = 0;
    [bottomView addSubview:warnLabel];
    self.warnLabel = warnLabel;
}

/** 收藏按钮点击事件 */
- (void)pressBtn:(UIButton *)btn{
    if (self.btnClickBlock) {
        self.btnClickBlock(nil);
    }
}

- (void)setCollectionWithInfoDict:(NSDictionary *)dict{
    if ([dict[@"dataStatus"] isEqualToString:@"valid"]) {
        //已收藏
        self.collectBtn.selected = YES;
        [self.collectBtn setImage:[UIImage imageNamed:@"product_collectSe"] forState:UIControlStateSelected];
        
    }else{//未收藏
        self.collectBtn.selected = NO;
        [self.collectBtn setImage:[UIImage imageNamed:@"product_collect"] forState:UIControlStateNormal];
    }
}

- (void)setLabelWithInfoDict:(InsuranceDetailModel *)model{
    //logo
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"listDefault"]];
    //产品名称
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];

    //按钮收藏状态（valid收藏/ invalid未收藏）
    if ([model.collectionDataStatus isEqualToString:@"valid"]) {
        //已收藏
        self.collectBtn.selected = YES;
        [self.collectBtn setImage:[UIImage imageNamed:@"product_collectSe"] forState:UIControlStateSelected];
    }else{//未收藏
        self.collectBtn.selected = NO;
        [self.collectBtn setImage:[UIImage imageNamed:@"product_collect"] forState:UIControlStateNormal];
    }
    //年龄
    self.ageLabel.text = [NSString stringWithFormat:@"%@",model.insuranceAge];
    //承保职业
    self.typeLabel.text = [NSString stringWithFormat:@"%@",model.insuranceOccupation];
    //保障期限
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.insurancePeriod];
    //限购份数
    self.numberLabel.text = [NSString stringWithFormat:@"%@",model.purchaseNumber];
    //推荐语
    NSString *recommendStr = [NSString stringWithFormat:@"%@",model.recommendations];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:recommendStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, recommendStr.length)];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, recommendStr.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(Width_Window-20, MAXFLOAT) options:options context:nil];
    CGFloat warnHeight = rect.size.height+5;
    CGFloat Height = warnHeight > 20 ? warnHeight : 20;
    self.warnLabel.frame = CGRectMake(self.warnLabel.frame.origin.x, self.warnLabel.frame.origin.y, Width_Window-20 , Height);
    self.warnLabel.attributedText = attributeString;
    
    self.bottomView.frame = CGRectMake(0, self.topView.bottom+10, Width_Window, self.warnLabel.bottom+10);
    self.frame = CGRectMake(0, 0, Width_Window, self.bottomView.bottom);
}


@end
