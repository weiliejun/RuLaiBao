//
//  UIView+Common.m
//  BlueMobiProject
//
//  Created by 朱 亮亮 on 14-4-28.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)removeAllSubviews
{
	while (self.subviews.count)
    {
		UIView *child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

- (NSData *)viewConvertToPDFWithWidth:(CGFloat)Width height:(CGFloat)Height {
    
    UIPrintPageRenderer *pageRender = [[UIPrintPageRenderer alloc] init];
    [pageRender addPrintFormatter:self.viewPrintFormatter startingAtPageAtIndex:0];
    
    CGFloat margin = 15;
    // 按A4标准像素 当分辨率为300的时候 像素长宽 3508×2479
    // 但是如果不是为了打印,只是为了分享,这里可以按设计分辨率,以屏幕点来计算
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (Width > 0) {
        width = Width;
    }
    if (Height > 0) {
        height = Height;
    }
    CGRect paperRect = CGRectMake(0, 0, width, height);
    CGRect printableRect =  CGRectMake(margin, margin, width - 2 * margin, height - 2 *margin);
    [pageRender setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
    [pageRender setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    
    // 获取打印内容
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, pageRender.paperRect, nil);
    
    CGRect bounds = UIGraphicsGetPDFContextBounds();
    for (NSInteger index = 0; index < pageRender.numberOfPages; index++) {
        UIGraphicsBeginPDFPage();
        [pageRender drawPageAtIndex:index inRect:bounds];
    }
    UIGraphicsEndPDFContext();
    
    return pdfData;
}


@end
