//
//  PopWebViewController.m
//  WeiJinKe
//
//  Created by mac2015 on 15/5/7.
//  Copyright (c) 2015年 mac2015. All rights reserved.
//

#import "PopWebViewController.h"
#import "Configure.h"

@interface PopWebViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation PopWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webView= [[UIWebView alloc]initWithFrame:CGRectMake(0,0,self.view.width, self.view.height-84)];
    _webView = webView;
    webView.delegate = self;
    webView.opaque = YES;
    webView.backgroundColor = [UIColor greenColor];
    [webView setScalesPageToFit:YES];
//    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.bounces = NO;
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlstr]]];
}
-(void)popInfoUrlstr:(NSString *)urlstr
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]]];
}
-(void)popInfoHtmlstr:(NSString *)htmlstr
{
    [_webView loadHTMLString:htmlstr baseURL:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
       
    NSHTTPURLResponse *response = nil;
    if (response.statusCode == 404)
    {
        // code for 404
        return NO;
    } else if (response.statusCode == 403)
    {
        // code for 403
        return NO;
    }else if (response.statusCode == 500)
    {
        // code for 403
        return NO;
    }
    return YES;
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
