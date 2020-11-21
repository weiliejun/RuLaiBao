//
//  GuaranteeAddViewController.m
//  RuLaiBao
//
//  Created by qiu on 2019/5/16.
//  Copyright © 2019 junde. All rights reserved.
//

#import "GuaranteeAddViewController.h"
#import "Configure.h"
#import "TPKeyboardAvoidingScrollView.h"


@interface GuaranteeAddViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *idNoTextField;

@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation GuaranteeAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新增保单";
    self.view.backgroundColor = [UIColor customLineColor];
    
    [self createUI];
}

#pragma mark - 验证
-(BOOL)verificationLoginUserInfo{
    if (self.nameTextField.text.length == 0) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"投保人不能为空!"];
        return NO;
    }
    if (self.idNoTextField.text.length == 0) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"投保编号不能为空!"];
        return NO;
    }
    return YES;
}
#pragma mark - 登录
-(void)submitButtonClick{
    if (![self verificationLoginUserInfo]) {
        return;
    }
    self.submitButton.enabled = NO;
    WeakSelf
    [[RequestManager sharedInstance]postGuaranteeAddUserId:[StoreTool getUserID] PolicyHolder:self.nameTextField.text OrderCode:self.idNoTextField.text Success:^(id responseData) {
        self.submitButton.enabled = YES;
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:strongSelf.view WithTitle:TipDic[@"message"]];
                [strongSelf.navigationController popViewControllerAnimated:YES];
                
            } else {
                [QLMBProgressHUD showPromptViewInView:strongSelf.view WithTitle:TipDic[@"message"]];
            }
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        self.submitButton.enabled = YES;
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - createUI
- (void)createUI{
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window - Height_Statusbar_NavBar)];
    scrollView.backgroundColor = [UIColor clearColor];
//    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    adjustsScrollViewInsets_NO(scrollView, self);
    
    UITextField *nameTextField = [self createTextFieldWithFrame:CGRectMake(0, 10, Width_Window, 50) BGScrollView:scrollView textFName:@"投保人" placeholder:@"请输入投保人"];
    
    UITextField *idNoTextField = [self createTextFieldWithFrame:CGRectMake(0, 60, Width_Window, 50) BGScrollView:scrollView textFName:@"投保单号" placeholder:@"请输入投保单号"];
//    idNoTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    // 登录按钮
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 140, Width_Window - 60, 44)];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    submitButton.backgroundColor = [UIColor customDetailColor];
    submitButton.enabled = NO;
    submitButton.layer.cornerRadius = 22;
    submitButton.layer.masksToBounds = NO;
    [scrollView addSubview:submitButton];
    
    _nameTextField = nameTextField;
    _idNoTextField = idNoTextField;
    _submitButton = submitButton;
}

-(void)textFieldDidChange:(UITextField *)sender{
    if (self.nameTextField.text.length && self.idNoTextField.text.length) {
        self.submitButton.enabled = YES;
        self.submitButton.backgroundColor = [UIColor customDeepYellowColor];
    } else {
        self.submitButton.enabled = NO;
        self.submitButton.backgroundColor = [UIColor customDetailColor];
    }
}

#pragma mark - 自定义输入区
-(UITextField *)createTextFieldWithFrame:(CGRect)frame BGScrollView:(UIView *)bgScrollView textFName:(NSString *)textFName placeholder:(NSString *)placeholder{
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview: bgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, bgView.height-1)];
    label.text = textFName;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor customTitleColor];
    label.font = [UIFont systemFontOfSize:16.0];
    [bgView addSubview:label];
    
    UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(label.right, 0, bgView.width-label.right, bgView.height-1)];
    textfield.placeholder = placeholder;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.font = [UIFont systemFontOfSize:16.0];
    textfield.delegate = self;
    [bgView addSubview:textfield];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, textfield.height-24)];
    UIView *noteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, leftView.height)];
    noteView.backgroundColor = [UIColor customDeepYellowColor];
    [leftView addSubview:noteView];
    
    textfield.leftView = leftView;
    textfield.leftViewMode = UITextFieldViewModeWhileEditing;
    
    [textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.height-1, bgView.width, 1)];
    lineView.backgroundColor = [UIColor customLineColor];
    [bgView addSubview:lineView];
    
    return textfield;
}
@end
