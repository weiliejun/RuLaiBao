//
//  CustomButton.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/17.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "CustomButton.h"
//static NSTimeInterval startDuration = 0.3;
static NSTimeInterval endDuration = 1.0;
#define XcenterOfCircle self.frame.size.width/2 - 40

@interface CustomButton ()<CAAnimationDelegate>
@property (nonatomic, weak) CAShapeLayer *waitingShapeLayer;
@property (nonatomic, weak) UIActivityIndicatorView* activityView;
@property (nonatomic, copy) NSString *defaultTitleStr;


@end
@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}
#pragma mark - 配置
-(void)initConfig{
    _disableWhenLoad = YES;
    _defaultTitleStr = self.titleLabel.text;
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:self.frame.size.height / 2];
}
-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    _defaultTitleStr = title;
}

-(void)startAnimation:(NSString *)loadingStr{
    if (self.disableWhenLoad){
        self.userInteractionEnabled = NO;
    }
    self.titleLabel.alpha = 0.9f;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    [self setTitle:loadingStr forState:UIControlStateNormal];
    [self.activityView startAnimating];
}

-(void)stopAnimationWithSuccess:(NSString *)stopStr{
    
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    self.activityView = nil;
    [self setTitle:stopStr forState:UIControlStateNormal];
    //画圈
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(XcenterOfCircle, 22) radius:10 startAngle:M_PI *3 / 2 endAngle:M_PI * 7 /2 clockwise:YES];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    //画对勾
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(XcenterOfCircle - 6, 22)];
    [linePath addLineToPoint:CGPointMake(XcenterOfCircle, 26)];
    [linePath addLineToPoint:CGPointMake(XcenterOfCircle+6, 17)];
    
    //拼接两个path
    [path appendPath:linePath];
    self.waitingShapeLayer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if (self.waitingShapeLayer.strokeEnd == 1.0) {
        [animation setFromValue:@1.0];
        [animation setToValue:@0.0];
    }else{
        [animation setFromValue:@0.0];
        [animation setToValue:@1.0];
    }
    animation.duration = 1.2f;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [self.waitingShapeLayer addAnimation:animation forKey:@"paySuccess"];
}
-(void)stopAnimationWithFail:(NSString *)stopStr{
    
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    self.activityView = nil;
    [self setTitle:stopStr forState:UIControlStateNormal];
    //画圈
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(XcenterOfCircle, 22) radius:10 startAngle:M_PI *3 / 2 endAngle:M_PI * 7 /2 clockwise:YES];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    //画对勾
    UIBezierPath *linePath1 = [UIBezierPath bezierPath];
    [linePath1 moveToPoint:CGPointMake(XcenterOfCircle - 5, 17)];
    [linePath1 addLineToPoint:CGPointMake(XcenterOfCircle+ 5, 27)];
    
    UIBezierPath *linePath2 = [UIBezierPath bezierPath];
    [linePath2 moveToPoint:CGPointMake(XcenterOfCircle+ 5, 17)];
    [linePath2 addLineToPoint:CGPointMake(XcenterOfCircle - 5, 27)];
    
    //拼接两个path
    [path appendPath:linePath1];
    [path appendPath:linePath2];
    self.waitingShapeLayer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if (self.waitingShapeLayer.strokeEnd == 1.0) {
        [animation setFromValue:@1.0];
        [animation setToValue:@0.0];
    }else{
        [animation setFromValue:@0.0];
        [animation setToValue:@1.0];
    }
    animation.duration = 1.2f;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [self.waitingShapeLayer addAnimation:animation forKey:@"payFail"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [UIView animateWithDuration:endDuration delay:0.2f options:UIViewAnimationOptionCurveLinear animations:^{
        //若无变化，则此处endDuration时间直接跳过
        self.titleLabel.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (anim == [self.waitingShapeLayer animationForKey:@"paySuccess"]) {
            [self.waitingShapeLayer removeAnimationForKey:@"paySuccess"];
            [self.waitingShapeLayer removeFromSuperlayer];
            self.waitingShapeLayer = nil;
            
            self.titleEdgeInsets = UIEdgeInsetsZero;
            self.userInteractionEnabled = YES;
            [self setTitle:self.defaultTitleStr forState:UIControlStateNormal];
            
            if(self.btnStopBlock != nil){
                self.btnStopBlock();
            }
        }else{
            [self.waitingShapeLayer removeAnimationForKey:@"payFail"];
            [self.waitingShapeLayer removeFromSuperlayer];
            self.waitingShapeLayer = nil;
            self.titleEdgeInsets = UIEdgeInsetsZero;
            self.userInteractionEnabled = YES;
            [self setTitle:self.defaultTitleStr forState:UIControlStateNormal];
        }
    }];
}
#pragma mark - 懒加载
-(UIActivityIndicatorView *)activityView{
    if (_activityView == nil) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.center = CGPointMake(self.frame.size.width/2-40, self.frame.size.height/2);
        [self addSubview:activityView];
        _activityView = activityView;
    }
    return _activityView;
}
-(CAShapeLayer *)waitingShapeLayer{
    if (_waitingShapeLayer == nil) {
        CAShapeLayer *waitingShapeLayer = [CAShapeLayer layer];
        waitingShapeLayer.fillColor = [UIColor clearColor].CGColor;
        waitingShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        waitingShapeLayer.lineWidth = 1.5f;
        waitingShapeLayer.strokeStart = 0;
        waitingShapeLayer.strokeEnd = 0;
        [self.layer addSublayer:waitingShapeLayer];
        _waitingShapeLayer = waitingShapeLayer;
    }
    return _waitingShapeLayer;
}

@end
