//
//  MainViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/3/26.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain  target:self action:@selector(itemPopBack)];
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
    // 接收状态栏高度发生变化的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(adjustStatusBar) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}
// 热点被接入，子类重写
- (void)adjustStatusBar{
    
}
//搜索childViewControllerForStatusBarStyle
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

-(void)itemPopBack{
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if(self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

