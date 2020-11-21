//
//  WeakScriptMessageDelegate.m
//  WeiJinKe
//
//  Created by qiu on 2017/8/10.
//  Copyright © 2017年 yuanyuan. All rights reserved.
//

#import "WeakScriptMessageDelegate.h"

@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

//-(void)dealloc{
//    NSLog(@"%s",__func__);
//}
@end
