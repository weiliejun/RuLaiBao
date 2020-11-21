//
//  DetailTopView.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTopView : UIView

@property (nonatomic, copy) NSString *urlStr;

//无法调用视频暂停功能，所以只能重新加载url 并且因为内部存在跳转，故reload无法使用
- (void)reloadWebViewUrl;
@end
