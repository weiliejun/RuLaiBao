//
//  ResearchHotListModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/26.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 list =         (
 {
     answerCount = 0;
     descript = "\U7167\U987e\U3002";
     questionId = 16032511135331123346;
     title = "\U751f\U96be\U9898";
     userName = leige000;
 },
 );
 */

@interface ResearchHotListModel : NSObject
/** 问题id */
@property (nonatomic, copy) NSString *questionId;
/** 问题标题 */
@property (nonatomic, copy) NSString *title;
/** 问题描述 */
@property (nonatomic, copy) NSString *descript;
/** 问题发布人姓名 */
@property (nonatomic, copy) NSString *userName;
/** 回复总数 */
@property (nonatomic, copy) NSString *answerCount;
//item的高度
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, copy) NSMutableAttributedString *mutablAttrStr;

-(instancetype)initHotListModelWithDic:(NSDictionary *)dic;
@end
