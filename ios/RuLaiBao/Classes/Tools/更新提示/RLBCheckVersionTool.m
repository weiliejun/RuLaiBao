//
//  RLBCheckVersionTool.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/25.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "RLBCheckVersionTool.h"
#import <UIKit/UIKit.h>

@implementation RLBCheckVersionTool
+ (void)checkApplicationVersionWithAppID:(NSString *)appID {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    // 简单的请求 默认请求方法就是 GET
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || error != nil || data == nil) {
            return ;
        }
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *releaseArray = jsonDict[@"results"];
        if (releaseArray.count == 0) {
            return ;
        }
        NSDictionary *releaseDict = releaseArray.firstObject;
        NSString *releaseVerson = releaseDict[@"version"];
        NSString *forcedUpgradeVersion =releaseVerson;
        releaseVerson = [releaseVerson stringByReplacingOccurrencesOfString:@"." withString:@""];
        // 项目名称
        //        NSString *trackName = releaseDict[@"trackName"];
        // 去 AppStore 中更新的url
        NSString *trackViewUrlStr = releaseDict[@"trackViewUrl"];
        NSURL *trackViewUrl = [NSURL URLWithString:trackViewUrlStr];
        
        // 获取当前手机上安装的该 App 的版本号
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        double doubleCurrentVersion = [currentVersion doubleValue];
        double doubleUpdateVersion =[releaseVerson doubleValue];
        // 可以比较字符串,也可以转换成整数 NSInteger 比较大小
        if (doubleCurrentVersion < doubleUpdateVersion) {
            if ([forcedUpgradeVersion hasSuffix:@".0"]) {
                //必须升级
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"如来保" message:@"有新版本，请升级！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *upVersionAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self OpenUrlToStoreWithUrl:trackViewUrl];
                }];
                [alertVC addAction:upVersionAction];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
                });
            }else{
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"如来保" message:@"有新版本，请升级！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *upVersionAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self OpenUrlToStoreWithUrl:trackViewUrl];
                }];
                [alertVC addAction:cancelAction];
                [alertVC addAction:upVersionAction];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
                });
            }
        }
    }] resume];
}
+ (void)OpenUrlToStoreWithUrl:(NSURL *)trackViewUrl{
    if ([[UIApplication sharedApplication] canOpenURL:trackViewUrl]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:trackViewUrl options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(NO)} completionHandler:^(BOOL success) {
                    NSLog(@"success --> %d",success);
                }];
            } else {
                // Fallback on earlier versions
            }
        } else {
            [[UIApplication sharedApplication] openURL:trackViewUrl];
        }
    }
}
@end
