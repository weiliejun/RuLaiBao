//
//  NewsTypeViewController.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"

//两个按钮
typedef NS_ENUM(NSInteger, NewsType) {
    NewsTypeCommission  = 100001,  //佣金消息
    NewsTypePolicy,                //保单消息
    NewsTypeOther                 //其他消息
};
@interface NewsTypeViewController : MainViewController

/*!
 @property
 @abstract  title
 */
@property (nonatomic, copy) NSString *titleStr;
/*!
 @property
 @abstract  类型
 */
@property (nonatomic, assign) NewsType newsType;

@end
