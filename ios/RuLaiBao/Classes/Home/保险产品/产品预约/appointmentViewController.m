//
//  appointmentViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/4.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "appointmentViewController.h"
#include "Configure.h"
/** 带有键盘功能的ScrollView */
#import "TPKeyboardAvoidingScrollView.h"
/** 时间选择器 */
#import "ChooseDateViewController.h"
/** 无数据处理页 */
#import "RLBDetailNoDataTipView.h"



@interface appointmentViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,ChooseDateDelegate>
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *bgScrollView;
/** 姓名 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 电话 */
@property (nonatomic, strong) UILabel *phoneLabel;
/** 保险公司 */
@property (nonatomic, strong) UILabel *companyLabel;
/** 保险计划 */
@property (nonatomic, strong) UITextField *planField;
/** 保险金额 */
@property (nonatomic, strong) UITextField *moneyField;
/** 年缴保费 */
@property (nonatomic, strong) UITextField *yearFeeField;
/** 保险期限 */
@property (nonatomic, strong) UITextField *timeLimitField;
/** 缴费期限 */
@property (nonatomic, strong) UITextField *feeLimitField;
/** 预计交单时间 */
@property (nonatomic, strong) UITextField *anticipateTimeField;
/** 备注说明 */
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label;
/** 提交预约按钮 */
@property (nonatomic, strong) UIButton *noteBtn;

@property (nonatomic, weak) RLBDetailNoDataTipView *noDetailTipView;
/** 产品详情页数据 */
@property (nonatomic, strong) NSDictionary *infoDict;


@end

@implementation appointmentViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //取消performSelector
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recordAotoStop) object:@"stopRecord"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"产品预约";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self appointmentRequestData];
    //请求页
    [self createInsuranceDetailNoDataView];
}

//先请求产品详情页数据
- (void)appointmentRequestData{
    WeakSelf
    [[RequestManager sharedInstance]postProductDetailWithId:self.productId userId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            strongSelf.infoDict = TipDic[@"data"];
            
            //判断是否下架或删除
            if ([strongSelf.infoDict[@"productStatus"] isEqualToString:@"normal"]) {
                [strongSelf.noDetailTipView removeFromSuperview];
                
                [self createUI];
                
            }else if ([self.infoDict[@"productStatus"] isEqualToString:@"delete"] || [self.infoDict[@"productStatus"] isEqualToString:@"down"]){
                [self createInsuranceDetailAlertVC];
                
            }else{
                self.noDetailTipView.tipType = NoDataTipTypeRequestError;
                
            }
        }else{
            self.noDetailTipView.tipType = NoDataTipTypeRequestError;
            
        }
    } Error:^(NSError *error) {
        self.noDetailTipView.tipType = NoDataTipTypeRequestError;
        
    }];
}

#pragma mark - 无数据view
-(void)createInsuranceDetailNoDataView{
    RLBDetailNoDataTipView *noDetailTipView = [[RLBDetailNoDataTipView alloc]initWithFrame:self.view.frame imageName:@"NoData" tipText:KInsuranceDetailDataRemoved];
    noDetailTipView.tipType = NoDataTipTypeRequestLoading;
    noDetailTipView.tapClick = ^(NoDataTipType tipType) {
        if (tipType == NoDataTipTypeNoData) {
            if(self.noDataBlock != nil){
                self.noDataBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [self appointmentRequestData];
        }
    };
    [self.view addSubview:noDetailTipView];
    [self.view bringSubviewToFront:noDetailTipView];
    _noDetailTipView = noDetailTipView;
}

#pragma mark - 数据删除回调
-(void)createInsuranceDetailAlertVC{
    self.noDetailTipView.tipType = NoDataTipTypeNoData;
    if ([self.infoDict[@"productStatus"] isEqualToString:@"delete"]){
        [self.noDetailTipView changeTipLabel:KInsuranceDetailDataRemoved];
        
    }else{
        [self.noDetailTipView changeTipLabel:KInsuranceDetailDataDown];
    }
}

#pragma mark - 设置界面元素
- (void)createUI{
    TPKeyboardAvoidingScrollView *bgScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar)];
    bgScrollView.backgroundColor = [UIColor customBackgroundColor];
    bgScrollView.delegate = self;
    bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView = bgScrollView;
    [self.view addSubview:bgScrollView];
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(bgScrollView, self);

    UILabel *productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Width_Window-20, 20)];
    productNameLabel.text = [NSString stringWithFormat:@"%@",self.productName];
    productNameLabel.textColor = [UIColor customNavBarColor];
    productNameLabel.textAlignment = NSTextAlignmentLeft;
    productNameLabel.font = [UIFont systemFontOfSize:16];
    [bgScrollView addSubview:productNameLabel];
    
    //姓名
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0, productNameLabel.bottom+10, Width_Window, 50)];
    nameView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:nameView];
    UILabel *nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 20)];
    nameLabel1.text = @"您的姓名：";
    nameLabel1.textColor = [UIColor customTitleColor];
    nameLabel1.textAlignment = NSTextAlignmentLeft;
    nameLabel1.font = [UIFont systemFontOfSize:16];
    [nameView addSubview:nameLabel1];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel1.right, 15, Width_Window-nameLabel1.right-10, 20)];
    nameLabel.text = [NSString stringWithFormat:@"%@",[StoreTool getRealname]];
    nameLabel.textColor = [UIColor customNavBarColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel = nameLabel1;
    [nameView addSubview:nameLabel];
   
    //电话
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, nameView.bottom+1, Width_Window, 50)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:phoneView];
    UILabel *phoneLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 20)];
    phoneLabel1.text = @"您的电话：";
    phoneLabel1.textColor = [UIColor customTitleColor];
    phoneLabel1.textAlignment = NSTextAlignmentLeft;
    phoneLabel1.font = [UIFont systemFontOfSize:16];
    [phoneView addSubview:phoneLabel1];
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(phoneLabel1.right, 15, Width_Window-phoneLabel1.right-10, 20)];
    phoneLabel.text = [NSString stringWithFormat:@"%@",[StoreTool getPhone]];
    phoneLabel.textColor = [UIColor customNavBarColor];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.font = [UIFont systemFontOfSize:16];
    self.phoneLabel = phoneLabel;
    [phoneView addSubview:phoneLabel];
    
    //保险公司
    UIView *companyView = [[UIView alloc]initWithFrame:CGRectMake(0, phoneView.bottom+1, Width_Window, 50)];
    companyView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:companyView];
    UILabel *companyLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 20)];
    companyLabel1.text = @"保险公司：";
    companyLabel1.textColor = [UIColor customTitleColor];
    companyLabel1.textAlignment = NSTextAlignmentLeft;
    companyLabel1.font = [UIFont systemFontOfSize:16];
    [companyView addSubview:companyLabel1];
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(companyLabel1.right, 15, Width_Window-companyLabel1.right-10, 20)];
    companyLabel.text = [NSString stringWithFormat:@"%@",self.companyName];
    companyLabel.textColor = [UIColor customNavBarColor];
    companyLabel.textAlignment = NSTextAlignmentLeft;
    companyLabel.font = [UIFont systemFontOfSize:16];
    self.companyLabel = companyLabel;
    [companyView addSubview:companyLabel];
    
    //保险计划
    self.planField = [self createTextFWithRect:CGRectMake(0, companyView.bottom+1, Width_Window, 50) TextTag:104 TextLeftLabelStr:@"保险计划：" LeftLabelWidth:100 TextPlaceholderStr:@"请输入保险计划" BGScrollView:bgScrollView];
    self.planField.enabled = YES;
    //保险金额
    self.moneyField = [self createTextFWithRect:CGRectMake(0, self.planField.bottom+1, Width_Window, 50) TextTag:105 TextLeftLabelStr:@"保险金额：" LeftLabelWidth:100 TextPlaceholderStr:@"请输入保险金额" BGScrollView:bgScrollView];
    self.moneyField.enabled = YES;
    //年缴保费
    self.yearFeeField = [self createTextFWithRect:CGRectMake(0, self.moneyField.bottom+1, Width_Window, 50) TextTag:106 TextLeftLabelStr:@"年缴保费：" LeftLabelWidth:100 TextPlaceholderStr:@"请输入年缴保费" BGScrollView:bgScrollView];
    self.yearFeeField.enabled = YES;
    //保险期限
    self.timeLimitField = [self createTextFWithRect:CGRectMake(0, self.yearFeeField.bottom+1, Width_Window, 50) TextTag:107 TextLeftLabelStr:@"保险期限：" LeftLabelWidth:100 TextPlaceholderStr:@"请输入保险期限" BGScrollView:bgScrollView];
    self.timeLimitField.enabled = YES;
    //缴费期限
    self.feeLimitField = [self createTextFWithRect:CGRectMake(0, self.timeLimitField.bottom+1, Width_Window, 50) TextTag:108 TextLeftLabelStr:@"缴费期限：" LeftLabelWidth:100 TextPlaceholderStr:@"请输入缴费期限" BGScrollView:bgScrollView];
    self.feeLimitField.enabled = YES;
    //预计交单时间
    self.anticipateTimeField = [self createTextFWithRect:CGRectMake(0, self.feeLimitField.bottom+10, Width_Window, 50) TextTag:109 TextLeftLabelStr:@"预计交单时间" LeftLabelWidth:120 TextPlaceholderStr:@"" BGScrollView:bgScrollView];
    self.anticipateTimeField.enabled = YES;
    //预计交单时间添加按钮
    UIButton *anticipateTimeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 50)];
    [anticipateTimeBtn addTarget:self action:@selector(anticipateTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.anticipateTimeField addSubview:anticipateTimeBtn];
    
    //备注说明
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.anticipateTimeField.bottom+10, Width_Window, 240)];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:bgView];
    
    UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    remarkLabel.text = @"备注说明：";
    remarkLabel.textColor = [UIColor customNavBarColor];
    remarkLabel.textAlignment = NSTextAlignmentLeft;
    remarkLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:remarkLabel];
    
    UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(10, remarkLabel.bottom+10, Width_Window-20, 200)];
    textView.backgroundColor =[UIColor whiteColor];
    textView.tag = 1000;
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:16];
    textView.textColor = [UIColor customDetailColor];
    self.textView = textView;
    [bgView addSubview:textView];
    [self setTextViewLabel:self.textView];
    
    bgScrollView.contentSize = CGSizeMake(Width_Window, bgView.bottom+Height_View_HomeBar+44+Height_Statusbar);
    
    //提交预约
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Window-Height_View_HomeBar-44, Width_Window, Height_View_HomeBar+44)];
    bottomView.backgroundColor = [UIColor customLightYellowColor];
    [self.view addSubview:bottomView];
    
    UIButton *noteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 44)];
    [noteBtn setTitle:@"提交预约" forState:UIControlStateNormal];
    [noteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    noteBtn.backgroundColor = [UIColor customLightYellowColor];
    [noteBtn addTarget:self action:@selector(noteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:noteBtn];
    self.noteBtn = noteBtn;
}

#pragma mark - 选择预计交单时间
- (void)anticipateTimeBtnClick:(UIButton *)btn{
    //选择日期
    ChooseDateViewController *chooseVC =[[ChooseDateViewController alloc]init];
    self.definesPresentationContext = YES; //self is presenting view controller
    chooseVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    chooseVC.modalPresentationStyle = UIModalPresentationCustom | UIModalPresentationFullScreen;
    chooseVC.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    chooseVC.delegate = self;
    [self presentViewController:chooseVC animated:YES completion:nil];
}

#pragma mark  - 代理方法返回值
//时间（年月日）
-(void)ChooseDateViewController:(ChooseDateViewController *)viewController didPassingValueWithStr:(NSString *)str{
    self.anticipateTimeField.text = str;
}

#pragma mark - 提交预约
- (void)noteBtnClick:(UIButton *)btn{
    if (!self.planField.text.length) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入保险计划"];
        return;
    }else if (!self.moneyField.text.length){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入保险金额"];
        return;
    }else if (!self.yearFeeField.text.length){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入年缴保费"];
        return;
    }else if (!self.timeLimitField.text.length){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入保险期限"];
        return;
    }else if (!self.feeLimitField.text.length){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入缴费期限"];
        return;
    }else if (!self.anticipateTimeField.text.length){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入预计交单时间"];
        return;
    }else{
        //提交预约
        [self requestAddAppointDataWithCompanyName:self.companyName exceptSubmitTime:self.anticipateTimeField.text insuranceAmount:self.moneyField.text insurancePeriod:self.timeLimitField.text insurancePlan:self.planField.text mobile:[StoreTool getPhone] paymentPeriod:self.feeLimitField.text periodAmount:self.yearFeeField.text productCategory:self.productCategory productId:self.productId productName:self.productName remark:self.textView.text userName:[StoreTool getRealname]];
        
    }
    [self.textView resignFirstResponder];
}

#pragma mark - 请求添加预约接口
- (void)requestAddAppointDataWithCompanyName:(NSString *)companyName exceptSubmitTime:(NSString *)exceptSubmitTime insuranceAmount:(NSString *)insuranceAmount insurancePeriod:(NSString *)insurancePeriod insurancePlan:(NSString *)insurancePlan mobile:(NSString *)mobile paymentPeriod:(NSString *)paymentPeriod periodAmount:(NSString *)periodAmount productCategory:(NSString *)productCategory productId:(NSString *)productId productName:(NSString *)productName remark:(NSString *)remark userName:(NSString *)userName{
    
    self.noteBtn.userInteractionEnabled = NO;
    
    [[RequestManager sharedInstance]postAddAppointWithCompanyName:companyName exceptSubmitTime:exceptSubmitTime insuranceAmount:insuranceAmount insurancePeriod:insurancePeriod insurancePlan:insurancePlan mobile:mobile paymentPeriod:paymentPeriod periodAmount:periodAmount productCategory:productCategory productId:productId productName:productName remark:remark userId:[StoreTool getUserID] userName:userName Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                self.noteBtn.userInteractionEnabled = NO;
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
                //提交成功 延时1秒（返回产品详情页面）
                [self performSelector:@selector(recordAotoStop) withObject:@"stopRecord" afterDelay:1.0];
                
                
            }else{
                self.noteBtn.userInteractionEnabled = YES;
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
            }
        }else{
            self.noteBtn.userInteractionEnabled = YES;
           [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
        }
    } Error:^(NSError *error) {
        self.noteBtn.userInteractionEnabled = YES;
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

//延时1秒（返回产品详情页面）
- (void)recordAotoStop{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建textfield
-(UITextField *)createTextFWithRect:(CGRect)textRect TextTag:(NSInteger)textTag TextLeftLabelStr:(NSString *)textLeftLabelStr LeftLabelWidth:(CGFloat)leftLabelWidth TextPlaceholderStr:(NSString *)textPlaceholderStr BGScrollView:(UIView *)bgScrollView{
    UITextField *textF = [[UITextField alloc]initWithFrame:textRect];
    textF.backgroundColor = [UIColor whiteColor];
    textF.textColor = [UIColor customNavBarColor];
    textF.font = [UIFont systemFontOfSize:16];
    textF.delegate = self;
    textF.tag = textTag;
    textF.placeholder = textPlaceholderStr;
    if(![NSString isBlankString:textPlaceholderStr]){
        //设置水印颜色
        NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc]initWithString:textF.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]}];
        textF.attributedPlaceholder = arrStr;
    }
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    if (textTag == 105 || textTag == 106) {
//        textF.keyboardType = UIKeyboardTypeNumberPad;
//    }
    
    UILabel *leftLabel= [[UILabel alloc]init];
    leftLabel.frame = CGRectMake(10, 0, leftLabelWidth, textRect.size.height);
    leftLabel.font = [UIFont systemFontOfSize:16];
    leftLabel.textColor = [UIColor customTitleColor];
    leftLabel.text = [NSString stringWithFormat:@"  %@",textLeftLabelStr];
    textF.leftView = leftLabel;
    textF.leftViewMode = UITextFieldViewModeAlways;
    
    if (textTag == 109) {
        leftLabel.textColor = [UIColor customNavBarColor];
        //添加右箭头
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(textRect.size.width-20, 20, 20, 20)];
        UIImageView *jianimageV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 15)];
        jianimageV.image = [UIImage imageNamed:@"arrow_r"];
        [bgview addSubview:jianimageV];
        textF.rightView = bgview;
        textF.rightViewMode = UITextFieldViewModeAlways;
    }else{
        leftLabel.textColor = [UIColor customTitleColor];
        
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

#pragma mark - textView的水印效果
-(void)setTextViewLabel:(UITextView *)textView{
    //占位符
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textView.width, 40)];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = [UIColor customDetailColor];
    label.numberOfLines = 0;
    label.text = @" 输入其他说明";
    self.label = label;
    [textView addSubview:self.label];
}

#pragma mark - UITextView Delegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length != 0) {
        self.label.hidden = YES;
    }else {
        self.label.hidden = NO;
    }
}

//如果输入超过规定的字数50，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location>50){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"最大允许输入50个字符!"];
        return  NO;
    }else{
        return YES;
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
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
