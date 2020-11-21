//
//  MyBankCardCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/14.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyBankCardModel;

typedef void(^DeleteCardButtonClick)(void);

typedef void(^SalaryCardButtonClick)(void);

@interface MyBankCardCell : UITableViewCell

/** 删除银行卡 */
@property (nonatomic, copy) DeleteCardButtonClick deleteBlock;

/** 设为工资卡 */
@property (nonatomic, copy) SalaryCardButtonClick salaryBlock;


- (void)setMyBankCardModelWithDictionary:(MyBankCardModel *)model;



@end

NS_ASSUME_NONNULL_END
