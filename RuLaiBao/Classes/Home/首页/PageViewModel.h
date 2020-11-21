//
//  PageViewModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/28.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageViewModel : NSObject
/** 认证状态 */
@property (nonatomic,copy) NSString *checkStatus;
/** id */
@property (nonatomic,copy) NSString *Id;
/** 产品名称 */
@property (nonatomic,copy) NSString *name;
/** 推广费 */
@property (nonatomic,copy) NSString *promotionMoney;
/** 推荐封面图片 */
@property (nonatomic,copy) NSString *recommenCover;
/** 推荐语 */
@property (nonatomic,copy) NSString *recommendations;


+ (instancetype)pageViewModelWithDictionary:(NSDictionary *)KVCDic;

@end
