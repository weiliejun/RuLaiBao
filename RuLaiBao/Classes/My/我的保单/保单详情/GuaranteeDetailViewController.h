//
//  GuaranteeDetailViewController.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/8.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"

/** 无数据回调刷新 */
typedef void(^GuaranteeDetailNoDataBlock)(void);

@interface GuaranteeDetailViewController : MainViewController

//保单编号
@property (nonatomic, strong) NSString *orderId;

/** 无数据回调刷新上个页面 */
@property (nonatomic, copy) GuaranteeDetailNoDataBlock noDataBlock;


@end
