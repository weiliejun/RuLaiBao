//
//  RLBCheckVersionTool.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/25.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLBCheckVersionTool : NSObject
/** 检测版本有无更新 */
+ (void)checkApplicationVersionWithAppID:(NSString *)appID;
@end
