//
//  LockViewController.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/11.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"

typedef NS_ENUM (NSInteger , LockModel){
    LockModelOpen = 1000,    //打开手势 (需输入两边)
    LockModelClose,      //关闭密码
    LockModelChange, //修改密码 (先输一遍验证，通过后再输两边保存)
    LockModelUnLock,   //解锁用(登录时)
    LockModelNone
};

//两个按钮
typedef NS_ENUM(NSInteger, FromVCType) {
    FromVCTypePush  = 100001, //push过来
    FromVCTypePresent         //present过来
};

@interface LockViewController : MainViewController

/** 手势类型 */
@property (nonatomic , assign)LockModel lockModel;
/** 跳转的方法--对应取消 */
@property (nonatomic, assign)FromVCType fromVCType;
/** title */
@property (nonatomic, copy) NSString *titleStr;

@end
