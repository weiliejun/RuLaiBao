//
//  GroupDetailViewController.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/11.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "MainViewController.h"
/** 无数据回调刷新 */
typedef void(^DetailDataNoDataTipBlock)(void);
@class GroupListModel;
@interface GroupDetailViewController : MainViewController

@property (nonatomic, strong) GroupListModel *listModel;

/** 无数据回调刷新上个页面 */
@property (nonatomic, copy) DetailDataNoDataTipBlock noDataBlock;
@end
