//
//  CustomerServiceViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "CustomerServiceViewController.h"
#import "Configure.h"
#import "TPKeyboardAvoidingScrollView.h"

#define MAX_LIMIT_NUMS 200

@interface CustomerServiceViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UILabel *label;//占位符
@property (nonatomic, weak) UILabel *numberLabel;//字数
@property (nonatomic, weak) UITextField *phoneText;//手机号

@end

@implementation CustomerServiceViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //取消performSelector
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recordAotoStop) object:@"stopRecord"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"联系客服";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createUI];
}

#pragma mark - 设置界面元素
- (void)createUI{
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, Width_Window, Height_Window)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    adjustsScrollViewInsets_NO(scrollView, self);
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Width_Window, 250)];
    bgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bgView];
    
    UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(10, 0, bgView.width-20, 200)];
    textView.delegate = self;
    textView.tag = 1000;
    textView.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:textView];
    self.textView = textView;
    [self setTextViewLabel:self.textView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, textView.bottom, Width_Window, 1)];
    line.backgroundColor = [UIColor customLineColor];
    [bgView addSubview:line];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, textView.bottom+15, 80, 20)];
    phoneLabel.text = @"手机号码";
    phoneLabel.textColor = [UIColor customTitleColor];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:phoneLabel];
    
    UITextField *phoneText = [[UITextField alloc]initWithFrame:CGRectMake(phoneLabel.right+10, textView.bottom+5, Width_Window-110, 40)];
    phoneText.placeholder = @"请输入您的手机号码";
    phoneText.backgroundColor = [UIColor whiteColor];
    phoneText.textColor = [UIColor customTitleColor];
    phoneText.textAlignment = NSTextAlignmentLeft;
    phoneText.font = [UIFont systemFontOfSize:16];
    phoneText.delegate = self;
    phoneText.tag = 2000;
    phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:phoneText];
    self.phoneText = phoneText;
    
    UIButton *noteBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, bgView.bottom + 20, Width_Window-20, 44)];
    [noteBtn setTitle:@"提交" forState:UIControlStateNormal];
    [noteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    noteBtn.backgroundColor = [UIColor customLightYellowColor];
    noteBtn.layer.cornerRadius = 20;
    noteBtn.layer.masksToBounds = YES;
    [noteBtn addTarget:self action:@selector(noteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:noteBtn];
    
    scrollView.contentSize = CGSizeMake(Width_Window, noteBtn.bottom +30);
}

#pragma mark - 提交按钮
- (void)noteBtnClick{
    if (!self.textView.text.length) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入您想要咨询的问题"];
        return;
    }else if (!self.phoneText.text.length){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入您的手机号码"];
        return;
    }else if (![Utils validPhone:self.phoneText.text]){
        //校验手机号
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入正确的的手机号码"];
        return;
    }
    [self.textView resignFirstResponder];
    
    //提交
    [self requestCustomerServiceDataWithContent:self.self.textView.text mobile:self.phoneText.text];
}

#pragma mark - 请求提交反馈接口
- (void)requestCustomerServiceDataWithContent:(NSString *)content mobile:(NSString *)mobile{
    [[RequestManager sharedInstance]postCustomerServiceWithContent:content mobileNumber:mobile userId:[StoreTool getUserID] userName:[StoreTool getRealname] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
                //延时1秒返回上页
                [self performSelector:@selector(recordAotoStop) withObject:@"stopRecord" afterDelay:1.0];
            }else{

                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
                
            }
        }else{
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
        }
     } Error:^(NSError *error) {
         [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
     }];
}

//延时1秒返回上页
- (void)recordAotoStop{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextView设置占位符
-(void)setTextViewLabel:(UITextView *)textView{
    //占位符
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, textView.width-15, 40)];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor customDetailColor];
    label.numberOfLines = 0;
    label.text = @"请输入您想要咨询的问题，我们会及时与您联系！";
    [textView addSubview:label];
    self.label = label;
    
    //字数
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(textView.width-95, textView.bottom-30, 90, 20)];
    numberLabel.text = @"200/200";
    numberLabel.textColor = [UIColor customDetailColor];
    numberLabel.textAlignment = NSTextAlignmentRight;
    numberLabel.font = [UIFont systemFontOfSize:14];
    [textView addSubview:numberLabel];
    self.numberLabel = numberLabel;
}

#pragma mark - UITextView Delegate
-(void)textViewDidChange:(UITextView *)textView{
    //动态控制占位符显示
    if (textView.text.length != 0) {
        self.label.hidden = YES;
    }else {
        self.label.hidden = NO;
    }
    
    //动态显示剩余可输入文字个数
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum >MAX_LIMIT_NUMS){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        [textView setText:s];
    }
    //不让显示负数
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}

//如果输入超过规定的字数200，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location >= 200){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"最多允许输入200字符!"];
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
