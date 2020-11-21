//
//  DES3Util.h
//  WeiJinKe
//
//  Created by mac2015 on 15/3/23.
//  Copyright (c) 2015年 mac2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@interface DES3Util : NSObject


// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText;
@end
