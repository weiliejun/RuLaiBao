//
//  LockViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/11.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "LockViewController.h"
#import "LockView.h"
#import "Configure.h"

@interface LockViewController ()<QLLockViewDelegate>
/** 主解锁view */
@property (strong, nonatomic)  LockView *lockView;

/** 返回按钮 */
@property (strong,nonatomic) UIButton *backBtn;

/** 用户名 */
@property (strong, nonatomic)  UILabel *nameLabel;

/** 提示信息 */
@property (strong, nonatomic)  UILabel *noteLabel;

/** 重新设置 */
@property (nonatomic, strong) UIButton *resetBtn;

/** 忘记手势密码 */
@property (nonatomic, strong) UIButton *forgetBtn;

/** 其他账号 */
@property (nonatomic, strong) UIButton *otherUserBtn;

/** 第几次输入 */
@property (nonatomic) NSInteger setNum;

/**用于验证输入次数*/
@property (nonatomic) NSInteger fiveT;

/** 暂时存放密码 */
@property (nonatomic, copy) NSString *interimPwdStr;

@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customView];
    self.setNum = 1;
}

//重写back
-(void)popBackClick{
    if (self.fromVCType == FromVCTypePresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 创建view
-(void)customView{
    if(self.fromVCType == FromVCTypePresent){
        self.navigationItem.leftBarButtonItem = nil;
        self.fiveT = 0;
    }
    
    
    UILabel *noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar + 30, Width_Window, 20)];
    noteLabel.text = DEFAULT_STRING;
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.textColor = [UIColor darkGrayColor];
    noteLabel.font = [UIFont systemFontOfSize:17];
    self.noteLabel = noteLabel;
    [self.view addSubview:noteLabel];
    
    self.lockView = [[LockView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar + 80, Width_Window, Width_Window-74)];
    self.lockView.delegate = self;
    self.lockView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.lockView];
    
    if(self.lockModel == LockModelUnLock){
        self.forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window/2-110-40, self.lockView.frame.origin.y+self.lockView.frame.size.height+30, 110, 30)];
        [self.forgetBtn setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        self.forgetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.forgetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.forgetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.forgetBtn.tag = 10001;
        [self.view addSubview:self.forgetBtn];
        
        self.otherUserBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window/2+40, self.lockView.frame.origin.y+self.lockView.frame.size.height+30, 110, 30)];
        [self.otherUserBtn setTitle:@"用其他账号登录" forState:UIControlStateNormal];
        self.otherUserBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.otherUserBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.otherUserBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.otherUserBtn.tag = 10003;
        [self.view addSubview:self.otherUserBtn];
    }else{
        if(self.lockModel == LockModelChange){
            noteLabel.text = DEFAULT_OLD_STRING;
        }
        self.resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window/2-55, self.lockView.frame.origin.y+self.lockView.frame.size.height+30, 110, 30)];
        if(self.lockModel == LockModelOpen){
            [self.resetBtn setTitle:@"重新设置手势" forState:UIControlStateNormal];
            self.resetBtn.hidden = YES;
        }else{
            [self.resetBtn setTitle:@"忘记手势密码？" forState:UIControlStateNormal];
            self.resetBtn.hidden = NO;
        }
        self.resetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.resetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.resetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.resetBtn.tag = 10002;
        [self.view addSubview:self.resetBtn];
    }
}
/** 按钮的点击事件 */
-(void)btnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 10001:{
            //打开app时的验证--忘记手势密码,验证登录密码后，重新设置
            [self createAlertVCForLostLockCode:FORGET_PSW_STRING];
        }
            break;
        case 10002:{
            if(self.lockModel == LockModelOpen){
                //重新设置
                self.resetBtn.hidden = YES;
                self.setNum = 1;
                self.noteLabel.text = DEFAULT_STRING;
            }else if (self.lockModel == LockModelChange){
                if (self.setNum == 1) {
                    //忘记密码
                    //一般跳到验证页
                    [self createAlertVCForLostLockCode:FORGET_PSW_STRING];
                }else{
                    //重新设置
                    self.resetBtn.hidden = YES;
                    self.setNum = 2;
                    self.noteLabel.text = DEFAULT_STRING;
                }
            }else if (self.lockModel == LockModelClose){
                [self createAlertVCForLostLockCode:FORGET_PSW_STRING];
            }
        }
            break;
        case 10003:{
            //其他账号登录
            //等同于解锁失败，退出登录状态，跳到登录页
            [self UserLostLockCodeForReLoad];

        }
            break;
            
        default:
            break;
    }
}
/** lockview返回的代理方法 */
-(void)LockViewDidClick:(LockView *)lockView andPwd:(NSString *)pwd{
    NSLog(@"密码=%@,长度>>>%lu",pwd,(unsigned long)pwd.length);
    if (pwd.length <= 3) {
        self.noteLabel.text = PSW_WRONG_NUMSTRING;
        return;
    }
    if (self.lockModel == LockModelOpen) {
        if (self.setNum ==1) {
            self.interimPwdStr = pwd;
            self.setNum = 2;
            self.noteLabel.text = INPUT_AGAIN_STRING;
            self.resetBtn.hidden = NO;
            return;
        }
        if (self.setNum ==2) {
            if ([self.interimPwdStr isEqualToString:pwd]) {
                [StoreTool storeHandpwd:pwd];
                //弹出对话框
                [self createSetOK4AlertVCStr:@"手势密码已打开"];
            }else{
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:PSW_TWICE_WRONG_STRING];
                self.noteLabel.text = INPUT_AGAIN_STRING;
                self.setNum = 2;
            }
            return;
        }
    }else if (self.lockModel == LockModelChange){
        if (self.setNum == 1) {
            if ([[StoreTool getHandpwd] isEqualToString:pwd]) {
                self.setNum = 2;
                self.resetBtn.hidden = YES;
                self.noteLabel.text = DEFAULT_STRING;
            }else{
                self.noteLabel.text = PSWFAILTSTRING;
            }
            return;
        }else if (self.setNum == 2){
            self.interimPwdStr = pwd;
            self.setNum = 3;
            self.noteLabel.text = INPUT_AGAIN_STRING;
            [self.resetBtn setTitle:@"重新设置手势" forState:UIControlStateNormal];
            self.resetBtn.hidden = NO;
            return;
        }else if (self.setNum ==3) {
            if ([self.interimPwdStr isEqualToString:pwd]) {
                [StoreTool storeHandpwd:pwd];
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"修改成功"];

                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:PSW_TWICE_WRONG_STRING];

                self.noteLabel.text = INPUT_AGAIN_STRING;
                self.setNum = 3;
            }
            return;
        }
    }else if (self.lockModel == LockModelUnLock){
        if ([[StoreTool getHandpwd] isEqualToString:pwd]) {
            //解锁成功
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            if (0 == self.fiveT) {
                self.fiveT = 1;
                self.noteLabel.text = [NSString stringWithFormat:@"密码错误，您还可以尝试%zd次",5-self.fiveT];
            }else if(4 == _fiveT){
                //退出登录，清空一切
                [self createAlertVCForLockCodeError:@"手势密码绘制错误，将退出登录"];
            }else{
                self.fiveT++;
                self.noteLabel.text = [NSString stringWithFormat:@"您还可以绘制%zd次",5-self.fiveT];
            }
        }
    }else if (self.lockModel == LockModelClose){
        if ([[StoreTool getHandpwd] isEqualToString:pwd]) {
            //解锁成功
            [StoreTool storeHandpwd:@""];
            [self createSetOK4AlertVCStr:@"手势密码已关闭"];
        }else{
            self.noteLabel.text = PSWFAILTSTRING;
        }
    }
}


-(void)createSetOK4AlertVCStr:(NSString *)messageStr{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:cancelction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)createAlertVCForLostLockCode:(NSString *)messageStr{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *cancelction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self UserLostLockCodeForReLoad];
    }];
    [cancelction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    [alertVC addAction:cancelction];
    [alertVC addAction:cancelction1];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

//输入五次错误
-(void)createAlertVCForLockCodeError:(NSString *)messageStr{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self UserLostLockCodeForReLoad];
    }];
    [alertVC addAction:cancelction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark -- 退出登录
-(void)UserLostLockCodeForReLoad{
    //解锁失败，退出登录状态，跳到登录页
    [[RequestManager sharedInstance]postLogoffWithUserId:[StoreTool getUserID] Success:^(id responseData) {
        
    } Error:^(NSError *error) {
        
    }];
    
    //退出登录状态，跳到登录页
    // 清空用户数据信息
    [StoreTool storeLoginStates:NO];
    [StoreTool storeUserID:@""];
    [StoreTool storePhone:@""];
    [StoreTool storeRealname:@""];
    [StoreTool storeCheckStatus:@""];
    [StoreTool storeHandpwd:@""];

    // 发送退出登录的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationHandPsw object:nil];
    
    if (self.fromVCType == FromVCTypePresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
