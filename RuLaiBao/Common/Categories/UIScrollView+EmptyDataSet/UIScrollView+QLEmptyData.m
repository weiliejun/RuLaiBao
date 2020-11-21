//
//  UIScrollView+QLEmptyData.m
//  WeiJinKe
//
//  Created by qiu on 2018/1/29.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "UIScrollView+QLEmptyData.h"
#import <objc/runtime.h>

@implementation UIScrollView (QLEmptyData)
static const BOOL loadingKey;
static const char loadedImageNameKey;
static const char descriptionTextKey;
static const char buttonTextKey;
static const char buttonNormalColorKey;
static const char buttonHighlightColorKey;
static const CGFloat dataVerticalOffsetKey;

static const char emptyDataSetTypeKey;

id (^block)(void);

-(void)addNoDataDelegateAndDataSource{
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
}

#pragma mark set Mettod
-(void)setLoading:(BOOL)loading
{
    if (self.isLoading == loading) {
        return;
    }
    
    // 这个&loadingKey也可以理解成一个普通的字符串key，用这个key去内存寻址取值
    objc_setAssociatedObject(self, &loadingKey, @(loading), OBJC_ASSOCIATION_ASSIGN);
    // 一定要放在后面，因为上面的代码在设值，要设置完之后数据源的判断条件才能成立
    
    [self reloadEmptyDataSet];
}
-(void)setLoadingClick:(void (^)(void))loadingClick{
    objc_setAssociatedObject(self, &block, loadingClick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void)setLoadedImageName:(NSString *)loadedImageName{
    objc_setAssociatedObject(self, &loadedImageNameKey, loadedImageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void)setDataVerticalOffset:(CGFloat)dataVerticalOffset{
    objc_setAssociatedObject(self, &dataVerticalOffsetKey,@(dataVerticalOffset),OBJC_ASSOCIATION_RETAIN);// 如果是对象，请用RETAIN。坑
}
-(void)setDescriptionText:(NSString *)descriptionText{
    objc_setAssociatedObject(self, &descriptionTextKey, descriptionText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void)setButtonText:(NSString *)buttonText{
    objc_setAssociatedObject(self, &buttonTextKey, buttonText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void)setButtonNormalColor:(UIColor *)buttonNormalColor{
    objc_setAssociatedObject(self, &buttonNormalColorKey, buttonNormalColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)setButtonHighlightColor:(UIColor *)buttonHighlightColor{
    objc_setAssociatedObject(self, &buttonHighlightColorKey, buttonHighlightColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)QLExtensionLoading:(loadingBlock)block{
    if (self.loadingClick) {
        block = self.loadingClick;
    }
    self.loadingClick = block;
}
-(void)setEmptyDataSetType:(EmptyDataSetType)emptyDataSetType{
    objc_setAssociatedObject(self, &emptyDataSetTypeKey, @(emptyDataSetType), OBJC_ASSOCIATION_ASSIGN);
}
#pragma mark get Mettod
-(BOOL)isLoading{
    // 注意，取出的是一个对象，不能直接返回
    id tmp = objc_getAssociatedObject(self, &loadingKey);
    NSNumber *number = tmp;
    return number.unsignedIntegerValue;
}
-(void (^)(void))loadingClick{
    return objc_getAssociatedObject(self, &block);
}
-(NSString *)loadedImageName{
    return objc_getAssociatedObject(self, &loadedImageNameKey);
}
-(CGFloat)dataVerticalOffset{
    id temp = objc_getAssociatedObject(self, &dataVerticalOffsetKey);
    NSNumber *number = temp;
    return number.floatValue;
}
-(NSString *)descriptionText{
    return objc_getAssociatedObject(self, &descriptionTextKey);
}
-(NSString *)buttonText{
    return objc_getAssociatedObject(self, &buttonTextKey);
}
-(UIColor *)buttonNormalColor{
    return objc_getAssociatedObject(self, &buttonNormalColorKey);
}
-(UIColor *)buttonHighlightColor{
    return objc_getAssociatedObject(self, &buttonHighlightColorKey);
}
-(EmptyDataSetType)emptyDataSetType{
    id emptyID = objc_getAssociatedObject(self, &emptyDataSetTypeKey);
    NSNumber *number = emptyID;
    return number.unsignedIntegerValue;
}

#pragma mark - DZNEmptyDataSetSource
// 返回一个自定义的view（优先级最高）
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        return activityView;
    }else {
        return nil;
    }
}
// 返回一张空状态的图片在文字上面的
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        return nil;
    }
    else
    {
        NSString *imageName = @"NoData";
        switch (self.emptyDataSetType) {
            case EmptyDataSetTypeNetwork:
                imageName = @"NoData";
                break;
            case EmptyDataSetTypeOrder:
                imageName = @"NoData";
                break;
            case EmptyDataSetTypeSearchList:
                imageName = @"NoData";
                break;
            default:
                break;
        }
        if (self.loadedImageName) {
            imageName = self.loadedImageName;
        }
        return [UIImage imageNamed:imageName];
    }
}
// 空状态下的文字详情
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        return nil;
    }else {
        NSString *text = @"";
        switch (self.emptyDataSetType) {
            case EmptyDataSetTypeNetwork:
                text = @"没有网络，请检查网络！";
                break;
            case EmptyDataSetTypeOrder:
                text = @"暂无数据，点击重新获取!";
                break;
            case EmptyDataSetTypeSearchList:
                text = @"暂无数据!";
                break;
            default:
                break;
        }
        
        if (self.descriptionText) {
            text = self.descriptionText;
        }
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                     NSParagraphStyleAttributeName: paragraph};
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
}
// 返回最下面按钮上的文字
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (self.isLoading) {
        return nil;
    }else {
        if (self.emptyDataSetType == EmptyDataSetTypeNetwork) {
            UIColor *textColor = nil;
            
            // 某种状态下的颜色
            UIColor *colorOne = UINavigationBar.appearance.barTintColor;
            colorOne = colorOne ? colorOne : [UIColor redColor];// 取出来有可能是空
            UIColor *colorTow = [colorOne colorWithAlphaComponent:0.35];
            // 判断外部是否有设置
            colorOne = self.buttonNormalColor ? self.buttonNormalColor : colorOne;
            colorTow = self.buttonHighlightColor ? self.buttonHighlightColor : colorTow;
            textColor = state == UIControlStateNormal ? colorOne : colorTow;
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                         NSForegroundColorAttributeName: textColor};
            
            return [[NSAttributedString alloc] initWithString:self.buttonText ? self.buttonText : @"检查网络" attributes:attributes];
        }else{
            return nil;
        }
    }
}
// 返回试图的垂直位置（调整整个试图的垂直位置）
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.dataVerticalOffset != 0) {
        return self.dataVerticalOffset;
    }
    return 0.0;
}
// 返回空白区域的颜色自定义
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}
#pragma mark - DZNEmptyDataSetDelegate Methods
// 返回是否显示空状态的所有组件，默认:YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}
// 返回是否允许交互，默认:YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    // 只有非加载状态能交互
    return !self.isLoading;
}
// 返回是否允许滚动，默认:YES
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}
// 返回是否允许空状态下的图片进行动画，默认:NO
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return YES;
}
//  点击空状态下的view会调用
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self blackInfo];
}
// 点击空状态下的按钮会调用
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    [self blackInfo];
}

-(void)blackInfo{
    if (self.loadingClick) {
        switch (self.emptyDataSetType) {
            case EmptyDataSetTypeNetwork:
                //去检查网络
            {
                NSString * urlString = UIApplicationOpenSettingsURLString;
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
                    } else {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                    }
                }
            }
                break;
            case EmptyDataSetTypeOrder:
            {
                self.loadingClick();
            }
                break;
            case EmptyDataSetTypeSearchList:
            {
                self.loadingClick();
            }
                break;
            default:
                break;
        }
        
    }
}
@end

