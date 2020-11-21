//
//  QADetailViewController.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/9.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"

/** 无数据回调刷新 */
typedef void(^DetailDataNoDataTipBlock)(void);


@class QAListModel;
@interface QADetailViewController : MainViewController

/** 未用 */
@property (nonatomic, strong) QAListModel *listModel;

/** 问题ID */
@property (nonatomic, copy) NSString *questionId;

/** 无数据回调刷新上个页面 */
@property (nonatomic, copy) DetailDataNoDataTipBlock noDataBlock;

@end
