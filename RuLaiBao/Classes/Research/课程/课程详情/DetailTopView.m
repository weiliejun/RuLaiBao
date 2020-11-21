//
//  DetailTopView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "DetailTopView.h"
#import <WebKit/WebKit.h>

@interface DetailTopView()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, weak) WKWebView *wkWebView;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation DetailTopView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}
-(void)setUrlStr:(NSString *)urlStr{
    if (urlStr.length == 0) {
        return;
    }
//    NSString *urlStr = @"https://v.qq.com/iframe/player.html?vid=p0541z0e6k3&tiny=0&auto=0"; //腾讯视频链接
    /** 腾讯视频 */
    _urlStr =[NSString stringWithFormat:@"<iframe frameborder= \"0\" width=\"100%%\" height=\"96%%\" src=\"%@\" allowfullscreen></iframe>",urlStr];
    [self.wkWebView loadHTMLString:_urlStr baseURL:nil];
}
- (void)reloadWebViewUrl{
    [self.wkWebView loadHTMLString:_urlStr baseURL:nil];
}

#pragma mark - 设置界面元素
- (void)createUI{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.allowsInlineMediaPlayback = YES;
    WKWebView *wkWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) configuration:configuration];
    wkWebview.UIDelegate = self;
    wkWebview.navigationDelegate = self;
    wkWebview.opaque = NO;
    wkWebview.backgroundColor = [UIColor blackColor];
    wkWebview.scrollView.scrollEnabled = NO;
    [self addSubview: wkWebview];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"YX_KC_Video"];
    [self addSubview:imageView];
    
    _wkWebView = wkWebview;
    _imageView = imageView;
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURLRequest *request = navigationAction.request;
    NSLog(@"==========%@",request.URL);
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@",request.URL];
    if([requestUrlStr containsString:@"v.youku.com/v_show"]){
        decisionHandler(WKNavigationActionPolicyCancel);//不允许跳转
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
}
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
//    _imageView.image = [UIImage imageNamed:@"YX_KC_Video"];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_imageView removeFromSuperview];;
    _imageView = nil;
}
-(void)dealloc{
    [_wkWebView removeFromSuperview];
    _wkWebView = nil;
}

@end
