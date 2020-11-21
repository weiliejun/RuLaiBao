//
//  DetailAnswerTopView.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>
//点赞
typedef void(^LikeBtnClickBlock)(void);

@class DetailQuestionModel;
@interface DetailAnswerTopView : UIView

/** 赋值 */
@property (nonatomic, strong) DetailQuestionModel *detailTopModel;
@property (nonatomic, weak, readonly) UILabel *answerNumLabel;
@property (nonatomic, weak, readonly) UILabel *titleLabel;
@property (nonatomic, copy) NSString *isLikeSelect;
@property (nonatomic, copy) LikeBtnClickBlock likeBtnClickBlock;
@end
