//
//  NewsGroupTableViewCell.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsGroupTableViewCell;
/** 返回值 */
typedef void(^AgreeBtnClickBlock)(NewsGroupTableViewCell *cell);

@class NewsGroupApplyModel;
@interface NewsGroupTableViewCell : UITableViewCell
/** 数据 */
@property (nonatomic, strong, getter=cellModel) NewsGroupApplyModel *applyCellModel;

/** 点击block */
@property (nonatomic, copy) AgreeBtnClickBlock btnClick;

/** 同意 */
@property (nonatomic, assign) BOOL IsAgreeState;

@end
