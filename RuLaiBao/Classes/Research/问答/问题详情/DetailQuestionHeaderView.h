//
//  DetailQuestionHeaderView.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 点击回调 */
@class DetailQuestionHeaderView;
typedef void(^SortBtnClickBlock)(DetailQuestionHeaderView *headView);

@class QAListModel;
@interface DetailQuestionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak, readonly) UIButton *sortBtn;
@property (nonatomic, weak, readonly) UIImageView *imageView;

@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *btnTitleStr;

@property (nonatomic, copy) SortBtnClickBlock sortBtnClickBlock;
@end
