//
//  DetailQuestionCell.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QuestionCellControlType){
    QuestionCellControlTypeMsg     = 1000,//消息
    QuestionCellControlTypeLink           ,//点赞
};

@class DetailQuestionCell;
/** 返回值 */
typedef void(^QuestionCellControlClickBlock)(QuestionCellControlType index, DetailQuestionCell *detailCell);

@class DetailQuestionModel;
@interface DetailQuestionCell : UITableViewCell

@property (nonatomic, strong) DetailQuestionModel *questionModel;
@property (nonatomic, assign) BOOL isLikeSelect;

@property (nonatomic, copy) QuestionCellControlClickBlock controlClick;
@end
