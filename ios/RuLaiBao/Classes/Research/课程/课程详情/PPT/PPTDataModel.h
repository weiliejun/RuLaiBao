//
//  PPTDataModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/9/12.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPTDataModel : NSObject
/** 文件名称 */
@property (nonatomic, copy) NSString *courseFileName;
/** 文件路径 */
@property (nonatomic, copy) NSString *courseFilePath;
/** 我的圈子列表 */
@property (nonatomic, strong) NSArray <NSString *> *pptImgs;
@end
