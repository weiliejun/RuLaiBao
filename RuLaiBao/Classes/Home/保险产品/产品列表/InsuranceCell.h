//
//  InsuranceCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/3.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InsuranceListModel;
@class InsuranceSearchModel;

@interface InsuranceCell : UITableViewCell

- (void)setInsuranceListModelWithDictionary:(InsuranceListModel *)model;

- (void)setSearchListModelWithDictionary:(InsuranceSearchModel *)model;

@end
