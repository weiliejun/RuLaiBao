//
//  AnswerUserViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/11.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "AnswerUserViewController.h"
#import "Configure.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "QAListModel.h"

static NSString *AfterPostSuccessPOP = @"popToVC";

@interface AnswerUserViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *noteBtn;

@end

@implementation AnswerUserViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //取消performSelector
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recordAotoStop) object:AfterPostSuccessPOP];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"回答";
    self.view.backgroundColor = [UIColor customBackgroundColor];

    TPKeyboardAvoidingScrollView *bgScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_View_SafeArea-44)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.delegate = self;
    [self.view addSubview:bgScrollView];
    adjustsScrollViewInsets_NO(bgScrollView, self);
    
    UIView *labelBgView = [[UIView alloc]init];
    labelBgView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:labelBgView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor customNavBarColor];
    titleLabel.font = [UIFont systemFontOfSize:KFontTitleSize];
    titleLabel.numberOfLines = 0;
    [labelBgView addSubview:titleLabel];
    
    NSString *str = [NSString stringWithFormat:@"%@",self.detailModel.title];
    //计算高度
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KFontTitleSize] range:[str rangeOfString:str]];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 2;//增加行高
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:[str rangeOfString:str]];
    titleLabel.attributedText = attrString;
    CGFloat labelHeight = [attrString boundingRectWithSize:CGSizeMake(Width_Window-28, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    labelBgView.frame = CGRectMake(0, 0, Width_Window, labelHeight+20);
    titleLabel.frame = CGRectMake(14, 10, Width_Window-28, labelHeight);
    
    //底部bgview
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,labelBgView.bottom + 10, Width_Window, 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:bgView];
    
    UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(10, 0, bgView.width-20, bgView.height)];
    textView.backgroundColor =[UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:18.0];
    textView.textColor = [UIColor customTitleColor];
    textView.delegate = self;
    self.textView = textView;
    [bgView addSubview:textView];
    [self setTextViewLabel:self.textView];
    
    UIButton *noteBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, bgView.bottom + 20, Width_Window-40, 44)];
    [noteBtn setTitle:@"提交" forState:UIControlStateNormal];
    [noteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    noteBtn.backgroundColor = [UIColor customDeepYellowColor];
    noteBtn.layer.cornerRadius = 22;
    noteBtn.layer.masksToBounds = YES;
    [noteBtn addTarget:self action:@selector(noteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:noteBtn];
    
    //设置bgScrollView的contentSize
    bgScrollView.contentSize = CGSizeMake(Width_Window, noteBtn.bottom+10);
    _noteBtn = noteBtn;
}

#pragma mark - 数据请求
-(void)requestQAAnswerAddData{
    self.noteBtn.enabled = NO;
    [[RequestManager sharedInstance]postQAAnswerAddWithUserID:[StoreTool getUserID] QuestionID:self.detailModel.questionId AnswerContent:self.textView.text Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
                self.textView.text = @"";
                [self textViewDidChange:self.textView];
                
                [self performSelector:@selector(recordAotoStop) withObject:AfterPostSuccessPOP afterDelay:1.0];
            } else {
                self.noteBtn.enabled = YES;
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }
        } else {
            self.noteBtn.enabled = YES;
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        self.noteBtn.enabled = YES;
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}
-(void)recordAotoStop{
    self.noteBtn.enabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)noteBtnClick{
    if (self.textView.text.length == 0) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入您的回答..."];
        return;
    }
    [self.textView resignFirstResponder];
    [self requestQAAnswerAddData];
}

-(void)setTextViewLabel:(UITextView *)textView{
    //占位符
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, textView.width-6, 40)];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = [UIColor customDetailColor];
    label.numberOfLines = 0;
    label.text = @"请认真输入您的回答...(500字以内)";
    self.label = label;
    [textView addSubview:self.label];
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length != 0) {
        self.label.hidden = YES;
    }else {
        self.label.hidden = NO;
    }
}

//如果输入超过规定的字数145，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location>=500){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"最大允许输入500字符!"];
        return  NO;
    }else{
        return YES;
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
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
