//
//  LoginViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/18.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "LoginViewController.h"
#import "Configure.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "WRNavigationBar.h"

#import "RegisterViewController.h"
#import "ForgetViewController.h"

typedef NS_ENUM (NSInteger, MyButtonType) {
    MyButtonTypeLogin = 10086,
    MyButtonTypeForget,
    MyButtonTypeRegister,
};

@interface LoginViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
/** 电话号码 */
@property (nonatomic, weak) UITextField *phoneTextF;
/** 密码 */
@property (nonatomic, weak) UITextField *pwdTextF;
/** 登录按钮 */
@property (nonatomic, weak) UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self wr_setNavBarTitleColor:[UIColor clearColor]];
    [self wr_setNavBarBackgroundAlpha:0];
    
    [self createUI];
    [self setupNavBackButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self wr_setNavBarShadowImageHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self wr_setNavBarShadowImageHidden:NO];
    /** 此处是为了解决WRNavigationBar 崩溃的bug*/
    [[NSNotificationCenter defaultCenter] removeObserver:self.navigationController.navigationBar name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.navigationController.navigationBar name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 点击事件
-(void)buttonClick:(UIButton *)sender{
    [self.view endEditing:YES];
    switch (sender.tag) {
        case MyButtonTypeLogin:{
            [self postLoginDataRequest];
        }
            break;
        case MyButtonTypeForget:{
            ForgetViewController *forgetVC = [[ForgetViewController alloc]init];
            [self.navigationController pushViewController:forgetVC animated:YES];
        }
            break;
        case MyButtonTypeRegister:{
            RegisterViewController *registerVC = [[RegisterViewController alloc]init];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 验证
-(BOOL)verificationLoginUserInfo{
    if (self.phoneTextF.text.length == 0) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"手机号不能为空!"];
        return NO;
    }else if (![Utils validPhone:self.phoneTextF.text]){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"手机号码格式错误"];
        return NO;
    }
    return YES;
}
#pragma mark - 登录
-(void)postLoginDataRequest{
    if (![self verificationLoginUserInfo]) {
        return;
    }
    WeakSelf
    [[RequestManager sharedInstance]postLoginUserTelNum:self.phoneTextF.text UserPwd:self.pwdTextF.text Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                // 存储返回信息
                [StoreTool storeLoginStates:YES];
                [StoreTool storeUserID:TipDic[@"userId"]];
                [StoreTool storePhone:TipDic[@"mobile"]];
                [StoreTool storeRealname:TipDic[@"realName"]];
                [StoreTool storeCheckStatus:TipDic[@"checkStatus"]];
                [strongSelf backClick];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationLoginSuccess object:nil];
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

#pragma mark - 设置UI
- (void)createUI {
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, Width_Window, Height_Window)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    adjustsScrollViewInsets_NO(scrollView, self);
    
    // 顶部图片
    UIImageView *topImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    topImageView.center = CGPointMake(Width_Window / 2, 100 + Height_Statusbar_NavBar);
    topImageView.image = [UIImage imageNamed:@"login_logo"];
    [scrollView addSubview:topImageView];
    
    // 说明文字
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"道德  专业  平等  利他";
    descLabel.font = [UIFont systemFontOfSize:18.0f];
    descLabel.textColor = [UIColor customTitleColor];
    descLabel.numberOfLines = 0;
    [descLabel sizeToFit];
    descLabel.center = CGPointMake(Width_Window / 2, topImageView.bottom + 25);
    [scrollView addSubview:descLabel];
    
    CGFloat pointHeight = descLabel.bottom + 50;
    UITextField *phoneTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"手机号" placeholder:@"请输入手机号" textFSecure:NO];
    phoneTextF.keyboardType = UIKeyboardTypeNumberPad;
    pointHeight += 50;
    UITextField *pwdTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight + 10, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"密码" placeholder:@"请输入密码" textFSecure:YES];
    pwdTextF.keyboardType = UIKeyboardTypeASCIICapable;
    pointHeight += 50;
    
    // 登录按钮
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(30, pointHeight + 50, Width_Window - 60, 44)];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.backgroundColor = [UIColor customDetailColor];
    loginButton.enabled = NO;
    loginButton.layer.cornerRadius = 22;
    loginButton.layer.masksToBounds = NO;
    loginButton.tag = MyButtonTypeLogin;
    [scrollView addSubview:loginButton];
    
    // 忘记密码按钮
    UIButton *forgetPwdButton = [[UIButton alloc] initWithFrame:CGRectMake(30, loginButton.bottom + 10, 90, 30)];
    [forgetPwdButton setTitleColor:[UIColor customDeepYellowColor] forState:UIControlStateNormal];
    forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [forgetPwdButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPwdButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    forgetPwdButton.tag = MyButtonTypeForget;
    [scrollView addSubview:forgetPwdButton];
    
    // 注册
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(Width_Window - 80, loginButton.bottom + 10, 50, 30)];
    [registerButton setTitleColor:[UIColor customTitleColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.tag = MyButtonTypeRegister;
    [scrollView addSubview:registerButton];
    
    //添加底部imageView 放到scrollview下方
    CGFloat imageHeight = (Width_Window * 132)/375;
    UIImageView *bottomImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, Height_Window - imageHeight, Width_Window, imageHeight)];
    bottomImageV.image = [UIImage imageNamed:@"register_bg"];
    [self.view insertSubview:bottomImageV belowSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(Width_Window, registerButton.bottom +30);
    // 属性记录
    _phoneTextF = phoneTextF;
    _pwdTextF = pwdTextF;
    _loginButton = loginButton;
    
}
-(void)textFieldDidChange:(UITextField *)sender{
    if (self.phoneTextF.text.length && self.pwdTextF.text.length) {
        self.loginButton.enabled = YES;
        self.loginButton.backgroundColor = [UIColor customDeepYellowColor];
    } else {
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = [UIColor customDetailColor];
    }
}

#pragma mark - 自定义输入区
-(UITextField *)createTextFieldWithFrame:(CGRect)frame BGScrollView:(UIView *)bgScrollView textFName:(NSString *)textFName placeholder:(NSString *)placeholder textFSecure:(BOOL)isSecure{
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview: bgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, bgView.height-1)];
    label.text = textFName;
    label.textColor = [UIColor customTitleColor];
    label.font = [UIFont systemFontOfSize:18];
    [bgView addSubview:label];
    
    UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(label.right, 0, bgView.width-label.right, bgView.height-1)];
    textfield.placeholder = placeholder;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.font = [UIFont systemFontOfSize:18.0];
    textfield.delegate = self;
    [bgView addSubview:textfield];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, textfield.height-24)];
    UIView *noteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, leftView.height)];
    noteView.backgroundColor = [UIColor customDeepYellowColor];
    [leftView addSubview:noteView];
    
    textfield.leftView = leftView;
    textfield.leftViewMode = UITextFieldViewModeWhileEditing;
    
    if (isSecure) {
        textfield.secureTextEntry = YES;
        //密码右边的点击事件（显示密码的内容）
        UIButton *lookBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, textfield.height)];
        [lookBtn setImage:[UIImage imageNamed:@"eyes_close"] forState:UIControlStateNormal];
        [lookBtn setImage:[UIImage imageNamed:@"eyes_open"] forState:UIControlStateSelected];
        [lookBtn addTarget:self action:@selector(lookOrLockPwd:) forControlEvents:UIControlEventTouchUpInside];
        textfield.rightView = lookBtn;
        textfield.rightViewMode = UITextFieldViewModeAlways;
    }
    
    [textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.height-1, bgView.width, 1)];
    lineView.backgroundColor = [UIColor customLineColor];
    [bgView addSubview:lineView];
    
    return textfield;
}
#pragma mark -- 密码的显示
-(void)lookOrLockPwd:(UIButton *)sender{
    //加密
    sender.selected = !sender.isSelected;
    self.pwdTextF.secureTextEntry = !sender.isSelected;;
    NSString *text = self.pwdTextF.text;
    self.pwdTextF.text = @" ";
    self.pwdTextF.text = text;
    if (self.pwdTextF.secureTextEntry){
        [self.pwdTextF insertText:self.pwdTextF.text];
    }
}
//实现代理<UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.pwdTextF){
        if (textField.secureTextEntry){
            [textField insertText:self.pwdTextF.text];
        }
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger textLength = 0;
    if(textField == self.phoneTextF){
        textLength = 11;
    }else{
        textLength = 16;
    }
    if (range.location >= textLength){
        return  NO;
    }else{
        return YES;
    }
}

#pragma mark - 设置左侧返回按钮
/** 当present出来的时候需要返回 */
- (void)setupNavBackButton {
    
    if (self.type == LogInAppearTypePresent) {
        // 添加一个返回按钮
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void)backClick {
    if (self.type == LogInAppearTypePresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
