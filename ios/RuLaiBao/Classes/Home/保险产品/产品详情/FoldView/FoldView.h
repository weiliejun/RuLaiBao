//
//  FoldView.h
//  QLScrollViewDemo
//
//  Created by qiu on 2018/6/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoldView : UIView

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, assign, readonly) BOOL IsExpand;
/** 回调点击组头 */
//@property (nonatomic, copy) void (^reloadSectionHeaderViewBlock)(CGFloat viewHeight ,FoldView *view);

@end
