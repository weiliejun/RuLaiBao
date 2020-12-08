//
//  RLBAlertViewController.m
//  RuLaiBao
//
//  Created by qiu on 2020/12/1.
//  Copyright © 2020 junde. All rights reserved.
//

#import "RLBAlertViewController.h"
#import "RLBAlertView.h"
#import "Configure.h"
#import "QLWKWebViewController.h"

@interface RLBAlertViewController ()

@end

@implementation RLBAlertViewController
- (instancetype)init{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[RLBAlertView AlertWith:@"服务协议及隐私政策" ConfirmBtn:@"同意，继续使用" CancelBtn:@"不同意" Msg:@"感谢您信任并使用如来保APP，依据最新法律要求，我们更新了会员服务协议、隐私政策。请您仔细阅读《如来保会员服务协议》和《隐私政策》，并确认了解我们对您的个人信息处理原则。\n\n如您同意《 如来保会员服务协议 》和《 隐私政策 》，请点击“同意”后使用我们的产品和服务，我们依法全力保护您的个人信息安全。" ResultBolck:^(NSInteger index, NSString *urlStr,NSString *titleStr) {
        if(index == 2 || index == 3){
            QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
            webVC.titleStr = titleStr;
            webVC.urlStr = urlStr;
            [self.navigationController pushViewController:webVC animated:YES];
        }else if(index == 1){
            // 点击了同意
            [StoreTool storeSerectStatus:YES];
            [self dismissViewControllerAnimated:NO completion:^{
                if (self.RLBAlertVCHide) {
                    self.RLBAlertVCHide();
                }
            }];
        }else{
            [self changeTitle];
        }
    }] show:self];
}
- (void)changeTitle{
    [[RLBAlertView AlertWith:@"温馨提示" ConfirmBtn:@"同意，并继续" CancelBtn:@"仍不同意，退出应用" Msg:@"我们非常重视对您个人信息的保护，承诺严格按照如来保隐私政策保护及处理您的信息。\n\n如不同意《 如来保会员服务协议 》和《 隐私政策 》，很遗憾我们将无法提供服务。" ResultBolck:^(NSInteger index, NSString *urlStr,NSString *titleStr) {
        if(index == 2 || index == 3){
            QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
            webVC.titleStr = titleStr;
            webVC.urlStr = urlStr;
            [self.navigationController pushViewController:webVC animated:YES];
        }else if(index == 1){
            // 点击了同意
            [StoreTool storeSerectStatus:YES];
            [self dismissViewControllerAnimated:NO completion:^{
                if (self.RLBAlertVCHide) {
                    self.RLBAlertVCHide();
                }
            }];
        }else{
            [StoreTool storeSerectStatus:NO];
            exit(0);
        }
    }] show:self];
}

@end
