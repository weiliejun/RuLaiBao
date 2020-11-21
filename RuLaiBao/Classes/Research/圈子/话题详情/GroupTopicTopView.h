//
//  GroupTopicTopView.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/12.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TopBtnType){
    TopBtnTypeTop       = 10010,//置顶
    TopBtnTypeLike           ,//点赞
};
//点赞
typedef void(^LikeBtnClickBlock)(TopBtnType topBtnType);

@class GroupDetailTopicModel;
@interface GroupTopicTopView : UIView
/** 赋值 */
@property (nonatomic, strong) GroupDetailTopicModel *detailTopModel;

@property (nonatomic, weak, readonly) UILabel *answerNumLabel;
@property (nonatomic, copy) NSString *isLikeSelect;
@property (nonatomic, copy) NSString *isTopStatus;

@property (nonatomic, copy) LikeBtnClickBlock likeBtnClickBlock;
@end
