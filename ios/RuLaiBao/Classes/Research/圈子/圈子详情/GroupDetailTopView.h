//
//  GroupDetailTopView.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/12.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TopSetBtnType){
    TopSetBtnTypeJoin    = 10010,//加入
    TopSetBtnTypeSet           ,//权限
    TopSetBtnTypeOut           ,//退出
};
typedef void(^TopSetBtnClickBlock)(TopSetBtnType btnType);

@class GroupListModel;
@interface GroupDetailTopView : UIView
@property (nonatomic, weak, readonly) UIImageView *bgImageV;

@property (nonatomic, strong) GroupListModel *detailTopModel;


@property (nonatomic, copy) TopSetBtnClickBlock topSetBtnClickBlock;
@end
