//
//  PublishTopicViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/12.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "PublishTopicViewController.h"
#import "Configure.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "GBTagListView.h"
#import "CustomButton.h"

@interface PublishTopicViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UITextField *titleTextF;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) CustomButton *noteBtn;

@end

@implementation PublishTopicViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布话题";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    TPKeyboardAvoidingScrollView *bgScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_View_SafeArea-44)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.delegate = self;
    [self.view addSubview:bgScrollView];
    adjustsScrollViewInsets_NO(bgScrollView, self);
    
    //内容
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Width_Window, 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:bgView];
    
    UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(10, 0, bgView.width-20, bgView.height)];
    textView.backgroundColor =[UIColor whiteColor];
    textView.tag = 1000;
    textView.font = [UIFont systemFontOfSize:16];
    textView.delegate = self;
    [bgView addSubview:textView];
    [self setTextViewLabel:textView];
    
    CustomButton *noteBtn = [[CustomButton alloc]initWithFrame:CGRectMake(10, bgView.bottom + 20, Width_Window-20, 44)];
    [noteBtn setTitle:@"提交" forState:UIControlStateNormal];
    [noteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    noteBtn.backgroundColor = [UIColor customDeepYellowColor];
    [noteBtn addTarget:self action:@selector(noteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:noteBtn];
    noteBtn.btnStopBlock = ^{
        //POP时间
        [self.navigationController popViewControllerAnimated:YES];
    };
    _textView = textView;
    _noteBtn = noteBtn;
    
    //设置bgScrollView的contentSize
    bgScrollView.contentSize = CGSizeMake(Width_Window, noteBtn.bottom+10);
}

-(void)noteBtnClick{
    if (self.textView.text.length == 0) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"内容不能为空哦^_^"];
        return;
    }
    [self.textView resignFirstResponder];
    
    [self requestGroupTopicAddData];
}

-(void)requestGroupTopicAddData{
    [self.noteBtn startAnimation:@"发布中..."];
    [[RequestManager sharedInstance]postGroupTopicAddWithUserID:[StoreTool getUserID] CircleId:self.circleID Content:self.textView.text Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
                self.textView.text = @"";
                [self textViewDidChange:self.textView];
                [self.noteBtn stopAnimationWithSuccess:@"发布成功"];
            } else {
                [self.noteBtn stopAnimationWithFail:@"发布失败"];
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }
        } else {
            [self.noteBtn stopAnimationWithFail:@"发布失败"];
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        [self.noteBtn stopAnimationWithFail:@"发布失败"];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

-(void)setTextViewLabel:(UITextView *)textView{
    //占位符
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, textView.width-5, 40)];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.text = @"说点什么吧...(200字以内)";
    [textView addSubview:label];
    _label = label;
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
    if (range.location>=200){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"最大允许输入200字符!"];
        return  NO;
    }else{
        return YES;
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
