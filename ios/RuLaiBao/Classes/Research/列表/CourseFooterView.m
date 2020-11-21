//
//  CourseFooterView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/26.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "CourseFooterView.h"
#import "Configure.h"
#import "RLBListNoDataTipView.h"

/*!
 height = 200
 */
@implementation CourseFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

-(void)createUI{
    CGFloat imageWH = 120;
    CGFloat imageX =(Width_Window - imageWH) / 2;
    CGFloat imageY =  30;
    CGFloat titleY = 30 + imageWH ;
    RLBListNoDataTipView *noDataFooterView = [[RLBListNoDataTipView alloc]
                                              initWithFrame:CGRectMake(0, 0, Width_Window, 200)
                                              backgroundColor:[UIColor clearColor]
                                              imageFrame:CGRectMake(imageX, imageY, imageWH, imageWH)
                                              imageName:@"NoData"
                                              titleFrame:CGRectMake(10, titleY,Width_Window - 20, 30)
                                              tipText:@"暂无热门问答"];
    [self addSubview:noDataFooterView];
}
@end
