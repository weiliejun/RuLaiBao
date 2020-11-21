//
//  WeakScriptMessageDelegate.h
//  WeiJinKe
//
//  Created by qiu on 2017/8/10.
//  Copyright © 2017年 yuanyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WeakScriptMessageDelegate : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

