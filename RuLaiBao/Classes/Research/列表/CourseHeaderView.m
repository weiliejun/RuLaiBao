//
//  CourseHeaderView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "CourseHeaderView.h"
#import "Configure.h"

@interface CourseHeaderView()

//左边title
@property (nonatomic, weak) UILabel *titleLabel;

//换一换按钮
@property (nonatomic, weak) UIImageView *exchangeImageV;
//换一换
@property (nonatomic, weak) UIControl *exchangeControl;
@end

@implementation CourseHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor customBackgroundColor];
        [self setupUI];
    }
    return self;
}
#pragma mark - 设置数据
- (void)setIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            self.titleLabel.text = @"精品课程";
            [self exchangeControl];
            self.exchangeControl.enabled = YES;
        }
            break;
        case 1:{
            self.titleLabel.text = @"热门问答";
            self.exchangeControl.hidden = YES;
            self.exchangeControl = nil;
        }
            break;
        default:
            break;
    }
}
-(void)exchangeControlclick:(UIControl *)sender{
    if (self.exchangeBtnBlock != nil) {
        self.exchangeBtnBlock();
        [self setIsAnimation:YES];
    }
}
-(void)setIsAnimation:(BOOL)isAnimation{
    _isAnimation = isAnimation;
    if (isAnimation) {
        //正在请求数据则禁止点击
        self.exchangeControl.enabled = NO;
    }else{
        self.exchangeControl.enabled = YES;
    }
    if (self.exchangeImageV != nil && isAnimation) {
        [self imageVToAnimation];
    }else{
        [self endAnimation];
    }
}
-(void)imageVToAnimation{
    //判断是否已经常见过动画，如果已经创建则不再创建动画
    CAAnimation *animation= [self.exchangeImageV.layer animationForKey:@"KCBasicAnimation_Translation"];
    if(animation == nil){
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
        rotationAnimation.duration = 1;
        rotationAnimation.repeatCount = HUGE_VALF;
        rotationAnimation.removedOnCompletion = NO;//执行完成后动画对象不要移除
        [self.exchangeImageV.layer addAnimation:rotationAnimation forKey:@"KCBasicAnimation_Translation"];
    }
}
-(void)endAnimation{
    [self.exchangeImageV.layer removeAllAnimations];//停止动画
}
#pragma mark - 设置界面元素
- (void)setupUI {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, self.height-5)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor customTitleColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self addSubview:titleLabel];
    
    _titleLabel = titleLabel;
}

-(UIControl *)exchangeControl{
    if (!_exchangeControl) {
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(self.frame.size.width-150, 5, 150, self.height-5)];
        [control addTarget:self action:@selector(exchangeControlclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:control];
        
        UILabel *exchangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(control.width-70, 0, 60, control.height)];
        exchangeLabel.text = @"换一换";
        exchangeLabel.textColor = [UIColor customDetailColor];
        exchangeLabel.font = [UIFont systemFontOfSize:KFontDetailSize];
        [control addSubview:exchangeLabel];
    
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(exchangeLabel.left-25, control.height/2-9, 20, 17)];
        imageV.image = [UIImage imageNamed:@"YX_hh"];
        [control addSubview:imageV];
        
        _exchangeControl = control;
        _exchangeImageV = imageV;
    }
    return _exchangeControl;
}


@end
