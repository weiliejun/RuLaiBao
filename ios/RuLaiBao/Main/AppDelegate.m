//
//  AppDelegate.m
//  RuLaiBao
//
//  Created by qiu on 2018/3/26.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "WRNavigationBar.h"
#import "Configure.h"
//手势密码
#import "LockViewController.h"
#import "RLBCheckVersionTool.h"

//ShareSDK
//#define APPShare_KEY @"18ab92fd67e3c"

//ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"

#import "OpenUrlHandleTool.h"


@interface AppDelegate ()<UITabBarControllerDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    self.mainTabBarController = [[MainTabBarController alloc]init];
    _window.rootViewController = self.mainTabBarController;
    
    self.mainTabBarController.delegate = self;
    [self setNavBarAppearence];
    
    /**
     ShareSDK
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [self shareSDK];
    
    return YES;
}

- (void)setNavBarAppearence
{
    // 设置是 广泛使用WRNavigationBar，还是局部使用WRNavigationBar，目前默认是广泛使用
    [WRNavigationBar wr_widely];
    [WRNavigationBar wr_setBlacklist:@[@"TZImagePickerController",
                                       @"TZPhotoPickerController",
                                       @"TZGifPhotoPreviewController",
                                       @"TZAlbumPickerController",
                                       @"TZPhotoPreviewController",
                                       @"TZVideoPlayerController"]];
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor whiteColor]];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor customNavBarColor]];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor customNavBarColor]];
    // 统一设置状态栏样式
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleDefault];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:NO];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if ([StoreTool getLoginStates] && [StoreTool getHandpwd].length!=0) {
        LockViewController *lockVC = [[LockViewController alloc]init];
        lockVC.lockModel = LockModelUnLock;
        lockVC.fromVCType = FromVCTypePresent;
        lockVC.titleStr = @"解锁";
        MainTabBarController *mainTabBarC =  (MainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        lockVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [mainTabBarC presentViewController:lockVC animated:NO completion:nil];
    }
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //手势密码与版本提示不共存
    if (!([StoreTool getLoginStates] && [StoreTool getHandpwd].length!=0)) {
        //提示有新版本
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [RLBCheckVersionTool checkApplicationVersionWithAppID:@"1387421032"];
        });
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//强制使用系统键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
    if ([extensionPointIdentifier isEqualToString:UIApplicationKeyboardExtensionPointIdentifier]) {
        return NO;
    }
    return YES;
}
#pragma mark - 处理openUrl
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [OpenUrlHandleTool jumpControllerWithRemoteURL:url];
    NSLog(@"%d",[WXApi handleOpenURL:url delegate:self]);
    return [WXApi handleOpenURL:url delegate:self];
    //    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    [OpenUrlHandleTool jumpControllerWithRemoteURL:url];
    NSLog(@"%d",[WXApi handleOpenURL:url delegate:self]);
    return [WXApi handleOpenURL:url delegate:self];
    //    return YES;
}

#pragma mark - UITabBarController代理方法
/*!
 实现点击tabbar刷新UI
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    //当tabBar被点击时发出一个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationTabBarDidSelected object:nil userInfo:nil];
}

#pragma mark - 分享
- (void)shareSDK {
    NSArray *shareArr =  @[ @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformSubTypeQZone),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeQQFriend)
                            ];
    [ShareSDK registerActivePlatforms:shareArr onImport:^(SSDKPlatformType platformType) {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class]
                           tencentOAuthClass:[TencentOAuth class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx04c51cddfc11bccd" appSecret:@"96f9a4b36790edbd403080e0c16c7968"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1106879880"
                                     appKey:@"rVjNmSeRie8VEV4c"
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}




@end
