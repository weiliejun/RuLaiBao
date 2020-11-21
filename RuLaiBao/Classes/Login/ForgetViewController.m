//
//  ForgetViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/18.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "ForgetViewController.h"
#import "Configure.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "DES3Util.h"
#import "NSString+MD5.h"
#import "Utils.h"

#import <AFNetworking.h>

typedef NS_ENUM (NSInteger, MyTextFieldType) {
    MyTextFieldTypePwdOne = 10010, //第一个密码
    MyTextFieldTypePwdTwo          //第二个密码
};

typedef NS_ENUM (NSInteger, MyButtonType) {
    MyButtonTypeAuthcode = 10086, //验证码
    MyButtonTypeForget            //密码重置
};

static NSString *AfterPostSuccessPOP = @"popToVC";

@interface ForgetViewController ()<UITextFieldDelegate>

/** 手机号 */
@property (nonatomic, weak) UITextField *phoneTextF;
/** 验证码 */
@property (nonatomic, weak) UITextField *msgCodeTextF;
/** 新密码 */
@property (nonatomic, weak) UITextField *pwdTextF;
/** 确认密码 */
@property (nonatomic, weak) UITextField *pwdTwoTextF;
/** 密码重置 */
@property (nonatomic, weak) UIButton *forgetBtn;
/** 验证码 */
@property (nonatomic, weak) UIButton *getMsgBtn;

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 时间 */
@property (nonatomic, assign) NSInteger totalTime;
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"密码找回";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    
    //取消performSelector
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recordAotoStop) object:AfterPostSuccessPOP];
}
#pragma mark - 信息验证
- (BOOL)verificationResgisterUserInfo{
    if (!self.phoneTextF.text.length) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入手机号码!"];
        return NO;
    }
    if (![Utils validPhone:self.phoneTextF.text]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入正确的手机号!"];
        return NO;
    }
    if (!self.msgCodeTextF.text.length) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入验证码!"];
        return NO;
    }
    if (self.pwdTextF.text.length < 6 || self.pwdTextF.text.length > 16) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入6-16位数字字母组合密码!"];
        return NO;
    }
    if (![Utils validPassword:self.pwdTextF.text]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入6-16位数字字母组合密码!"];
        return NO;
    }
    if (self.pwdTwoTextF.text.length < 6 || self.pwdTwoTextF.text.length > 16) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入6-16位数字字母组合密码!"];
        return NO;
    }
    if (![Utils validPassword:self.pwdTwoTextF.text]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入6-16位数字字母组合密码!"];
        return NO;
    }
    if (![self.pwdTextF.text isEqualToString:self.pwdTwoTextF.text]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"两次输入的密码不一致!"];
        return NO;
    }
    return YES;
}
#pragma mark - 修改密码
-(void)loadForgetInfoRequest{
    if (![self verificationResgisterUserInfo]) {
        return;
    }
    WeakSelf
    [[RequestManager sharedInstance]postFindPasswordUserTelNum:self.phoneTextF.text ValidateCode:self.msgCodeTextF.text NewPassword:self.pwdTextF.text Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"密码修改成功！"];
                [strongSelf performSelector:@selector(recordAotoStop) withObject:AfterPostSuccessPOP afterDelay:2.0];
            } else {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}
-(void)recordAotoStop{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 发短信
-(void)loadAuthCodeRequest{
    if (![Utils validPhone:self.phoneTextF.text]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入正确的手机号码!"];
        return;
    }
    // 及时禁用掉按钮
    self.getMsgBtn.enabled = NO;
    WeakSelf
    [[RequestManager sharedInstance]postMobileVerificationCodeWithUserId:@"" Mobile:self.phoneTextF.text BusiType:@"loginRet" Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
                [strongSelf.getMsgBtn setTitleColor:[UIColor customTitleColor] forState:UIControlStateNormal];
                strongSelf.totalTime = 60;
                if (strongSelf.timer == nil) {
                    strongSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerDidChange) userInfo:nil repeats:YES];
                }
            }else{
                strongSelf.getMsgBtn.enabled = YES;
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}
#pragma mark - timer调用方法
- (void)timerDidChange {
    self.totalTime -= 1;
    [self.getMsgBtn setTitle:[NSString stringWithFormat:@"重新发送(%02zd)", self.totalTime] forState:UIControlStateNormal];
    if (self.totalTime == 0) {
        self.getMsgBtn.enabled = YES;
        [self.getMsgBtn setTitleColor:[UIColor customDeepYellowColor] forState:UIControlStateNormal];
        [self.getMsgBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - UI
-(void)createUI{
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window - Height_Statusbar_NavBar)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    adjustsScrollViewInsets_NO(scrollView, self);
    
    CGFloat pointHeight = 0;
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 10)];
    grayView.backgroundColor = [UIColor customBackgroundColor];
    [scrollView addSubview:grayView];
    
    //手机号
    pointHeight += 10;
    UITextField *phoneTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"手机号" placeholder:@"请输入注册的手机号"];
    phoneTextF.keyboardType = UIKeyboardTypeNumberPad;
    
    //验证码
    pointHeight +=60;
    UITextField *msgCodeTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"验证码" placeholder:@"请输入验证码"];
    msgCodeTextF.keyboardType = UIKeyboardTypeNumberPad;
    [self msgCodeTextFieldAddRightView:msgCodeTextF];
    
    //提示
    pointHeight +=50;
    UILabel *noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, pointHeight, Width_Window, 50)];
    noteLabel.text = @"      输入注册手机号收到的短信验证码";
    noteLabel.textColor = [UIColor customDetailColor];
    noteLabel.backgroundColor = [UIColor customBackgroundColor];
    noteLabel.font = [UIFont systemFontOfSize:17.0];
    [scrollView addSubview:noteLabel];
    
    //密码
    pointHeight +=60;
    UITextField *pwdTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"新密码" placeholder:@"(6-16位数字和字母组合)"];
    pwdTextF.secureTextEntry = YES;
    pwdTextF.clearsOnBeginEditing = YES;
    pwdTextF.tag = MyTextFieldTypePwdOne;
    pwdTextF.keyboardType = UIKeyboardTypeASCIICapable;
    [self pwdTextFieldAddRightView:pwdTextF];
    
    //密码2
    pointHeight +=60;
    UITextField *pwdTwoTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"确认密码" placeholder:@"(6-16位数字和字母组合)"];
    pwdTwoTextF.secureTextEntry = YES;
    pwdTwoTextF.clearsOnBeginEditing = YES;
    pwdTwoTextF.tag = MyTextFieldTypePwdTwo;
    pwdTwoTextF.keyboardType = UIKeyboardTypeASCIICapable;
    [self pwdTextFieldAddRightView:pwdTwoTextF];
    
    // 注册按钮
    pointHeight +=50;
    UIButton *forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(30, pointHeight + 50, Width_Window - 60, 44)];
    [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetButton setTitle:@"密码重置" forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.backgroundColor = [UIColor customDetailColor];
    forgetButton.enabled = NO;
    forgetButton.layer.cornerRadius = 22;
    forgetButton.layer.masksToBounds = NO;
    forgetButton.tag = MyButtonTypeForget;
    [scrollView addSubview:forgetButton];
    
    //添加底部imageView 放到scrollview下方
    CGFloat imageHeight = (Width_Window * 132)/375;
    UIImageView *bottomImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, Height_Window - imageHeight, Width_Window, imageHeight)];
    bottomImageV.image = [UIImage imageNamed:@"register_bg"];
    [self.view insertSubview:bottomImageV belowSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(Width_Window, forgetButton.bottom +30);
    
    _phoneTextF = phoneTextF;
    _msgCodeTextF = msgCodeTextF;
    _pwdTextF = pwdTextF;
    _pwdTwoTextF = pwdTwoTextF;
    _forgetBtn = forgetButton;
}

#pragma mark - 重置按钮的点击方法
- (void)buttonClick:(UIButton *)button {
    [self allTextFieldResignResponder];
    switch (button.tag) {
        case MyButtonTypeAuthcode: // 点击获取验证码
        {
            [self loadAuthCodeRequest];
        }
            break;
        case MyButtonTypeForget:  // 点击注册
            [self loadForgetInfoRequest];
            break;
    }
}

#pragma mark - 自定义输入区
-(UITextField *)createTextFieldWithFrame:(CGRect)frame BGScrollView:(UIView *)bgScrollView textFName:(NSString *)textFName placeholder:(NSString *)placeholder{
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview: bgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 85, bgView.height-1)];
    label.text = textFName;
    label.textColor = [UIColor customTitleColor];
    label.font = [UIFont systemFontOfSize:18];
    [bgView addSubview:label];
    
    UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(label.right, 0, bgView.width-label.right, bgView.height-1)];
    textfield.placeholder = placeholder;
    textfield.delegate = self;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.font = [UIFont systemFontOfSize:18.0];
    [bgView addSubview:textfield];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, textfield.height-24)];
    UIView *noteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, leftView.height)];
    noteView.backgroundColor = [UIColor customDeepYellowColor];
    [leftView addSubview:noteView];
    textfield.leftView = leftView;
    textfield.leftViewMode = UITextFieldViewModeWhileEditing;
    
    [textfield addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.height-1, bgView.width, 1)];
    lineView.backgroundColor = [UIColor customLineColor];
    [bgView addSubview:lineView];
    
    return textfield;
}

#pragma mark - txetF添加rightView
-(void)pwdTextFieldAddRightView:(UITextField *)textF{
    //密码右边的点击事件（显示密码的内容）
    UIButton *lookBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, textF.height)];
    [lookBtn setImage:[UIImage imageNamed:@"eyes_close"] forState:UIControlStateNormal];
    [lookBtn setImage:[UIImage imageNamed:@"eyes_open"] forState:UIControlStateSelected];
    lookBtn.tag = textF.tag;
    [lookBtn addTarget:self action:@selector(lookOrLockPwd:) forControlEvents:UIControlEventTouchUpInside];
    textF.rightView = lookBtn;
    textF.rightViewMode = UITextFieldViewModeAlways;
}
-(void)msgCodeTextFieldAddRightView:(UITextField *)textF{
    //密码右边的点击事件（显示密码的内容）
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 50)];
    textF.rightView = bgView;
    textF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, 2, 20)];
    lineView.backgroundColor = [UIColor customLineColor];
    [bgView addSubview:lineView];
    
    UIButton *getMsgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 118, textF.height)];
    [getMsgBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getMsgBtn setTitleColor:[UIColor customDeepYellowColor] forState:UIControlStateNormal];
    [getMsgBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    getMsgBtn.tag = MyButtonTypeAuthcode;
    [bgView addSubview:getMsgBtn];
    _getMsgBtn = getMsgBtn;
}

-(void)textFieldDidChange{
    if (self.phoneTextF.text.length && self.msgCodeTextF.text.length && self.pwdTextF.text.length && self.pwdTwoTextF.text.length ) {
        self.forgetBtn.enabled = YES;
        self.forgetBtn.backgroundColor = [UIColor customDeepYellowColor];
    } else {
        self.forgetBtn.enabled = NO;
        self.forgetBtn.backgroundColor = [UIColor customDetailColor];
    }
}
#pragma mark -- 密码的显示
-(void)lookOrLockPwd:(UIButton *)sender{
    //加密
    UITextField *textF = (UITextField *)[self.view viewWithTag:sender.tag];
    sender.selected = !sender.isSelected;
    textF.secureTextEntry = !sender.isSelected;;
    NSString *text = textF.text;
    textF.text = @" ";
    textF.text = text;
    if (textF.secureTextEntry){
        [textF insertText:textF.text];
    }
}
//实现代理<UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.pwdTextF && textField.secureTextEntry){
        [textField insertText:self.pwdTextF.text];
    }else if (textField == self.pwdTwoTextF && textField.secureTextEntry){
        [textField insertText:self.pwdTwoTextF.text];
    }
}
-(void)lockPwd:(UIButton *)sender{
    //加密
    
}
-(void)lookPwd:(UIButton *)sender{
    //解密
    UITextField *textF = (UITextField *)[self.view viewWithTag:sender.tag];
    textF.secureTextEntry = NO;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.phoneTextF.text = [self.phoneTextF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.msgCodeTextF.text = [self.msgCodeTextF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.pwdTextF.text = [self.pwdTextF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.pwdTwoTextF.text = [self.pwdTwoTextF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
}
-(void)allTextFieldResignResponder{
    [self.phoneTextF resignFirstResponder];
    [self.msgCodeTextF resignFirstResponder];
    [self.pwdTextF resignFirstResponder];
    [self.pwdTwoTextF resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
