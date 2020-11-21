//
//  ProspectusModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/2.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProspectusModel : NSObject
/** id */
@property (nonatomic,copy) NSString *Id;
/** logo */
@property (nonatomic,copy) NSString *logo;
/** 产品名称 */
@property (nonatomic,copy) NSString *name;
/** 推荐语 */
@property (nonatomic,copy) NSString *recommendations;
/** 跳转链接 */
@property (nonatomic,copy) NSString *prospectus;


+ (instancetype)prospectusListModelWithDictionary:(NSDictionary *)KVCDic;


@end
