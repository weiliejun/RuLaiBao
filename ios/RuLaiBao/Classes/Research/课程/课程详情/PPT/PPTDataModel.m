//
//  PPTDataModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/9/12.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "PPTDataModel.h"

@implementation PPTDataModel
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"courseFileName" : @"attachmentFile.courseFileName",
             @"courseFilePath" : @"attachmentFile.courseFilePath"
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pptImgs":[NSString class]};
}
@end
