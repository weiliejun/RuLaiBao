//
//  CommissionListCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/14.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CommissionListModel;

@interface CommissionListCell : UITableViewCell

//佣金明细
- (void)setCommissionListModelWithDictionary:(CommissionListModel *)model;

@end

NS_ASSUME_NONNULL_END
