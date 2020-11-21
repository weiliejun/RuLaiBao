//
//  SalaryDetailCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/14.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SalaryDetailCell : UITableViewCell

/** 右侧内容 */
@property (nonatomic,weak) UILabel *detailLabel;

#pragma mark - 设置标题
- (void)setTitle:(NSString *)titleStr;

#pragma mark - 设置颜色
- (void)setLineColor:(NSString *)colorStr;


@end

NS_ASSUME_NONNULL_END
