//
//  UnpayCommissionCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/13.
//  Copyright © 2018年 junde. All rights reserved.
//


/**
 * 已发佣金和待发佣金共用此cell
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UnpayCommissionModel;

@interface UnpayCommissionCell : UITableViewCell

//待发佣金
- (void)setUnpayModelWithDictionary:(UnpayCommissionModel *)model;

//已发佣金
- (void)setPayedModelWithDictionary:(UnpayCommissionModel *)model;

@end

NS_ASSUME_NONNULL_END
