//
//  MainTabBarController.m
//  RuLaiBao
//
//  Created by qiu on 2018/3/26.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "Configure.h"
/** home */
#import "HomeViewController.h"
/** 研修 */
#import "ResearchViewController.h"
/** 规划 */
#import "PlanViewController.h"
/** 我的*/
#import "MyViewController.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
//    [self setValue:[[MainRLBTabBar alloc]init] forKey:@"tabBar"];
    [self addChildViewControllers];
    
    // 注册从解锁手势密码页退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutFromHandPswNotification:) name:KNotificationHandPsw object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark  从手势密码页解锁的时候退出登录
- (void)logOutFromHandPswNotification:(NSNotification *)n {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LoginViewController *logInVC = [LoginViewController new];
        logInVC.type = LogInAppearTypePresent;
        MainNavigationController *logInNav = [[MainNavigationController alloc] initWithRootViewController:logInVC];
        logInNav.modalPresentationStyle = UIModalPresentationFullScreen;
        if (self.selectedIndex == 3) {
            self.selectedIndex = 0;
        }
        MainNavigationController *rootNav =  self.viewControllers[self.selectedIndex];
        [rootNav presentViewController:logInNav animated:NO completion:nil];
    });
}

#pragma mark - 添加子控制器
- (void)addChildViewControllers {
    self.tabBar.tintColor = [UIColor customDeepYellowColor];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.backgroundImage = [UIImage new];
    self.tabBar.shadowImage = [UIImage new];
//    self.tabBar.translucent = NO;
    
    //添加阴影
    self.tabBar.layer.shadowColor = [UIColor customDeepYellowColor].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -3);
    self.tabBar.layer.shadowOpacity = 0.3;
    
    
    NSMutableArray *arrayM = [NSMutableArray array];
    [arrayM addObject:[self viewControllerWithClassName:@"HomeViewController" title:@"首页" imageName:@"Home"]];
    [arrayM addObject:[self viewControllerWithClassName:@"ResearchViewController" title:@"研修" imageName:@"Research"]];
    [arrayM addObject:[self viewControllerWithClassName:@"PlanViewController" title:@"规划" imageName:@"Plan"]];
    [arrayM addObject:[self viewControllerWithClassName:@"MyViewController" title:@"我的" imageName:@"My"]];
    self.viewControllers = arrayM.copy;
}

- (UIViewController *)viewControllerWithClassName:(NSString *)clsName title:(NSString *)title imageName:(NSString *)imageName {
    
    Class cls = NSClassFromString(clsName);
    NSAssert(cls != nil, @"传入了类名字符串错误");
    UIViewController *vc = [cls new];
    UIImage *nolmalImage = [UIImage imageNamed:[imageName stringByAppendingString:@"_normal"]];
    UIImage *originalNolmalImage = [nolmalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage = [UIImage imageNamed:[imageName stringByAppendingString:@"_sel"]];
    UIImage *originalSelectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *accountTab = [[UITabBarItem alloc] initWithTitle:title image:originalNolmalImage selectedImage:originalSelectedImage];
    vc.tabBarItem = accountTab;
    vc.title = title;
    
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:vc];
    
    return  nav;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
