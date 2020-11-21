//
//  appointmentViewController.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/4.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"

/** 无数据回调刷新 */
typedef void(^appointmentNoDataBlock)(void);

@interface appointmentViewController : MainViewController
//公司
@property (nonatomic, strong) NSString *companyName;
//险种类别
@property (nonatomic, strong) NSString *productCategory;
//保险产品id
@property (nonatomic, strong) NSString *productId;
//产品名称
@property (nonatomic, strong) NSString *productName;

/** 无数据回调刷新上个页面 */
@property (nonatomic, copy) appointmentNoDataBlock noDataBlock;



@end
