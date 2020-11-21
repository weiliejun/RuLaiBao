//
//  HDPhotoBrowserLoadingView.m
//  HaiDeHui
//
//  Created by junde on 2017/6/6.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "HDPhotoBrowserLoadingView.h"

@implementation HDPhotoBrowserLoadingView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.frame = CGRectMake(0, 0, 50, 50); // 默认自身大小
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = YES;

    }
    return self;
}

#pragma mark - 进度属性的setter方法
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
    if (progress >= 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
        
    }
}

#pragma mark - 重写drawRect方法
- (void)drawRect:(CGRect)rect {
    
    CGContextRef contexR = UIGraphicsGetCurrentContext();
    CGFloat centerX = rect.size.width / 2;
    CGFloat centerY = rect.size.height / 2;
    [[UIColor whiteColor] set];
    
    
    CGContextSetLineWidth(contexR, 5);
    CGContextSetLineCap(contexR, kCGLineCapRound);
    CGFloat radius = MIN(centerX, centerY) - 5;
    CGFloat from = - M_PI / 2;
    CGFloat to = - M_PI / 2 + self.progress * 2 * M_PI + 0.1;
    CGContextAddArc(contexR, centerX, centerY, radius, from, to, 0);
    CGContextStrokePath(contexR);
    
}


@end
