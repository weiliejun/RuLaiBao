//
//  AppConfig.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/24.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>


//宽和高
#define Width_Window [UIScreen mainScreen].bounds.size.width
#define Height_Window [UIScreen mainScreen].bounds.size.height
/** 状态栏高度 */
#define Height_Statusbar [[UIApplication sharedApplication] statusBarFrame].size.height
/** 开启热点后的增加的高度 */
#define Height_Statusbar_HotSpot ((Height_Statusbar == 40) ? (20):(0))

/** 底部home Bar的高度 */
#define IS_IPHONEX ({\
BOOL isiPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
UIWindow *window = [UIApplication sharedApplication].delegate.window;\
if (window.safeAreaInsets.bottom > 0.0) {\
isiPhoneX = YES;\
}\
}\
isiPhoneX;\
})
#define Height_View_HomeBar (IS_IPHONEX ? (34):(0))
#define Height_Statusbar_NavBar (IS_IPHONEX ? (88):(64))
/**安全域 总高度 - 状态栏 - 底部home Bar*/
#define Height_View_SafeArea ({Height_Window - Height_Statusbar-Height_View_HomeBar;})

/* scrollview适配 */
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)

#define SystemVersionAfter9 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)?YES:NO)

/** 标题font大小 18px */
UIKIT_EXTERN CGFloat const KFontTitleSize;
/** 内容font大小 16px */
UIKIT_EXTERN CGFloat const KFontDetailSize;
/** 时间，类型font大小 14px */
UIKIT_EXTERN CGFloat const KFontTimeSize;
/** 其他font大小 12px */
UIKIT_EXTERN CGFloat const KFontOtherSize;

FOUNDATION_EXTERN NSString *const KNotificationLoginSuccess;
FOUNDATION_EXTERN NSString *const KNotificationLogOff;
// 从解锁手势密码页退出登录
FOUNDATION_EXTERN NSString *const KNotificationHandPsw;

FOUNDATION_EXTERN NSString *const KNotificationTabBarDidSelected;

/*!
 对删除做出响应
 */
FOUNDATION_EXTERN NSString *const KNotificationDataRemoved;
FOUNDATION_EXTERN NSString *const KNotificationTopicDataRemoved;

/** 问题删除提示 */
FOUNDATION_EXTERN NSString *const KDetailPostDataRequestIng;
FOUNDATION_EXTERN NSString *const KCourseDetailDataRemoved;
FOUNDATION_EXTERN NSString *const KQuestionDetailDataRemoved;
/** 回答删除提示 */
FOUNDATION_EXTERN NSString *const KAnswerDetailDataRemoved;
/** 圈子删除 */
FOUNDATION_EXTERN NSString *const KGroupDetailDataRemoved;
/** 话题删除提示 */
FOUNDATION_EXTERN NSString *const KGroupTopicDetailDataRemoved;

/** 产品下架提示 */
FOUNDATION_EXTERN NSString *const KInsuranceDetailDataDown;
/** 产品删除提示 */
FOUNDATION_EXTERN NSString *const KInsuranceDetailDataRemoved;
/** 产品不存在提示 */
FOUNDATION_EXTERN NSString *const KInsuranceDetailDataNonExist;







