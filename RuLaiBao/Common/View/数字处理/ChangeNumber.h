//
//  ChangeNumber.h
//  jundehui
//
//  Created by kingstartimes on 16/8/1.
//  Copyright © 2016年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeNumber : NSObject

//把数字转换为每三位加一个逗号
- (id)changeNumber:(NSString *)string;
- (id)changeFont:(NSString *)string;

@end
