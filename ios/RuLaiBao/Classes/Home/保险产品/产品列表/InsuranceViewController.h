//
//  InsuranceViewController.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/2.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"

@interface InsuranceViewController : MainViewController

//选中类型
@property (nonatomic, assign) NSInteger selectIndex;

//一老一小: oldSmall.如果不是这个保障，不传;
@property (nonatomic, strong) NSString *securityTypeStr;

@end
