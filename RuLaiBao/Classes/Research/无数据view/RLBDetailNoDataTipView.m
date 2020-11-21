//
//  RLBDetailNoDataTipView.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/21.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "RLBDetailNoDataTipView.h"

@interface RLBDetailNoDataTipView ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIImageView *tipImageView;
@property (nonatomic, weak) UILabel *tipLabel;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;
@end

@implementation RLBDetailNoDataTipView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(NSString *)imageName
                      tipText:(NSString *)tipText {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUIWithFrame:frame tipText:tipText imageName:imageName];
        
        self.tipType = NoDataTipTypeNoData;
        
        // 添加手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewGestureClick)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}
-(void)tapViewGestureClick{
    if (self.tipType == NoDataTipTypeRequestLoading) {
        return;
    }else if (self.tipType == NoDataTipTypeRequestError){
        _tipLabel.text = @"数据请求中，请稍后...";
        self.tipImageView.hidden = YES;
        self.activityView.hidden = NO;
    }
    if (self.tapClick != nil) {
        self.tapClick(self.tipType);
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)setTipType:(NoDataTipType)tipType{
    _tipType = tipType;
    if (tipType == NoDataTipTypeRequestLoading) {
        _tipLabel.text = @"数据请求中，请稍后...";
        self.tipImageView.hidden = YES;
        self.activityView.hidden = NO;
    }else if (tipType == NoDataTipTypeRequestError){
        _tipLabel.text = @"加载失败，点击重新请求";
        self.tipImageView.hidden = NO;
        self.activityView.hidden = YES;
    }else{
        self.tipImageView.hidden = NO;
        self.activityView.hidden = YES;
    }
}
#pragma mark - 设置界面元素
- (void)setupUIWithFrame:(CGRect)frame tipText:(NSString *)tipText imageName:(NSString *)imageName {
    
    UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-60, self.frame.size.height/2 - 140, 120, 120)];
    tipImageView.image = [UIImage imageNamed:@"NoData"];
    [self addSubview:tipImageView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.frame.size.height/2-10, self.frame.size.width-20, 40)];
    tipLabel.text = tipText;
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:16.0];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLabel];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-30);
    [activityView startAnimating];
    activityView.hidden = YES;
    [self addSubview:activityView];
    
    _tipImageView = tipImageView;
    _tipLabel = tipLabel;
    _activityView = activityView;
}

-(void)changeImageViewWithImageName:(NSString *)imageName TipLabel:(NSString *)tipLabelStr{
    _tipImageView.image = [UIImage imageNamed:imageName];
    _tipLabel.text = tipLabelStr;
}
-(void)changeTipLabel:(NSString *)tipLabelStr{
    _tipLabel.text = tipLabelStr;
}
@end
