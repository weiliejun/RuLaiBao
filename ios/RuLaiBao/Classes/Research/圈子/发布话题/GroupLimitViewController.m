//
//  GroupLimitViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/12.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "GroupLimitViewController.h"
#import "Configure.h"

@interface GroupLimitViewController ()

@property (nonatomic, weak) UISwitch *switchLimit;

/** pop时是否返回block块 */
@property (nonatomic, assign) BOOL isBackClock;

@end

@implementation GroupLimitViewController

//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    if(self.isBackClock){
//        if (self.limitChangeBlock != nil) {
//            self.limitChangeBlock();
//        }
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置权限";
    self.view.backgroundColor = [UIColor customBackgroundColor];

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar + 10, Width_Window, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, bgView.width - 150, bgView.height)];
    label.text = @"加入圈子时需要验证";
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor customTitleColor];
    [bgView addSubview:label];
    
    UISwitch *switchLimit = [[UISwitch alloc]initWithFrame:CGRectMake(bgView.width-60, 7, 50, 36)];
    [switchLimit addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:switchLimit];
    
    _switchLimit = switchLimit;
    
    if ([self.auditStatus isEqualToString:@"yes"]) {
        switchLimit.on = YES;
    }else{
        switchLimit.on = NO;
    }
    
//    self.isBackClock = NO;
}
#pragma mark --按钮开关
- (void)pressSwitch:(UISwitch *)OpenSwitch{
    //已经变换了
    if (!OpenSwitch.isOn) {
        //打开状态下，点击是去关闭
        [self requestGroupTopicSetLimitData:@"no"];
    }else{
        //关闭状态下，点击是去打开
        [self requestGroupTopicSetLimitData:@"yes"];
    }
}
-(void)requestGroupTopicSetLimitData:(NSString *)auditStatus{
    [[RequestManager sharedInstance]postGroupTopicSetLimitWithUserID:[StoreTool getUserID] CircleId:self.circleID AuditStatus:auditStatus Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *TipDic = dict[@"data"];
            
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
//                self.isBackClock = YES;
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            } else {
                if ([auditStatus isEqualToString:@"yes"]) {
                    self.switchLimit.on = NO;
                }else{
                    self.switchLimit.on = YES;
                }
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }
        } else {
            if ([auditStatus isEqualToString:@"yes"]) {
                self.switchLimit.on = NO;
            }else{
                self.switchLimit.on = YES;
            }
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        if ([auditStatus isEqualToString:@"yes"]) {
            self.switchLimit.on = NO;
        }else{
            self.switchLimit.on = YES;
        }
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
