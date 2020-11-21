//
//  LockHeader.h
//  LockViewDemo
//
//  Created by qiu on 2017/6/26.
//  Copyright © 2017年 QiuFairy. All rights reserved.
//

#ifndef LockHeader_h
#define LockHeader_h
#import "Configure.h"

#endif /* LockHeader_h */


/******************* ITEM *********************/

#define ITEMRADIUS_OUTTER    70  //item的外圆直径
#define ITEMRADIUS_INNER     20  //item的内圆直径
#define ITEMRADIUS_LINEWIDTH 1   //item的线宽
#define ITEMWH               70  //item的宽高
#define ITEM_TOTAL_POSITION  250  // 整个item的顶点位置



/*********************** 颜色 *************************/

//背景色   深蓝色
#define BACKGROUNDCOLOR [UIColor whiteColor]

//选中颜色  浅蓝色
#define SELECTCOLOR [UIColor orangeColor]

//圆心颜色  浅灰色
#define ROUNDCENTERCTCOLOR [UIColor customDeepYellowColor]

//选错的颜色  红色
#define WRONGCOLOR [UIColor colorWithRed:1 green:0 blue:0 alpha:1]

//文字错误提示颜色   浅红色
#define LABELWRONGCOLOR [UIColor colorWithRed:0.94 green:0.31 blue:0.36 alpha:1]




#define KscreenHeight [UIScreen mainScreen].bounds.size.height
#define KscreenWidth [UIScreen mainScreen].bounds.size.width



/*********************** 文字提示语 *************************/
#define DEFAULT_STRING          @"绘制解锁图案"
#define DEFAULT_OLD_STRING     @"绘制旧解锁图案"
#define INPUT_AGAIN_STRING     @"请再次绘制手势密码"
#define PSW_TWICE_WRONG_STRING @"两次密码绘制不一致，请重新绘制"
#define PSWSUCCESSSTRING       @"设置密码成功"
#define PSWFAILTSTRING         @"密码图案绘制错误"
#define PSW_WRONG_NUMSTRING    @"最少连接4个点,请重新绘制"
#define FORGET_PSW_STRING      @"忘记手势密码，需要重新登录，并设置手势密码"
