//
//  InformationModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/26.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationModel : NSObject

/** 头像 */
@property (nonatomic,copy) NSString *headPhoto;
/** 手机号 */
@property (nonatomic,copy) NSString *mobile;
/** 认证状态 */
@property (nonatomic,copy) NSString *checkStatus;
/** 真实姓名 */
@property (nonatomic,copy) NSString *realName;
/** 名片 */
@property (nonatomic,copy)NSString *busiCardPhoto;
/** 从业岗位 */
@property (nonatomic,copy)NSString *position;
/** 身份证号 */
@property (nonatomic,copy)NSString *idNo;
/** 地址 */
@property (nonatomic,copy)NSString *area;


+ (instancetype)informationModelWithDictionary:(NSDictionary *)KVCDic;


@end
