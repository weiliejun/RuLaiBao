//
//  JumpToSellCertifyVCTool.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/16.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "JumpToSellCertifyVCTool.h"
#import "SellCertifyViewController.h"
@implementation JumpToSellCertifyVCTool
+(void)jumpToSellCertifyVCWithFatherViewController:(UIViewController *)viewController{
    //已登录未认证时提示：请通过认证后在进行该操作！   取消/去认证
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请通过认证后再进行该操作！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *certifyAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //跳转销售认证页面
        SellCertifyViewController *sellVC = [[SellCertifyViewController alloc]init];
        [viewController.navigationController pushViewController:sellVC animated:YES];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:certifyAction];
    [viewController presentViewController:alertVC animated:YES completion:nil];
    
}
@end
