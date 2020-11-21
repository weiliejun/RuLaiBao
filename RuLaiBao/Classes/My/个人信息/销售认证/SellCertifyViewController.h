//
//  SellCertifyViewController.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"

@class InformationModel;

@interface SellCertifyViewController : MainViewController

@property (nonatomic, assign) BOOL isHaveImage;//是否已上传名片

@property (nonatomic, strong) InformationModel *informationModel;


@end
