//
//  FoldView.m
//  QLScrollViewDemo
//
//  Created by qiu on 2018/6/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "FoldView.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"
#import "Configure.h"

@interface FoldView ()<WKNavigationDelegate,WKUIDelegate>

/** 组头名称 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 箭头 */
@property (nonatomic, weak) UIImageView *arrowImageView;
/** 避免重复点击 */
@property (nonatomic, assign) BOOL IsAgain;

@property (nonatomic, assign) BOOL IsExpand;

@property (nonatomic, assign) BOOL isFirstLoad;

@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, weak) WKWebView *wkWebView;

@property (nonatomic, weak) UIActivityIndicatorView *activityView;

@end
@implementation FoldView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        
        self.IsAgain = YES;
        self.IsExpand = NO;
        self.isFirstLoad = YES;
    }
    return self;
}

-(void)createUI{
    // 初始化
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 44)];
    titleLabel.textColor = [UIColor customTitleColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"保障责任";
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-25, 17, 15, 10)];
    arrowImageView.image = [UIImage imageNamed:@"home_plan_up"];
    [self addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    UIButton *reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    [reloadButton addTarget:self action:@selector(reloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reloadButton];
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
   self.titleLabel.text = titleStr;
}

/** 点击按钮控制器 */
- (void)reloadButtonClick {
    // 控制点击一下执行完毕之后再点击才能生效,避免重复点击
    if (!self.IsAgain) {
        return;
    }
    self.IsAgain = NO;
    [self addWebView];
    // 旋转箭头
    [UIView animateWithDuration:.25 animations:^{
        if (!self.IsExpand) {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        self.IsAgain = YES;
        self.IsExpand = !self.IsExpand;
        if(self.IsExpand){
            self.wkWebView.hidden = NO;
        }else{
            self.wkWebView.hidden = YES;
        }
        
        if (self.viewHeight != 0) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                if (self.IsExpand) {
                    make.height.mas_equalTo(self.viewHeight + 44);
                }else{
                    make.height.mas_equalTo(44.f);
                }
            }];
        }else{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                if (self.IsExpand) {
                    make.height.mas_equalTo(300);
                }else{
                    make.height.mas_equalTo(44.f);
                }
            }];
            self.activityView.center = CGPointMake(self.frame.size.width/2, 150);
            self.activityView.hidden = NO;
        }
    }];
}

-(void)addWebView{
    if (self.isFirstLoad) {
        [self.wkWebView loadHTMLString:[self handleUrlStr:self.urlStr] baseURL:nil];
    }
}

-(NSString *)handleUrlStr:(NSString *)oldStr{
    //处理整个html语句，来达到正确获得内容高度的目的
    NSString *htmlStr = [NSString stringWithFormat:@"<html><head><meta http-equiv=\'Content-Type\' content=\'text/html; charset=utf-8\'/><meta content=\'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;\' name=\'viewport\' /><meta name=\'apple-mobile-web-app-capable\' content=\'yes\'><meta name=\'apple-mobile-web-app-status-bar-style\' content=\'black\'><link rel=\'stylesheet\' type=\'text/css\' /><style type=\'text/css\'> .color{color:#576b95;}</style></head><body><div id=\'content\'>%@</div>", oldStr];
    return htmlStr;
    
}

-(WKWebView *)wkWebView{
    if (_wkWebView == nil) {
        WKWebView *wkWebview = [[WKWebView alloc] initWithFrame:CGRectMake(10, 44, self.frame.size.width-20, 10)];
        wkWebview.UIDelegate = self;
        wkWebview.navigationDelegate = self;
//        [wkWebview sizeToFit];
        wkWebview.backgroundColor = [UIColor whiteColor];
        wkWebview.scrollView.scrollEnabled = NO;
        wkWebview.hidden = YES;
        [self addSubview: wkWebview];
        _wkWebView = wkWebview;
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [self addSubview:activityView];
        activityView.hidden = YES;
        _activityView =activityView;
    }
    return _wkWebView;
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
        webView.frame = webFrame;
        self.isFirstLoad = NO;
        [self.activityView removeFromSuperview];
        self.viewHeight = height;
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.IsExpand) {
                make.height.mas_equalTo(height+44);
            }else{
                make.height.mas_equalTo(44.f);
            }
        }];
    }];
}

-(void)dealloc{
    [_wkWebView removeFromSuperview];
    _wkWebView = nil;
}

@end



