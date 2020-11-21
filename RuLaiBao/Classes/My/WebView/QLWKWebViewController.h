//
//  QLWKWebViewController.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/20.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"


//返回
typedef NS_ENUM(NSInteger, WebViewCanGoBack) {
    WebViewCanGoBackYES = 9000,//可以goBack
    WebViewCanGoBackNO ,  //不可以
};

//title
typedef NS_ENUM(NSInteger, WebViewTitleCanTransform) {
    WebViewTitleCanTransformNo  = 90000,  //不可以
    WebViewTitleCanTransformYES       //可以
};

@interface QLWKWebViewController : MainViewController

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *titleStr;

/** default NO */
@property (nonatomic, assign) WebViewCanGoBack webViewGoBackStatus;
@property (nonatomic, assign) WebViewTitleCanTransform webViewTitleCanTransformStatus;

@end
