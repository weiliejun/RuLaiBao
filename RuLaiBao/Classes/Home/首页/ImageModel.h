//
//  ImageModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/28.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject
/** 名称 */
@property (nonatomic,copy) NSString *name;
/** 图片地址 */
@property (nonatomic,copy) NSString *picture;
/** URL */
@property (nonatomic,copy) NSString *targetUrl;
/** 图片状态 */
//@property (nonatomic,copy) NSString *status;
/** url:h5页面;product:保险产品详情;none:无跳转 */
@property (nonatomic,copy) NSString *linkType;


+ (instancetype)imageModelWithDictionary:(NSDictionary *)KVCDic;


@end
