//
//  BorrowerInfoHeaderView.h
//  WeiJinKe
//
//  Created by qiu on 2018/1/26.
//  Copyright © 2018年 yuanyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeaderViewClearBlock)(void);

@interface BorrowerInfoHeaderView : UICollectionReusableView
@property (nonatomic, weak) UILabel *headerLabel;
@property (nonatomic, assign) BOOL isShowClearBtn;
@property (nonatomic, copy) HeaderViewClearBlock headerViewClearBlock;
@end
