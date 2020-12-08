//
//  QLWKWebViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/20.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "QLWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "Configure.h"
#import "AppDelegate.h"
#import "CustomShareUI.h"
//dealloc
#import "WeakScriptMessageDelegate.h"

#define WebViewNav_TintColor ([UIColor orangeColor])


@interface QLWKWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, weak) WKWebView *webView;

@property (nonatomic, weak) UIProgressView *progressView;

@end

@implementation QLWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [UIColor customBackgroundColor];
    self.navigationItem.title = self.titleStr;
    if (self.isRightItem2Share) {
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(toShareProduct)];
        self.navigationItem.rightBarButtonItem = shareItem;
    }
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window - Height_Statusbar_NavBar)];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    //监听title变化
    if (self.webViewTitleCanTransformStatus == WebViewTitleCanTransformYES) {
        [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    [self.view addSubview:webView];
    self.webView = webView;
    
    /** 去掉底部空白 */
    adjustsScrollViewInsets_NO(webView.scrollView, self);
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, self.view.frame.size.width, 1)];
    progressView.tintColor = WebViewNav_TintColor;
    progressView.trackTintColor = [UIColor whiteColor];
    progressView.progress = 0.08;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    self.webViewGoBackStatus = WebViewCanGoBackNO;
}
#pragma mark - 分享
- (void)toShareProduct{
    //调用自定义分享
    NSString *urlStr = [NSString stringWithFormat:@"%@",self.urlStr];
    NSString *sTitle = self.shareTitle.length !=0 ? self.shareTitle :self.title;
    NSString *sDes = self.shareDesStr.length !=0 ? self.shareDesStr :self.title;
    [CustomShareUI shareWithUrl:urlStr Title:sTitle DesStr:sDes];
}
//返回
-(void)itemPopBack{
    if (self.webViewGoBackStatus == WebViewCanGoBackYES) {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    if (self.webViewTitleCanTransformStatus == WebViewTitleCanTransformYES) {
        [self.webView removeObserver:self forKeyPath:@"title"];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURLRequest *request = navigationAction.request;
    NSLog(@"==========%@",request.URL);
    
    WKNavigationActionPolicy actionPol = WKNavigationActionPolicyAllow;
    decisionHandler(actionPol);
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }else if (object == self.webView && [keyPath isEqualToString:@"title"]) {
        NSLog(@">>>%@",[change objectForKey:NSKeyValueChangeNewKey]);
        self.navigationItem.title = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToString:@""] ? self.titleStr : [change objectForKey:NSKeyValueChangeNewKey];
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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
