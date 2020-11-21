//
//  InsuranceDetailViewController.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/2.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"

/** 无数据回调刷新 */
typedef void(^InsuranceDetailNoDataBlock)(void);

@interface InsuranceDetailViewController : MainViewController

//产品Id
@property (nonatomic, strong) NSString *Id;

/** 无数据回调刷新上个页面 */
@property (nonatomic, copy) InsuranceDetailNoDataBlock noDataBlock;


@end
