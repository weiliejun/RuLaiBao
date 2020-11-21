//
//  MySalaryCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MySalaryModel;

@interface MySalaryCell : UITableViewCell

- (void)setMySalaryModelWithDictionary:(MySalaryModel *)model;

@end

NS_ASSUME_NONNULL_END
