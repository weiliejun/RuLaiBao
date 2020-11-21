//
//  AddBankCardViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/15.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "Configure.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ChangeNumber.h"
/** 选择开户行 */
#import "ChooseBankViewController.h"
/** 选择开户地 */
#import "ChooseAddressViewController.h"


@interface AddBankCardViewController ()<UIScrollViewDelegate, UITextFieldDelegate, ChooseBankDelegate, ChooseAddressDelegate>
@property (nonatomic, strong) UIScrollView *bgScrollView;
/** 真实姓名 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 身份证号 */
@property (nonatomic, strong) UILabel *IdNumberLabel;
// 选择开户银行
@property (nonatomic, strong) UIButton *openBankBtn;
/** 开户银行 */
@property (nonatomic, strong) UITextField *openBankField;
// 选择开户地
@property (nonatomic, strong) UIButton *openPlaceBtn;
/** 开户地 */
@property (nonatomic, strong) UITextField *openPlaceField;
/** 开户行名称 */
@property (nonatomic, strong) UITextField *bankNameField;
/** 银行帐号 */
@property (nonatomic, strong) UITextField *bankCardField;
/** 手机号 */
@property (nonatomic, strong) UILabel *phoneLabel;
/** 验证码 */
@property (nonatomic, strong) UITextField *codeField;
//获取验证码
@property (nonatomic, strong) UIButton *codeBtn;
/** 提示信息 */
@property (nonatomic, strong) UILabel *label;
/** 保存按钮 */
@property (nonatomic, strong) UIButton *saveBtn;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 时间 */
@property (nonatomic, assign) NSInteger totalTime;

/** 选择地址后的数组 */
@property (nonatomic, strong) NSArray *selectAddArr;


@end

@implementation AddBankCardViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //取消performSelector
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recordAotoStop) object:@"stopRecord"];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"新增银行卡";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createUI];
}

#pragma mark - 设置界面元素
- (void)createUI {
    TPKeyboardAvoidingScrollView *bgScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar+10, Width_Window, Height_Window-Height_Statusbar_NavBar-10)];
    bgScrollView.backgroundColor = [UIColor customBackgroundColor];
    bgScrollView.delegate = self;
    bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView = bgScrollView;
    [self.view addSubview:bgScrollView];
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(bgScrollView, self);
    
    // 真实姓名
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 50)];
    nameView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:nameView];
    UILabel *nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 20)];
    nameLabel1.text = @"真实姓名";
    nameLabel1.textColor = [UIColor customDetailColor];
    nameLabel1.textAlignment = NSTextAlignmentLeft;
    nameLabel1.font = [UIFont systemFontOfSize:16];
    [nameView addSubview:nameLabel1];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel1.right, 15, Width_Window-nameLabel1.right-10, 20)];
    nameLabel.text = [NSString stringWithFormat:@"%@",[StoreTool getRealname]];
    nameLabel.textColor = [UIColor customTitleColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel = nameLabel1;
    [nameView addSubview:nameLabel];
    
    // 身份证号
    UIView *IdNumberView = [[UIView alloc]initWithFrame:CGRectMake(0, nameView.bottom+1, Width_Window, 50)];
    IdNumberView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:IdNumberView];
    UILabel *IdNumberLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 20)];
    IdNumberLabel1.text = @"身份证号";
    IdNumberLabel1.textColor = [UIColor customDetailColor];
    IdNumberLabel1.textAlignment = NSTextAlignmentLeft;
    IdNumberLabel1.font = [UIFont systemFontOfSize:16];
    [IdNumberView addSubview:IdNumberLabel1];
    
    UILabel *IdNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(IdNumberLabel1.right, 15, Width_Window-IdNumberLabel1.right-10, 20)];
    IdNumberLabel.text = [NSString changeIDCard:[StoreTool getPresonCardID]];
    IdNumberLabel.textColor = [UIColor customTitleColor];
    IdNumberLabel.textAlignment = NSTextAlignmentRight;
    IdNumberLabel.font = [UIFont systemFontOfSize:16];
    self.IdNumberLabel = IdNumberLabel;
    [IdNumberView addSubview:IdNumberLabel];
    
    // 开户银行
    self.openBankField = [self createTextFWithRect:CGRectMake(0, IdNumberView.bottom+1, Width_Window, 50) TextTag:101 TextLeftLabelStr:@"开户银行" LeftLabelWidth:120 TextPlaceholderStr:@"请选择" BGScrollView:bgScrollView];
//    self.openBankField.enabled = YES;
    // 选择开户银行
    UIButton *openBankBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 50)];
    [openBankBtn addTarget:self action:@selector(openBankBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.openBankField addSubview:openBankBtn];
    self.openBankBtn = openBankBtn;
    
    // 开户地
    self.openPlaceField = [self createTextFWithRect:CGRectMake(0, self.openBankField.bottom+1, Width_Window, 50) TextTag:102 TextLeftLabelStr:@"开户地" LeftLabelWidth:120 TextPlaceholderStr:@"请选择" BGScrollView:bgScrollView];
//    self.openPlaceField.enabled = YES;
    // 选择开户地
    UIButton *openPlaceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 50)];
    [openPlaceBtn addTarget:self action:@selector(openPlaceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.openPlaceField addSubview:openPlaceBtn];
    self.openPlaceBtn = openPlaceBtn;
    
    // 开户行名称
    self.bankNameField = [self createTextFWithRect:CGRectMake(0, self.openPlaceField.bottom+1, Width_Window, 50) TextTag:103 TextLeftLabelStr:@"开户行名称" LeftLabelWidth:120 TextPlaceholderStr:@"请输入开户行名称" BGScrollView:bgScrollView];
//    self.bankNameField.enabled = YES;
    self.bankNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // 银行帐号
    self.bankCardField = [self createTextFWithRect:CGRectMake(0, self.bankNameField.bottom+1, Width_Window, 50) TextTag:104 TextLeftLabelStr:@"银行帐号" LeftLabelWidth:120 TextPlaceholderStr:@"请输入银行帐号" BGScrollView:bgScrollView];
//    self.bankCardField.enabled = YES;
    
    // 手机号
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bankCardField.bottom+1, Width_Window, 50)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:phoneView];
    UILabel *phoneLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 20)];
    phoneLabel1.text = @"手机号";
    phoneLabel1.textColor = [UIColor customDetailColor];
    phoneLabel1.textAlignment = NSTextAlignmentLeft;
    phoneLabel1.font = [UIFont systemFontOfSize:16];
    [phoneView addSubview:phoneLabel1];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel1.right, 15, Width_Window-nameLabel1.right-10, 20)];
    phoneLabel.text = [NSString changePhoneNum:[StoreTool getPhone]];
    phoneLabel.textColor = [UIColor customTitleColor];
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.font = [UIFont systemFontOfSize:16];
    self.phoneLabel = phoneLabel;
    [phoneView addSubview:phoneLabel];
    
    // 验证码
    UIView *codeView = [[UIView alloc]initWithFrame:CGRectMake(0, phoneView.bottom+1, Width_Window, 50)];
    codeView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:codeView];
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 20)];
    codeLabel.text = @"验证码";
    codeLabel.textColor = [UIColor customDetailColor];
    codeLabel.textAlignment = NSTextAlignmentLeft;
    codeLabel.font = [UIFont systemFontOfSize:16];
    [codeView addSubview:codeLabel];
    
    UITextField *codeText = [[UITextField alloc]initWithFrame:CGRectMake(Width_Window-240, 10, 100, 30)];
    codeText.backgroundColor = [UIColor customBackgroundColor];
    codeText.textColor = [UIColor customTitleColor];
    codeText.textAlignment = NSTextAlignmentCenter;
    codeText.font = [UIFont systemFontOfSize:13];
    codeText.tag = 105;
    codeText.delegate = self;
    codeText.placeholder = @"请输入验证码";
    codeText.keyboardType = UIKeyboardTypeNumberPad;
    [codeView addSubview:codeText];
    self.codeField = codeText;
    //获取验证码
    UIButton *codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window-130, 10, 120, 30)];
    codeBtn.backgroundColor = [UIColor colorWithRed:165/255.0 green:208/255.0 blue:255/255.0 alpha:1.0];
    [codeBtn setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    codeBtn.layer.masksToBounds = YES;
    codeBtn.layer.cornerRadius = 5;
    [codeBtn addTarget:self action:@selector(codeNum:) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:codeBtn];
    self.codeBtn = codeBtn;
    
    // 提示信息
    UILabel *warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, codeView.bottom+10, Width_Window-20, 20)];
    warnLabel.text = @"注：保存以后银行卡信息不可修改！";
    warnLabel.textColor = [UIColor customDetailColor];
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.font = [UIFont systemFontOfSize:16];
    [bgScrollView addSubview:warnLabel];
    self.label = warnLabel;
    
    // 保存按钮
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, warnLabel.bottom+100, Width_Window-20, 44)];
    saveBtn.backgroundColor = [UIColor customLightYellowColor];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 20;
    [saveBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:saveBtn];
    self.saveBtn = saveBtn;
    
    //设置bgScrollView的contentSize
    bgScrollView.contentSize = CGSizeMake(Width_Window, saveBtn.bottom+10);
    
}

#pragma mark - 选择开户银行
- (void)openBankBtnClick:(UIButton *)btn {
    [self.view endEditing:YES];
    
    ChooseBankViewController *chooseVC =[[ChooseBankViewController alloc]init];
    self.definesPresentationContext = YES; //self is presenting view controller
    chooseVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    chooseVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    chooseVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    chooseVC.delegate = self;
    [self presentViewController:chooseVC animated:YES completion:nil];
}

#pragma mark  - 选择开户银行代理方法返回值
- (void)ChooseBankViewController:(ChooseBankViewController *)viewController didPassValueWithStr:(NSString *)str {
    self.openBankField.text = str;
}

#pragma mark - 选择开户地
- (void)openPlaceBtnClick:(UIButton *)btn {
    [self.view endEditing:YES];
    
    ChooseAddressViewController *chooseVC =[[ChooseAddressViewController alloc]init];
    self.definesPresentationContext = YES; //self is presenting view controller
    chooseVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    chooseVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    chooseVC.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    chooseVC.delegate = self;
    [self presentViewController:chooseVC animated:YES completion:nil];
}

#pragma mark - 选择开户地代理方法返回值
- (void)viewController:(ChooseAddressViewController *)viewController didPassingAddWithStr:(NSArray *)infoArr {
    self.selectAddArr = infoArr;
    self.openPlaceField.text = infoArr[2];
}

#pragma mark - 获取验证码
- (void)codeNum:(UIButton *)btn {
    if (![Utils validPhone:[StoreTool getPhone]]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入正确的手机号码!"];
        return;
    }
    // 及时禁用掉按钮
    [self.view endEditing:YES];
    self.codeBtn.enabled = NO;
    WeakSelf
    [[RequestManager sharedInstance]postMobileVerificationCodeWithUserId:[StoreTool getUserID] Mobile:[StoreTool getPhone] BusiType:@"bankCardBind" Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:strongSelf.view WithTitle:TipDic[@"message"]];
                strongSelf.codeBtn.backgroundColor = [UIColor lightGrayColor];
                strongSelf.totalTime = 60;
                if (strongSelf.timer == nil) {
                    strongSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerDidChange) userInfo:nil repeats:YES];
                }
            } else {
                strongSelf.codeBtn.enabled = YES;
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
    [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送(%02zd)", self.totalTime] forState:UIControlStateNormal];
    if (self.totalTime == 0) {
        self.codeBtn.enabled = YES;
        self.codeBtn.backgroundColor = [UIColor colorWithRed:165/255.0 green:208/255.0 blue:255/255.0 alpha:1.0];
        [self.codeBtn setTitle:@"点击获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - 保存按钮
- (void)saveBtn:(UIButton *)btn {
    if (!self.openBankField.text.length) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请选择开户银行"];
        return;
    }else if (!self.openPlaceField.text.length) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请选择开户地"];
        return;
    }else if (!self.bankNameField.text.length) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入开户行名称"];
        return;
    }else if (!self.bankCardField.text.length) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入银行账号"];
        return;
    }else if (![Utils isBankCard:self.bankCardField.text]){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入正确的银行账号"];
        return;
    }else if (!self.codeField.text.length) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入短信验证码"];
        return;
    }else {
        //反应期间禁止点击
        self.saveBtn.userInteractionEnabled = NO;
        self.codeBtn.userInteractionEnabled = NO;
        self.openPlaceBtn.userInteractionEnabled = NO;
        self.openBankBtn.userInteractionEnabled = NO;
        [self.view endEditing:YES];
        self.openBankField.enabled = NO;
        self.openPlaceField.enabled = NO;
        self.bankNameField.enabled = NO;
        self.bankCardField.enabled = NO;
        self.codeField.enabled = NO;
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确定保存新银行卡吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *certifyAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            //保存
            [self requestAddBankData];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:certifyAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

#pragma mark - 请求新增银行卡数据
- (void)requestAddBankData {
    NSString *bankCardStr = [self bankNumberToNormalNumberWithTextField:self.bankCardField];
    
    [[RequestManager sharedInstance]postAddBankCardWithBank:self.openBankField.text bankAddress:self.openPlaceField.text bankcardNo:bankCardStr bankName:self.bankNameField.text idNo:[StoreTool getPresonCardID] mobile:[StoreTool getPhone] realName:[StoreTool getRealname] userId:[StoreTool getUserID] validateCode:self.codeField.text Success:^(id responseData) {
        
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                //反应期间禁止点击
                self.saveBtn.userInteractionEnabled = NO;
                self.codeBtn.userInteractionEnabled = NO;
                self.openPlaceBtn.userInteractionEnabled = NO;
                self.openBankBtn.userInteractionEnabled = NO;
                [self.view endEditing:YES];
                self.openBankField.enabled = NO;
                self.openPlaceField.enabled = NO;
                self.bankNameField.enabled = NO;
                self.bankCardField.enabled = NO;
                self.codeField.enabled = NO;
                
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
                
               //提交成功 延时1秒（返回银行卡页面）
                [self performSelector:@selector(recordAotoStop) withObject:@"stopRecord" afterDelay:1.0];
                
            }else {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
                
                self.saveBtn.userInteractionEnabled = YES;
                self.codeBtn.userInteractionEnabled = YES;
                self.openPlaceBtn.userInteractionEnabled = YES;
                self.openBankBtn.userInteractionEnabled = YES;
                [self.view endEditing:NO];
                self.openBankField.enabled = YES;
                self.openPlaceField.enabled = YES;
                self.bankNameField.enabled = YES;
                self.bankCardField.enabled = YES;
                self.codeField.enabled = YES;
            }
            
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
            
            self.saveBtn.userInteractionEnabled = YES;
            self.codeBtn.userInteractionEnabled = YES;
            self.openPlaceBtn.userInteractionEnabled = YES;
            self.openBankBtn.userInteractionEnabled = YES;
            [self.view endEditing:NO];
            self.openBankField.enabled = YES;
            self.openPlaceField.enabled = YES;
            self.bankNameField.enabled = YES;
            self.bankCardField.enabled = YES;
            self.codeField.enabled = YES;

        }
        
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        
        self.saveBtn.userInteractionEnabled = YES;
        self.codeBtn.userInteractionEnabled = YES;
        self.openPlaceBtn.userInteractionEnabled = YES;
        self.openBankBtn.userInteractionEnabled = YES;
        [self.view endEditing:NO];
        self.openBankField.enabled = YES;
        self.openPlaceField.enabled = YES;
        self.bankNameField.enabled = YES;
        self.bankCardField.enabled = YES;
        self.codeField.enabled = YES;

    }];
}

//延时1秒（返回银行卡页面）
- (void)recordAotoStop{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建textfield
-(UITextField *)createTextFWithRect:(CGRect)textRect TextTag:(NSInteger)textTag TextLeftLabelStr:(NSString *)textLeftLabelStr LeftLabelWidth:(CGFloat)leftLabelWidth TextPlaceholderStr:(NSString *)textPlaceholderStr BGScrollView:(UIView *)bgScrollView{
    
    UITextField *textF = [[UITextField alloc]initWithFrame:textRect];
    textF.backgroundColor = [UIColor whiteColor];
    textF.textColor = [UIColor customTitleColor];
    textF.font = [UIFont systemFontOfSize:16];
    textF.delegate = self;
    textF.tag = textTag;
    textF.placeholder = textPlaceholderStr;
    textF.textAlignment = NSTextAlignmentRight;
    
    //设置水印颜色
    [textF setValue:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
        if (textTag == 104) {
            textF.keyboardType = UIKeyboardTypeNumberPad;
        }
    
    UILabel *leftLabel= [[UILabel alloc]init];
    leftLabel.frame = CGRectMake(10, 0, leftLabelWidth, textRect.size.height);
    leftLabel.font = [UIFont systemFontOfSize:16];
    leftLabel.textColor = [UIColor customDetailColor];
    leftLabel.text = [NSString stringWithFormat:@"  %@",textLeftLabelStr];
    textF.leftView = leftLabel;
    textF.leftViewMode = UITextFieldViewModeAlways;
    
    if (textTag == 101 || textTag == 102) {
        //添加右箭头
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(textRect.size.width-20, 20, 20, 20)];
        UIImageView *jianimageV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 2.5, 10, 15)];
        jianimageV.image = [UIImage imageNamed:@"arrow_r"];
        [bgview addSubview:jianimageV];
        textF.rightView = bgview;
        textF.rightViewMode = UITextFieldViewModeAlways;
        
    }else{
        UILabel *rightLabel= [[UILabel alloc]initWithFrame:CGRectMake(textRect.size.width-10, 0, 10, textRect.size.height)];
        textF.rightView = rightLabel;
        textF.rightViewMode = UITextFieldViewModeUnlessEditing;
    }
    
    //事件监听
    [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [bgScrollView addSubview:textF];
    return textF;
}

#pragma mark - UITextField 限制50个字符
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length > 50) {
        textField.text = [textField.text substringToIndex:50];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"最大允许输入50个字符!"];
    }
}

#pragma mark - 银行卡每四位加一个空格
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     if (textField.tag == 104) {
         // 银行卡号 四位加一个空格
         if (textField == self.bankCardField) {
             if ([string isEqualToString:@""]) { // 删除字符
                 if ((textField.text.length - 2) % 5 == 0) {
                     textField.text = [textField.text substringToIndex:textField.text.length - 1];
                 }
                 return YES;
             } else {
                 if (textField.text.length % 5 == 0) {
                     textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
                 }
             }
             return YES;
         }
     }
    
    return YES;
}

/** 去掉银行卡号的空格 */
-(NSString *)bankNumberToNormalNumberWithTextField:(UITextField *)textF{
    return [textF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.openBankField endEditing:YES];
    [self.openPlaceField endEditing:YES];
    [self.bankCardField endEditing:YES];
    [self.bankNameField endEditing:YES];
    [self.codeField endEditing:YES];
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    NSLog(@"这里返回为NO。则为禁止编辑");
//    return NO;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
