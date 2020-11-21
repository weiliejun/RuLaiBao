//
//  RegisterViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/18.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "RegisterViewController.h"
#import "Configure.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "NSString+Custom.h"

//协议
#import "PopWebViewController.h"
#import "UIViewController+ENPopUp.h"
#import "RegisterChooseCityController.h"

typedef NS_ENUM (NSInteger, MyButtonType) {
    MyButtonTypeAuthcode = 10086, //验证码
    MyButtonTypeAgree,            //同意
    MyButtonTypeProtocal,         //协议
    MyButtonTypeRegister          //注册
};

static NSInteger MAX_STARWORDS_LENGTH = 10;
static NSString *AfterPostSuccessPOP = @"popToVC";

@interface RegisterViewController ()<UITextFieldDelegate,ChooseCityDelegate>

@property (nonatomic, weak) UITextField *phoneTextF;
@property (nonatomic, weak) UITextField *msgCodeTextF;
@property (nonatomic, weak) UITextField *pwdTextF;
@property (nonatomic, weak) UITextField *realNameTextF;
/** 省市 */
@property (nonatomic, weak) UILabel *homeSelectLabel;
@property (nonatomic, weak) UITextField *recommendCodeTextF;
@property (nonatomic, weak) UIButton *agreeButton;
@property (nonatomic, weak) UIButton *registerBtn;
@property (nonatomic, weak) UIButton *getMsgBtn;

/** 选择的省市 英文 */
@property (nonatomic, weak) NSString *selectAreaStr;

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 时间 */
@property (nonatomic, assign) NSInteger totalTime;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.selectAreaStr = @"";
    
    [self createUI];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    
    //取消performSelector
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recordAotoStop) object:AfterPostSuccessPOP];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 注册信息基本验证
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
    if (!self.realNameTextF.text) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入真实姓名!"];
        return NO;
    }
    if (!self.selectAreaStr.length) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请选择所在省/市!"];
        return NO;
    }
    return YES;
}
#pragma mark - 提交注册
- (void)loadRegisterInfoRequest {
    if (![self verificationResgisterUserInfo]) {
        return;
    }
    WeakSelf
    [[RequestManager sharedInstance] postRegisterUserTelNum:self.phoneTextF.text ValidateCode:self.msgCodeTextF.text UserPwd:self.pwdTextF.text RealName:self.realNameTextF.text Area:self.selectAreaStr ParentRecommendCode:self.recommendCodeTextF.text Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                //提交成功 延时2秒（返回产品详情页面）
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
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

#pragma mark - 获取验证码的网络请求
- (void)loadAuthCodeRequest {
    if (![Utils validPhone:self.phoneTextF.text]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入正确的手机号码!"];
        return;
    }
    // 及时禁用掉按钮
    self.getMsgBtn.enabled = NO;
    WeakSelf
    [[RequestManager sharedInstance]postMobileVerificationCodeWithUserId:@"" Mobile:self.phoneTextF.text BusiType:@"register" Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:strongSelf.view WithTitle:TipDic[@"message"]];
                [strongSelf.getMsgBtn setTitleColor:[UIColor customTitleColor] forState:UIControlStateNormal];
                strongSelf.totalTime = 60;
                if (strongSelf.timer == nil) {
                    strongSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerDidChange) userInfo:nil repeats:YES];
                }
            } else {
                strongSelf.getMsgBtn.enabled = YES;
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }
        } else {
            self.getMsgBtn.enabled = YES;
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        self.getMsgBtn.enabled = YES;
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
    UITextField *phoneTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"手机号" placeholder:@"请输入手机号"];
    phoneTextF.keyboardType = UIKeyboardTypeNumberPad;
    
    //验证码
    pointHeight +=60;
    UITextField *msgCodeTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"验证码" placeholder:@"请输入验证码"];
    msgCodeTextF.keyboardType = UIKeyboardTypeNumberPad;
    [self msgCodeTextFieldAddRightView:msgCodeTextF];
    
    //密码
    pointHeight +=60;
    UITextField *pwdTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"密码" placeholder:@"(6-16位数字和字母组合)"];
    pwdTextF.secureTextEntry = YES;
    pwdTextF.clearsOnBeginEditing = YES;
    pwdTextF.keyboardType = UIKeyboardTypeASCIICapable;
    [self pwdTextFieldAddRightView:pwdTextF];
    
    //真实姓名
    pointHeight +=60;
    UITextField *realNameTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"真实姓名" placeholder:@"请输入姓名"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:realNameTextF];
    
    //选择省市
    pointHeight +=60;
    UIControl *controlHome = [[UIControl alloc]initWithFrame:CGRectMake(0, pointHeight, Width_Window, 50)];
    [controlHome addTarget:self action:@selector(controlHomeClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:controlHome];
    
    UILabel *controlLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 85, 49)];
    controlLabel.textAlignment = NSTextAlignmentLeft;
    controlLabel.font = [UIFont systemFontOfSize:18];
    controlLabel.textColor = [UIColor customTitleColor];
    controlLabel.text = @"所在省/市";
    [controlHome addSubview:controlLabel];
    
    UIImageView *jianimageV =[[UIImageView alloc]initWithFrame:CGRectMake(Width_Window-20-17, 17, 10, 15)];
    jianimageV.image = [UIImage imageNamed:@"arrow_r"];
    [controlHome addSubview:jianimageV];
    
    UILabel *homeSelectLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlLabel.right, 0, Width_Window-controlLabel.right-42, 49)];
    homeSelectLabel.textAlignment = NSTextAlignmentRight;
    homeSelectLabel.font = [UIFont systemFontOfSize:18];
    homeSelectLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    homeSelectLabel.text = @"请选择";
    [controlHome addSubview:homeSelectLabel];
    
    UIView *controlLineView = [[UIView alloc]initWithFrame:CGRectMake(20, controlHome.height-1, controlHome.width-40, 1)];
    controlLineView.backgroundColor = [UIColor customLineColor];
    [controlHome addSubview:controlLineView];
    
    
    //推荐码
    pointHeight +=60;
    UITextField *recommendCodeTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"推荐码" placeholder:@"请输入推荐码"];
    
    pointHeight +=60;
    // 复选框按钮
    UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(15, pointHeight + 12, 16, 16)];
    [agreeButton setBackgroundImage:[UIImage imageNamed:@"choose_normal"] forState:UIControlStateNormal];
    [agreeButton setBackgroundImage:[UIImage imageNamed:@"choose_select"] forState:UIControlStateSelected];
    [agreeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    agreeButton.tag = MyButtonTypeAgree;
    agreeButton.selected = YES;
    [scrollView addSubview:agreeButton];
    
    UILabel *protocalLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(agreeButton.right + 5, pointHeight + 10, 95, 20)];
    protocalLeftLabel.font = [UIFont systemFontOfSize:13.0];
    protocalLeftLabel.text = @"我已阅读并同意";
    protocalLeftLabel.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:protocalLeftLabel];
    
    // 协议按钮
    UIButton *protocalButton = [[UIButton alloc] initWithFrame:CGRectMake(protocalLeftLabel.right, pointHeight + 10, 70, 20)];
    [protocalButton setTitle:@"《如来保》" forState:UIControlStateNormal];
    [protocalButton setTitleColor:[UIColor customDeepYellowColor] forState:UIControlStateNormal];
    protocalButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [protocalButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    protocalButton.tag = MyButtonTypeProtocal;
    [scrollView addSubview:protocalButton];
    
    UILabel *protocalRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(protocalButton.right, pointHeight + 10, 55, 20)];
    protocalRightLabel.font = [UIFont systemFontOfSize:13.0];
    protocalRightLabel.text = @"服务协议";
    protocalRightLabel.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:protocalRightLabel];

    // 注册按钮
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(30, agreeButton.bottom + 50, Width_Window - 60, 44)];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.backgroundColor = [UIColor customDetailColor];
    registerButton.enabled = NO;
    registerButton.layer.cornerRadius = 22;
    registerButton.layer.masksToBounds = NO;
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
    _msgCodeTextF = msgCodeTextF;
    _pwdTextF = pwdTextF;
    _realNameTextF = realNameTextF;
    _homeSelectLabel = homeSelectLabel;
    _recommendCodeTextF = recommendCodeTextF;
    _agreeButton = agreeButton;
    _registerBtn = registerButton;
}
#pragma mark - 注册按钮的点击方法
- (void)buttonClick:(UIButton *)button {
    [self allTextFieldResignResponder];
    switch (button.tag) {
        case MyButtonTypeAuthcode: // 点击获取验证码
        {
            [self loadAuthCodeRequest];
        }
            break;
        case MyButtonTypeAgree:  // 点击同意协议
        {
            self.agreeButton.selected = !self.agreeButton.selected;
            [self textFieldDidChange];
        }
            break;
        case MyButtonTypeProtocal: // 点击进入协议
        {
            PopWebViewController *vc = [[PopWebViewController alloc]init];
            vc.view.frame = CGRectMake(0, 0, Width_Window, Height_Window-114);
            [self presentPopUpViewController:vc];
            [vc popInfoUrlstr:[NSString stringWithFormat:@"%@://%@/register/agreement",webHttp,RequestHeader]];
        }
            break;
        case MyButtonTypeRegister:  // 点击注册
            [self loadRegisterInfoRequest];
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
    
    _getMsgBtn= getMsgBtn;
}

-(void)textFieldDidChange{
    if (self.agreeButton.selected && self.phoneTextF.text.length && self.msgCodeTextF.text.length && self.pwdTextF.text.length && self.realNameTextF.text.length ) {
        
        self.registerBtn.enabled = YES;
        self.registerBtn.backgroundColor = [UIColor customDeepYellowColor];
    } else {
        self.registerBtn.enabled = NO;
        self.registerBtn.backgroundColor = [UIColor customDetailColor];
    }
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

#pragma mark - Notification Method
-(void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position){
        if (toBeString.length > MAX_STARWORDS_LENGTH){
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1){
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}
#pragma mark --限制textfield的条件
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([NSString isNineKeyBoard:string] || ![NSString hasEmoji:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
        return YES;
    } else {
        return NO;
    }
}

-(void)allTextFieldResignResponder{
    [self.phoneTextF resignFirstResponder];
    [self.msgCodeTextF resignFirstResponder];
    [self.pwdTextF resignFirstResponder];
    [self.realNameTextF resignFirstResponder];
    [self.recommendCodeTextF resignFirstResponder];
}

#pragma mark - 选择省市
- (void)controlHomeClick{
    [self.view endEditing:YES];
    
    //选择省市
    RegisterChooseCityController *chooseVC =[[RegisterChooseCityController alloc]init];
    self.definesPresentationContext = YES;
    chooseVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    chooseVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    chooseVC.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    chooseVC.chooseDelegate =self;
    [self.navigationController presentViewController:chooseVC animated:YES completion:nil];
}
//delegate
-(void)viewController:(RegisterChooseCityController *)viewController didChooseCityWithStr:(NSArray *)infoArr{
    
    self.selectAreaStr = [NSString stringWithFormat:@"%@",infoArr[1]];
    self.homeSelectLabel.text = [NSString stringWithFormat:@"%@",infoArr[2]];
    self.homeSelectLabel.textAlignment = NSTextAlignmentLeft;
    self.homeSelectLabel.textColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
