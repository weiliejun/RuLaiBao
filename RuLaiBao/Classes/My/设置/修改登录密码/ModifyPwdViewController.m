//
//  ModifyPwdViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/11.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "ModifyPwdViewController.h"
#import "Configure.h"
#import "TPKeyboardAvoidingScrollView.h"


@interface ModifyPwdViewController ()<UITextFieldDelegate>
/** 旧密码 */
@property (nonatomic, weak) UITextField *pwdOldTextF;
/** 新密码 */
@property (nonatomic, weak) UITextField *pwdTextF;
/** 确认密码 */
@property (nonatomic, weak) UITextField *pwdTwoTextF;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *certainBtn;

@end

@implementation ModifyPwdViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //取消performSelector
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recordAotoStop) object:@"stopRecord"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

#pragma mark -- 创建UI
-(void)createUI{
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window - Height_Statusbar_NavBar)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    adjustsScrollViewInsets_NO(scrollView, self);
    
    CGFloat pointHeight = 0;
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 10)];
    grayView.backgroundColor = [UIColor customBackgroundColor];
    [scrollView addSubview:grayView];
    
    /** 旧密码 */
    pointHeight += 10;
    UITextField *pwdOldTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"旧密码" placeholder:@"请输入原始密码"];
    pwdOldTextF.secureTextEntry = YES;
    pwdOldTextF.clearsOnBeginEditing = YES;
    pwdOldTextF.tag = 1000;
    pwdOldTextF.keyboardType = UIKeyboardTypeASCIICapable;
    [self pwdTextFieldAddRightView:pwdOldTextF];
    self.pwdOldTextF = pwdOldTextF;
    
    //新密码
    pointHeight +=60;
    UITextField *pwdTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"新密码" placeholder:@"(6-16位数字和字母组合)"];
    pwdTextF.secureTextEntry = YES;
    pwdTextF.clearsOnBeginEditing = YES;
    pwdTextF.tag = 2000;
    pwdTextF.keyboardType = UIKeyboardTypeASCIICapable;
    [self pwdTextFieldAddRightView:pwdTextF];
    self.pwdTextF = pwdTextF;
    
    //确认密码
    pointHeight +=60;
    UITextField *pwdTwoTextF = [self createTextFieldWithFrame:CGRectMake(20, pointHeight, Width_Window - 40, 50) BGScrollView:scrollView textFName:@"确认密码" placeholder:@"(6-16位数字和字母组合)"];
    pwdTwoTextF.secureTextEntry = YES;
    pwdTwoTextF.clearsOnBeginEditing = YES;
    pwdTwoTextF.tag = 3000;
    pwdTwoTextF.keyboardType = UIKeyboardTypeASCIICapable;
    [self pwdTextFieldAddRightView:pwdTwoTextF];
    self.pwdTwoTextF = pwdTwoTextF;
    
    //确定按钮
    pointHeight +=50;
    UIButton *certainBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, pointHeight + 50, Width_Window - 60, 44)];
    [certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [certainBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    certainBtn.backgroundColor = [UIColor customDetailColor];
    certainBtn.enabled = NO;
    certainBtn.layer.cornerRadius = 20;
    certainBtn.layer.masksToBounds = NO;
    certainBtn.tag = 4000;
    [scrollView addSubview:certainBtn];
    self.certainBtn = certainBtn;
    
    //添加底部imageView 放到scrollview下方
    CGFloat imageHeight = (Width_Window * 132)/375;
    UIImageView *bottomImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, Height_Window - imageHeight, Width_Window, imageHeight)];
    bottomImageV.image = [UIImage imageNamed:@"register_bg"];
    [self.view insertSubview:bottomImageV belowSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(Width_Window, certainBtn.bottom +30);
}

//确定按钮点击事件
- (void)buttonClick:(UIButton *)btn{
    if (!self.pwdOldTextF.text.length) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入原始密码"];
        return ;
    }else if (self.pwdTextF.text.length < 6 || self.pwdTextF.text.length > 16) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入6-16位数字字母组合密码!"];
        return ;
    }else if (![Utils validPassword:self.pwdTextF.text]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入6-16位数字字母组合密码!"];
        return ;
    }else if (self.pwdTwoTextF.text.length < 6 || self.pwdTwoTextF.text.length > 16) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入6-16位数字字母组合密码!"];
        return ;
    }else if (![Utils validPassword:self.pwdTwoTextF.text]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入6-16位数字字母组合密码!"];
        return ;
    }else if (![self.pwdTextF.text isEqualToString:self.pwdTwoTextF.text]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"两次输入的密码不一致!"];
        return ;
    }else {
        
        [self requestPwdModifyWithUserId:[StoreTool getUserID] OldPassword:self.pwdOldTextF.text NewPassword:self.pwdTextF.text];
    }
}

#pragma mark -- 请求修改登录密码数据
-(void)requestPwdModifyWithUserId:(NSString *)userId OldPassword:(NSString *)oldPassword NewPassword:(NSString *)newPassword {
    self.certainBtn.userInteractionEnabled = NO;
    [[RequestManager sharedInstance]postModifyPwdWithNewPassword:newPassword password:oldPassword UserId:userId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                self.certainBtn.userInteractionEnabled = NO;
                
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"密码修改成功！"];
                //提交成功 延时1秒（返回产品详情页面）
                [self performSelector:@selector(recordAotoStop) withObject:@"stopRecord" afterDelay:1.0];
            } else {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
                self.certainBtn.userInteractionEnabled = YES;
            }
        } else {
            self.certainBtn.userInteractionEnabled = YES;
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
        
    } Error:^(NSError *error) {
        self.certainBtn.userInteractionEnabled = YES;
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

//延时1秒（返回产品详情页面）
- (void)recordAotoStop{
    [self LoginOutToReloadLogin];
}

#pragma mark -- 重新登录
-(void)LoginOutToReloadLogin{
    //请求退出登录接口，清除数据
    [[RequestManager sharedInstance]postLogoffWithUserId:[StoreTool getUserID] Success:^(id responseData) {
        
    } Error:^(NSError *error) {
        
    }];
    // 清空用户数据信息
    [StoreTool storeLoginStates:NO];
    [StoreTool storeUserID:@""];
    [StoreTool storePhone:@""];
    [StoreTool storeRealname:@""];
    [StoreTool storeCheckStatus:@""];
    [StoreTool storeHandpwd:@""];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationLogOff object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
}

-(void)textFieldDidChange{
    if (self.pwdOldTextF.text.length && self.pwdTextF.text.length && self.pwdTwoTextF.text.length) {
        self.certainBtn.enabled = YES;
        self.certainBtn.backgroundColor = [UIColor customDeepYellowColor];
    } else {
        self.certainBtn.enabled = NO;
        self.certainBtn.backgroundColor = [UIColor customDetailColor];
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
    if (textField == self.pwdOldTextF && textField.secureTextEntry){
        [textField insertText:self.pwdOldTextF.text];
    }else if (textField == self.pwdTextF && textField.secureTextEntry){
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
    self.pwdOldTextF.text = [self.pwdOldTextF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.pwdTextF.text = [self.pwdTextF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.pwdTwoTextF.text = [self.pwdTwoTextF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(void)allTextFieldResignResponder{
    [self.pwdOldTextF resignFirstResponder];
    [self.pwdTextF resignFirstResponder];
    [self.pwdTwoTextF resignFirstResponder];
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
