//
//  QuestionUserViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/11.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "QuestionUserViewController.h"
#import "Configure.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "GBTagListView.h"
#import "QAPageBarModel.h"

static NSString *AfterPostSuccessPOP = @"popToVC";
@interface QuestionUserViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, weak) GBTagListView *tagListView;
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UITextField *titleTextF;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, copy) NSString *selectTagStr;

@end

@implementation QuestionUserViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //取消performSelector
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recordAotoStop) object:AfterPostSuccessPOP];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我要提问";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    TPKeyboardAvoidingScrollView *bgScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_View_SafeArea-44)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.delegate = self;
    [self.view addSubview:bgScrollView];
    adjustsScrollViewInsets_NO(bgScrollView, self);
    
    NSMutableArray *oldTagArr = [NSMutableArray arrayWithArray:self.strArray];
    [oldTagArr removeObjectAtIndex:0];
    
    NSMutableArray *tagArr = [NSMutableArray arrayWithCapacity:5];
    for (QAPageBarModel *model in oldTagArr) {
        [tagArr addObject:[NSString stringWithFormat:@"%@",model.typeName]];
    }
    
   NSArray *strArray= tagArr;
    
    GBTagListView *tagList=[[GBTagListView alloc]initWithFrame:CGRectMake(0, 10, Width_Window, 0)];
    /**允许点击 */
    tagList.canTouch=YES;
    /**单选 */
    tagList.isSingleSelect = YES ;
    tagList.titleNormalColor = [UIColor customNavBarColor];
    tagList.titleSelectColor = [UIColor customDeepYellowColor];
    tagList.signalTagColor=[UIColor whiteColor];
    [tagList setTagWithTagArray:strArray];
    [tagList setDidselectItemBlock:^(NSArray *arr) {
        if(arr.count != 0){
            QAPageBarModel *selectmodel = [oldTagArr objectAtIndex:[arr[0] integerValue]];
            self.selectTagStr = [NSString stringWithFormat:@"%@",selectmodel.typeCode];
        }
    }];
    [bgScrollView addSubview:tagList];
    
    //标题
    UITextField *titleTextF = [[UITextField alloc]initWithFrame:CGRectMake(0, tagList.bottom+10, Width_Window, 50)];
    titleTextF.backgroundColor = [UIColor whiteColor];
    titleTextF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 13, 20)];
    titleTextF.leftViewMode = UITextFieldViewModeAlways;
    titleTextF.delegate = self;
    titleTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgScrollView addSubview:titleTextF];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:16]; // 设置font
    attrs[NSForegroundColorAttributeName] = [UIColor customDetailColor]; // 设置颜色
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"输入您想要了解的问题标题(10-30字内)" attributes:attrs]; // 初始化富文本占位字符串
    titleTextF.attributedPlaceholder = attStr;
    
    //内容
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, titleTextF.bottom + 10, Width_Window, 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:bgView];
    
    UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(8, 0, bgView.width-16, bgView.height)];
    textView.backgroundColor =[UIColor whiteColor];
    textView.tag = 1000;
    textView.font = [UIFont systemFontOfSize:17];
    textView.delegate = self;
    [bgView addSubview:textView];
    [self setTextViewLabel:textView];
    
    UIButton *noteBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, bgView.bottom + 20, Width_Window-40, 44)];
    [noteBtn setTitle:@"提交" forState:UIControlStateNormal];
    [noteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    noteBtn.backgroundColor = [UIColor customDeepYellowColor];
    noteBtn.layer.cornerRadius = 22;
    noteBtn.layer.masksToBounds = YES;
    [noteBtn addTarget:self action:@selector(noteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:noteBtn];
    
    _tagListView = tagList;
    _textView = textView;
    _titleTextF = titleTextF;
    
    //设置bgScrollView的contentSize
    bgScrollView.contentSize = CGSizeMake(Width_Window, noteBtn.bottom+10);
}
#pragma mark - 数据请求
-(void)requestGroupTopicAddData{
    [[RequestManager sharedInstance]postQAQuestionAddWithUserID:[StoreTool getUserID] QuestionTypeCode:self.selectTagStr QuestionTitle:self.titleTextF.text QuestionDesc:self.textView.text Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
                self.titleTextF.text = @"";
                self.textView.text = @"";
                [self textViewDidChange:self.textView];
                [self.tagListView clearTheAllSelectItem];
                
                [self performSelector:@selector(recordAotoStop) withObject:AfterPostSuccessPOP afterDelay:1.5];
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
    if (self.addBlock != nil) {
        self.addBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)noteBtnClick{
    if(self.selectTagStr.length == 0){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请选择问答类型！"];
        return;
    }
    if(self.titleTextF.text.length == 0){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入标题！"];
        return;
    }
    if (self.textView.text.length == 0) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入问题描述！"];
        return;
    }
    if(self.titleTextF.text.length >30 || self.titleTextF.text.length <10){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"问题标题应在10-30字内"];
        return;
    }
    if (self.textView.text.length > 200) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"问题描述需在200字内"];
        return;
    }
    [self.textView resignFirstResponder];
    [self requestGroupTopicAddData];
}

-(void)setTextViewLabel:(UITextView *)textView{
    //占位符
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, textView.width-10, 40)];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = [UIColor customDetailColor];
    label.numberOfLines = 0;
    label.text = @"请对您的问题进行简单清晰的描述(200字以内)";
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
//只允许输入四位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString length] > 30) {
        return NO;
    }
    return YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
