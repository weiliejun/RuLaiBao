//
//  MyAskedModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAskedModel : NSObject
/** 问题id */
@property (nonatomic,copy)NSString *questionId;
/** 问题标题 */
@property (nonatomic,copy)NSString *title;
/** 回复总数 */
@property (nonatomic,copy)NSString *answerCount;


+ (instancetype)myAskedListModelWithDictionary:(NSDictionary *)KVCDic;


@end
