//
//  IntroduceBottomView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "IntroduceBottomView.h"
#import "Configure.h"
#import "IntroduceModel.h"
#import "QLColorLabel.h"
#import <WebKit/WebKit.h>

@interface IntroduceBottomView ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *typeLabel;
@property (nonatomic, weak) UILabel *detailLable;
@property (nonatomic, weak) WKWebView *wkWebView;
@end

@implementation IntroduceBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

-(void)setIntroduceInfoModel:(IntroduceModel *)introduceInfoModel{
    _introduceInfoModel = introduceInfoModel;

    self.titleLabel.text = [NSString stringWithFormat:@"%@",introduceInfoModel.courseName];
    self.timeLabel.text = [NSString stringWithFormat:@"课程时间:<%@>",introduceInfoModel.courseTime];
    self.typeLabel.text = [NSString stringWithFormat:@"课程类型:<%@>",introduceInfoModel.typeName];
    NSString *htmlStr = [NSString stringWithFormat:@"%@",introduceInfoModel.courseContent];

    /*
    CGSize rectSize = CGSizeMake(self.detailLable.width, MAXFLOAT);
    //获取全局并发队列
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //放在分线程中，防止影响操作
        NSMutableAttributedString *str=  [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, str.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor customTitleColor] range:NSMakeRange(0, str.length)];
        
        //    (字体font是自定义的 要求和要显示的label设置的font一定要相同)
        CGRect rect = [str boundingRectWithSize:rectSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        
        // 获取主队列 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detailLable.frame = CGRectMake(self.detailLable.left, self.detailLable.top, self.detailLable.width, rect.size.height);
            
            self.detailLable.attributedText =  str;
            
            self.frame = CGRectMake(0, self.top, Width_Window, self.detailLable.bottom+20);
            if ([self.superview isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)self.superview).contentSize = CGSizeMake(Width_Window, self.detailLable.bottom+20+110+10);
            }
        });
    });
     */
    [self.wkWebView loadHTMLString:[self handleUrlStr:htmlStr] baseURL:nil];
}

-(NSString *)handleUrlStr:(NSString *)oldStr{
    /*!
     image居中+全部显示
     <img style='display:block;max-width:100%'  src="http://192.168.1.82:9091/upload/ueditor/image/20180518/1526611877839042920/1526611877839042920.png" title="" alt="1526611877839042920.png">
     */
    
    //处理整个html语句，来达到正确获得内容高度的目的
    NSString *htmlStr = [NSString stringWithFormat:@"<html><head><meta http-equiv=\'Content-Type\' content=\'text/html; charset=utf-8\'/><meta content=\'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;\' name=\'viewport\' /><meta name=\'apple-mobile-web-app-capable\' content=\'yes\'><meta name=\'apple-mobile-web-app-status-bar-style\' content=\'black\'><link rel=\'stylesheet\' type=\'text/css\' /><style type=\'text/css\'> .color{color:#576b95;}</style></head><body><div id=\'content\'>%@</div>", oldStr];
    return htmlStr;
}
#pragma mark - UI
-(void)createUI{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.width-40, 30)];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor customNavBarColor];
    [self addSubview:titleLabel];
    
    QLColorLabel *timeLabel = [[QLColorLabel alloc]initWithFrame:CGRectMake(20, titleLabel.bottom+10, 170, 30)];
    timeLabel.font = [UIFont systemFontOfSize:16.0];
    timeLabel.textColor = [UIColor customDetailColor];
    [timeLabel setAnotherColor: [UIColor customTitleColor]];
    [self addSubview:timeLabel];
    
    QLColorLabel *typeLabel = [[QLColorLabel alloc]initWithFrame:CGRectMake(timeLabel.right+10, titleLabel.bottom+10, self.width-210, 30)];
    typeLabel.font = [UIFont systemFontOfSize:16.0];
    typeLabel.textColor = [UIColor customDetailColor];
    [typeLabel setAnotherColor: [UIColor customTitleColor]];
    [self addSubview:typeLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, timeLabel.bottom+10, self.width-20, 1)];
    lineView.backgroundColor = [UIColor customLineColor];
    [self addSubview:lineView];
    
    UILabel *detailLable = [[UILabel alloc]initWithFrame:CGRectMake(20, lineView.bottom + 10, self.width-40, 30)];
//    detailLable.font = [UIFont systemFontOfSize:18.0];
//    detailLable.textColor = [UIColor customTitleColor];
    detailLable.numberOfLines = 0;
//    [self addSubview:detailLable];
    
    WKWebView *wkWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, lineView.bottom + 10,  self.width, 10)];
    wkWebview.UIDelegate = self;
    wkWebview.navigationDelegate = self;
    wkWebview.backgroundColor = [UIColor whiteColor];
    wkWebview.scrollView.scrollEnabled = NO;
    [self addSubview: wkWebview];
    _wkWebView = wkWebview;
    
    _titleLabel = titleLabel;
    _timeLabel = timeLabel;
    _typeLabel = typeLabel;
    _detailLable = detailLable;
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id data, NSError * _Nullable error) {
        CGFloat height = [data floatValue];
        //ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
        CGRect webFrame = webView.frame;
        webFrame.size.height = height;
        
        // 获取主队列 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            webView.frame = webFrame;
            self.frame = CGRectMake(0, self.top, Width_Window, webView.bottom+20);
            if ([self.superview isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)self.superview).contentSize = CGSizeMake(Width_Window, webView.bottom+20+110+10);
            }
        });
    }];
}

-(void)dealloc{
    [_wkWebView removeFromSuperview];
    _wkWebView = nil;
}
@end
