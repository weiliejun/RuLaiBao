//
//  NoticeModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/5.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject
/** 公告id */
@property (nonatomic,copy)NSString *Id;
/** 公告名称 */
@property (nonatomic,copy)NSString *topic;
/** 公告内容 */
@property (nonatomic,copy)NSString *descriptionStr;
/** 发布时间 */
@property (nonatomic,copy)NSString *publishTime;
/** 发布者 */
@property (nonatomic,copy)NSString *publisherName;
/** 已读/未读 */
@property (nonatomic,copy)NSString *readState;
/** 置顶 */
@property (nonatomic,copy)NSString *topMark;


+ (instancetype)noticeListModelWithDictionary:(NSDictionary *)KVCDic;


@end
