//
//  ResearchModulesView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "ResearchModulesView.h"
#import "Configure.h"

@implementation ResearchModulesView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}
#pragma mark - 设置界面元素
- (void)createUI{
    CGFloat controlW = self.width/4;
    CGFloat controlH = self.height-8;
    NSArray *imageArr = @[@"YX_KC",@"YX_WD",@"YX_QZ",@"YX_ZY"];
    NSArray *titleStrArr = @[@"课程",@"问答",@"圈子",@"展业"];
    for (int i = 0 ; i < 4; i++) {
        [self createControlWithControlFrame:CGRectMake(i * controlW, 0, controlW, controlH) ControlType:ControlTypeCourse+i ImageName:imageArr[i] LabelStr:titleStrArr[i]];
    };
}

-(void)createControlWithControlFrame:(CGRect)frame ControlType:(ControlType)controlType ImageName:(NSString *)imageName LabelStr:(NSString *)labelStr{
    UIControl *control = [[UIControl alloc]initWithFrame:frame];
    [control addTarget:self action:@selector(clickControl:) forControlEvents:UIControlEventTouchUpInside];
    control.backgroundColor = [UIColor whiteColor];
    control.tag = controlType;
    [self addSubview:control];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(control.width/2 - 25, 10, 50, 50)];
    imageView.image = [UIImage imageNamed:imageName];
    [control addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, control.width, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor customTitleColor];
    label.text = labelStr;
    [control addSubview:label];
}
-(void)clickControl:(UIControl *)sender{
    if (self.controlClick != nil) {
        self.controlClick(sender.tag);
    }
}
@end
