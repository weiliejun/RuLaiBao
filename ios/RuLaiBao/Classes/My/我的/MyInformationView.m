//
//  MyInformationView.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyInformationView.h"
#import "Configure.h"
#import "ChangeNumber.h"

#import "MyListModel.h"

@interface MyInformationView ()<UIGestureRecognizerDelegate>
/** 背景View */
@property (nonatomic, weak) UIView *bgView;
/** 头像 */
@property (nonatomic, weak) UIImageView *personImage;
/** 姓名 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 电话 */
@property (nonatomic, weak) UILabel *phoneLabel;
/** 认证状态 */
@property (nonatomic, weak) UIImageView *statusImage;
/** 佣金 */
@property (nonatomic, weak) UIControl *commissionCtl;
@property (nonatomic, weak) UILabel *commissionLabel;
@property (nonatomic, weak) UIButton *eyeBtn;
@property (nonatomic, weak) MyListModel *model;

@end

@implementation MyInformationView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setLabelWithInfoDict:(MyListModel *)model{
    self.model = model;
    if (model != nil) {
        //登录
        self.bgView.frame = CGRectMake(0, 0, Width_Window, 320+Height_Statusbar_NavBar);
        self.frame =CGRectMake(0, 0, Width_Window, 320+Height_Statusbar_NavBar);
        //头像
        [self.personImage sd_setImageWithURL:[NSURL URLWithString:model.headPhoto] placeholderImage:[UIImage imageNamed:@"my_header"]];
        
        //姓名
        //计算text的layout
        NSString *string = [NSString stringWithFormat:@"%@",model.realName];
        CGFloat textWidth = [NSString sizeWithFont:[UIFont systemFontOfSize:17] Size:CGSizeMake(MAXFLOAT, 20) Str:string].width;
        self.nameLabel.frame = CGRectMake((Width_Window-textWidth-20)/2, self.personImage.bottom+10, textWidth, 20);
        self.nameLabel.text = string;
        self.nameLabel.textColor = [UIColor darkGrayColor];
        self.phoneLabel.hidden = NO;
        self.statusImage.hidden = NO;
        self.commissionCtl.hidden = NO;
        //电话
        self.phoneLabel.text = [NSString changePhoneNum:model.mobile];
        
        //佣金
        if (![StoreTool getEyeStatus]) {
            self.commissionLabel.text = @"*****";
            self.commissionLabel.frame = CGRectMake((Width_Window-95)/2, 20, 70, 50);
        }else {
            //加分位符
            NSString *commissionStr = [NSString stringWithFormat:@"%@",model.totalCommission];
            NSString *changeNum = [[ChangeNumber alloc]changeNumber:commissionStr];
            //计算text的layout
            CGFloat commissionWidth = [NSString sizeWithFont:[UIFont systemFontOfSize:30] Size:CGSizeMake(MAXFLOAT, 50) Str:changeNum].width;
            self.commissionLabel.frame = CGRectMake((Width_Window-commissionWidth-25)/2, 20, commissionWidth, 50);
            self.commissionLabel.text = changeNum;
        }
        self.eyeBtn.frame = CGRectMake(self.commissionLabel.right+5, 35, 20, 20);
        
        //认证状态
        self.statusImage.frame = CGRectMake(self.nameLabel.right, self.personImage.bottom+13, 14, 14);
        if ([model.checkStatus isEqualToString:@"success"]) {
            //success - 认证成功
            self.statusImage.image = [UIImage imageNamed:@"certify"];
        }else{
            //init未认证（未填写认证信息） submit待认证(提交认证信息待审核)  fail - 认证失败未认证
            self.statusImage.image = [UIImage imageNamed:@"uncertify"];
        }
    }else{
        //未登录
        self.bgView.frame = CGRectMake(0, 0, Width_Window, 210+Height_Statusbar_NavBar);
        self.frame =CGRectMake(0, 0, Width_Window, 210+Height_Statusbar_NavBar);
        self.personImage.image = [UIImage imageNamed:@"my_header"];
        self.nameLabel.frame = CGRectMake(10, self.personImage.bottom+10, Width_Window-40, 20);
        self.nameLabel.text = @"登录";
        self.nameLabel.textColor = [UIColor customDeepYellowColor];
        self.phoneLabel.hidden = YES;
        self.statusImage.hidden = YES;
        self.commissionCtl.hidden = YES;
    }
}

#pragma mark - 设置界面元素
- (void)setupUI {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 210+Height_Statusbar_NavBar)];
    bgView.backgroundColor = [UIColor customBackgroundColor];
    [self addSubview:bgView];
    self.bgView = bgView;
    //画圆弧
    [self drawRectTopView];

    //个人信息
    UIImageView *infomationView = [[UIImageView alloc]initWithFrame:CGRectMake(10, Height_Statusbar_NavBar, Width_Window-20, 200)];
    infomationView.image = [UIImage imageNamed:@"product_bg"];
    infomationView.layer.masksToBounds = YES;
    infomationView.layer.cornerRadius = 5;
    infomationView.userInteractionEnabled = YES;
    [bgView addSubview:infomationView];
    
    UIImageView *personImage = [[UIImageView alloc]initWithFrame:CGRectMake((Width_Window-80)/2, 10, 60, 60)];
    personImage.layer.masksToBounds = YES;
    personImage.layer.cornerRadius = 30;
    personImage.image = [UIImage imageNamed:@"my_header"];
    [infomationView addSubview:personImage];
    self.personImage = personImage;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, personImage.bottom+10, Width_Window-40, 20)];
    nameLabel.text = @"登录";
    nameLabel.textColor = [UIColor customDeepYellowColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [infomationView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UIImageView *statusImage = [[UIImageView alloc]initWithFrame:CGRectMake(nameLabel.right, personImage.bottom+13, 14, 14)];
    statusImage.image = [UIImage imageNamed:@"uncertify"];
    [infomationView addSubview:statusImage];
    self.statusImage = statusImage;
    self.statusImage.hidden = YES;
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, nameLabel.bottom+10, Width_Window-40, 20)];
    phoneLabel.text = @"---";
    phoneLabel.textColor = [UIColor customDetailColor];
    phoneLabel.font = [UIFont systemFontOfSize:14];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [infomationView addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    self.phoneLabel.hidden = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressBgControl)];
    gesture.delegate = self;
    gesture.numberOfTapsRequired = 1;
    [infomationView addGestureRecognizer:gesture];
    
    //佣金
    UIControl *commissionCtl = [[UIControl alloc]initWithFrame:CGRectMake(0, infomationView.bottom+10, Width_Window, 110)];
    commissionCtl.backgroundColor = [UIColor whiteColor];
    [commissionCtl addTarget:self action:@selector(pressCommissionCtl) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:commissionCtl];
    self.commissionCtl = commissionCtl;
    self.commissionCtl.hidden = YES;
    
    UILabel *commissionLabel = [[UILabel alloc]initWithFrame:CGRectMake((Width_Window-95)/2, 20, 70, 50)];
    commissionLabel.text = @"0.00";
    commissionLabel.textColor = [UIColor customDeepYellowColor];
    commissionLabel.textAlignment = NSTextAlignmentCenter;
    commissionLabel.font = [UIFont systemFontOfSize:30];
    [commissionCtl addSubview:commissionLabel];
    self.commissionLabel = commissionLabel;
    
    UILabel *commissionLabel2 = [[UILabel alloc]initWithFrame:CGRectMake((Width_Window-100)/2, commissionLabel.bottom, 100, 20)];
    commissionLabel2.text = @"累计佣金（元）";
    commissionLabel2.textColor = [UIColor darkGrayColor];
    commissionLabel2.font = [UIFont systemFontOfSize:14];
    commissionLabel2.textAlignment = NSTextAlignmentCenter;
    [commissionCtl addSubview:commissionLabel2];
    
    UIButton *eyeBtn = [[UIButton alloc]initWithFrame:CGRectMake(commissionLabel.right+5, 35, 20, 20)];
    [eyeBtn setImage:[UIImage imageNamed:@"eyes_open"] forState:UIControlStateSelected];
    [eyeBtn setImage:[UIImage imageNamed:@"eyes_close"] forState:UIControlStateNormal];
    [eyeBtn addTarget:self action:@selector(eyeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    eyeBtn.selected = [StoreTool getEyeStatus];
    
    if (![StoreTool getEyeStatus]) {
        commissionLabel.text = @"*****";

    }
    [commissionCtl addSubview:eyeBtn];
    self.eyeBtn = eyeBtn;
    
    UIImageView *goImage = [[UIImageView alloc]initWithFrame:CGRectMake(Width_Window-18, commissionLabel.bottom-20, 8, 14)];
    goImage.image = [UIImage imageNamed:@"arrow_r"];
    [commissionCtl addSubview:goImage];
}

#pragma mark - 黄色圆弧
- (void)drawRectTopView{
    //创建遮罩层
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    /** 左下点 */
    [path moveToPoint:CGPointMake(0, 80+Height_Statusbar_NavBar)];
    /** 左上点 */
    [path addLineToPoint:CGPointMake(0, 0)];
    /** 右上点 */
    [path addLineToPoint:CGPointMake(Width_Window, 0)];
    /** 右下点 */
    [path addLineToPoint:CGPointMake(Width_Window, 80+Height_Statusbar_NavBar)];
    /** 圆弧 */
    [path addQuadCurveToPoint:CGPointMake(0, 80+Height_Statusbar_NavBar) controlPoint:CGPointMake(Width_Window/2, Height_Statusbar_NavBar+80+60)];
    layer.path = path.CGPath;
    
    //创建渐变层
    CAShapeLayer *layer1 = [CAShapeLayer layer];
    CAGradientLayer *gradientLayer1 = [self CreateLayerWithColors:@[[UIColor customLightYellowColor],[UIColor customDeepYellowColor]]];
    [layer1 addSublayer:gradientLayer1];
    
    [layer1 setMask:layer];
    [self.bgView.layer addSublayer:layer1];
}

- (CAGradientLayer *)CreateLayerWithColors:(NSArray*)colors{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc]init];
    gradientLayer.frame = CGRectMake(0, 0, Width_Window, Height_Statusbar_NavBar+80+60);
    
    NSMutableArray *marray = [NSMutableArray array];
    for (UIColor *color in colors) {
        [marray addObject:(__bridge id)color.CGColor];
    }
    gradientLayer.colors = marray;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    return gradientLayer;
}

#pragma mark - 背景点击事件
-(void)pressBgControl{
    if (self.btnClickBlock) {
        self.btnClickBlock(nil);
    }
}

#pragma mark - 佣金
- (void)pressCommissionCtl{
    if (self.commisionClickBlock) {
        self.commisionClickBlock(nil);
    }
}

#pragma mark - 眼睛点击事件
- (void)eyeBtnClick:(UIButton *)btn{
    if ([StoreTool getEyeStatus]) {
        [StoreTool storeEyeStatus:NO];
        btn.selected = [StoreTool getEyeStatus];
        self.commissionLabel.frame = CGRectMake((Width_Window-95)/2, 20, 70, 50);
        self.commissionLabel.text = @"*****";
        
    }else{
        [StoreTool storeEyeStatus:YES];
        btn.selected = [StoreTool getEyeStatus];
        
        //加分位符
        NSString *commissionStr = [NSString stringWithFormat:@"%@",self.model.totalCommission];
        NSString *changeNum = [[ChangeNumber alloc]changeNumber:commissionStr];
    
        //计算text的layout
        CGFloat commissionWidth = [NSString sizeWithFont:[UIFont systemFontOfSize:30] Size:CGSizeMake(MAXFLOAT, 50) Str:changeNum].width;
        
        self.commissionLabel.frame = CGRectMake((Width_Window-25-commissionWidth)/2, 20, commissionWidth, 50);
        self.commissionLabel.text = changeNum;
    }
    self.eyeBtn.frame = CGRectMake(self.commissionLabel.right+5, 35, 20, 20);
}


@end
