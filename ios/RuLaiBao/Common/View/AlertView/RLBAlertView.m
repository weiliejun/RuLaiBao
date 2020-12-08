//
//  HXBankAlertView.m
//  自定义弹框
//
//  Created by xxn on 2018/7/31.
//  Copyright © 2018年 Mrjia. All rights reserved.
//

#import "RLBAlertView.h"
#import "UIColor+CustomColors.h"
#import "NSString+Custom.h"
#import "UIView+Common.h"
#import "Configure.h"

@implementation RLBAlertView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag=12139;
        self.backgroundColor = [UIColor clearColor];
        //遮罩层
        view_mask = [[UIView alloc] initWithFrame:CGRectZero];
        view_mask.backgroundColor = [UIColor blackColor];
        view_mask.alpha = 0.4;
        [self addSubview:view_mask];
        
        //contentview
        contentview = [[UIView alloc] initWithFrame:CGRectZero];
        contentview.backgroundColor = [UIColor colorWithHex:0xffffff];
        contentview.layer.cornerRadius = 5.0;
        contentview.layer.masksToBounds = YES;
        [self addSubview:contentview];
        
        // title
        lab_title = [[UILabel alloc] initWithFrame:CGRectZero];
        [lab_title setFont:[UIFont boldSystemFontOfSize:20]];
        [lab_title setTextAlignment:NSTextAlignmentCenter];
        [lab_title setBackgroundColor:[UIColor clearColor]];
        [lab_title setTextColor:[UIColor blackColor]];
        [contentview addSubview:lab_title];
        
        //msg
        textview = [[UITextView alloc] initWithFrame:CGRectZero];
        [textview setTextAlignment:NSTextAlignmentLeft];
        [textview setBackgroundColor:[UIColor clearColor]];
        [textview setTextColor:[UIColor colorWithHex:0x444444]];
        [textview setFont:[UIFont systemFontOfSize:16]];
        [textview setUserInteractionEnabled:NO];
        textview.delegate=self;
        textview.editable=NO;
        [contentview addSubview:textview];
        
        //同意
        btn_confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_confirm setBackgroundColor:[UIColor customDeepYellowColor]];
        [btn_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_confirm.titleLabel.font=[UIFont systemFontOfSize:16];
        [btn_confirm addTarget:self action:@selector(ButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        btn_confirm.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;// 水平左对齐
        btn_confirm.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;// 垂直居中对齐
        [contentview addSubview:btn_confirm];
        
        //不同意
        btn_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_cancel setBackgroundColor:[UIColor clearColor]];
        [btn_cancel setTitleColor:[UIColor customNavBarColor] forState:UIControlStateNormal];
        btn_cancel.titleLabel.font=[UIFont systemFontOfSize:16];
        [btn_cancel addTarget:self action:@selector(CloseButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
        btn_cancel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [contentview addSubview:btn_cancel];
    }
    return self;
}

-(void)CloseButtonPress:(UIButton*)sender{
    if (self.ClickBtnBlock) {
        self.ClickBtnBlock(0,@"",@"");
    }
    [self hide];
}

+(RLBAlertView *)AlertWith:(NSString *)title ConfirmBtn:(NSString *)str1 CancelBtn:(NSString *)str2 Msg:(NSString *)content ResultBolck:(ClickButton)clickBlock{
    RLBAlertView * alertview = [[RLBAlertView alloc] initWithFrame:CGRectZero];
    if (alertview) {
        alertview.str_title = title;
        alertview.str_msg = content;
        alertview.str_btn1title = str2;
        alertview.str_btn2title = str1;
        
        if (clickBlock) {
            alertview.ClickBtnBlock = clickBlock;
        }
    }
    return alertview;
}
-(void)layoutSubviews{
    // 底部白色框架的宽度
    CGFloat msgWidth = [UIScreen mainScreen].bounds.size.width-80;
    textview.text = self.str_msg;
    
    if (![self.str_title isEqualToString:@""]) {
        lab_title.text = self.str_title;
    }else{
        lab_title.text = @"温馨提示";
    }
    self.frame = [[[UIApplication sharedApplication] keyWindow] bounds];
    view_mask.frame = self.frame;
    
    // title
    lab_title.frame = CGRectMake(15, 40, msgWidth - 30, 30);
    
    
    textview.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor customBlueColor]};
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor customNavBarColor]};
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textview.text attributes:attributes];
    NSRange range1 = [[attrStr string] rangeOfString:@"《 如来保会员服务协议 》"];
    [attrStr addAttribute:NSLinkAttributeName value:@"vipCategory://" range:range1];
    NSRange range2 = [[attrStr string] rangeOfString:@"《 隐私政策 》"];
    [attrStr addAttribute:NSLinkAttributeName value:@"serectCategory://" range:range2];
    textview.attributedText = attrStr;
    textview.userInteractionEnabled=YES;
    
    CGSize resultSize = [attrStr boundingRectWithSize:CGSizeMake(msgWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  context:nil].size;
    
    CGFloat textViewHeight = ceilf(resultSize.height)+20;
    if(textViewHeight > 260){
        textViewHeight = 260;
    }
    textview.frame = CGRectMake(15, lab_title.bottom + 6, msgWidth-30, textViewHeight);
    
    btn_confirm.frame = CGRectMake(15, textview.bottom + 40, msgWidth - 30 , 45);
    [btn_confirm setTitle:self.str_btn2title forState:UIControlStateNormal];
    btn_confirm.layer.cornerRadius = 5;
    btn_confirm.layer.masksToBounds = NO;
    
    btn_cancel.frame = CGRectMake(15, btn_confirm.bottom+10, msgWidth - 30 , 30);
    [btn_cancel setTitle:self.str_btn1title forState:UIControlStateNormal];
    
    contentview.frame = CGRectMake(0, 0, msgWidth, btn_cancel.bottom+10);
    contentview.center = CGPointMake(self.center.x, self.center.y);
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"vipCategory"]) {
        if (self.ClickBtnBlock) {
            self.ClickBtnBlock(2,[NSString stringWithFormat:@"%@://%@/app/service/agreement", webHttp, RequestHeader],@"如来保会员服务协议");
        }
        return NO;
    }else if ([[URL scheme] isEqualToString:@"serectCategory"]){
        if (self.ClickBtnBlock) {
            self.ClickBtnBlock(3,[NSString stringWithFormat:@"%@://%@/app/service/privacyPolicyStatement", webHttp, RequestHeader],@"隐私政策");
        }
        return NO;
    }
    return YES;
}

-(void)show:(UIViewController *)vc{
    if (![self isDescendantOfView:vc.view]) {
        [vc.view addSubview:self];
        [vc.view bringSubviewToFront:self];
    }
}
-(void)show{
    if (![self isDescendantOfView:[[UIApplication sharedApplication] keyWindow]]) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self];
    }
}

-(void)hide{
    if ([self isDescendantOfView:[[UIApplication sharedApplication] keyWindow]]) {
        [self removeFromSuperview];
    }
}

-(void)ButtonPress:(id)sender{
    if (self.ClickBtnBlock) {
        self.ClickBtnBlock(1,@"",@"");
    }
    [self hide];
}

//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
