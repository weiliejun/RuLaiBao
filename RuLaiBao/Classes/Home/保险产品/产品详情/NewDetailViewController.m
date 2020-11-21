//
//  NewDetailViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/9/12.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "NewDetailViewController.h"
#import <WebKit/WebKit.h>
#import "Configure.h"
#import "AppDelegate.h"
//dealloc
#import "WeakScriptMessageDelegate.h"
/** 自定义分享 */
#import "CustomShareUI.h"
/** 加分位符 */
#import "ChangeNumber.h"
/** 产品预约 */
#import "appointmentViewController.h"
/** webView */
#import "QLWKWebViewController.h"

#import "RLBDetailNoDataTipView.h"

/** 登录页 */
#import "LoginViewController.h"


#define WebViewNav_TintColor ([UIColor orangeColor])


@interface NewDetailViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
/** 右侧搜索按钮 */
@property (nonatomic, strong) UIBarButtonItem *shareItem;

@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, weak) UIProgressView *progressView;

/** 底部视图 */
@property (nonatomic, strong) UIView *bottomView;
/** 最低保费 */
@property (nonatomic, strong) UILabel *moneyLabel;
/** 推广费 */
@property (nonatomic, strong) UILabel *feeLabel;
/** 计划书 */
@property (nonatomic, strong) UIButton *prospectusBtn;
/** 购买 */
@property (nonatomic, strong) UIButton *purchaseBtn;
/** 折叠按钮 */
@property (nonatomic, strong) UIButton *feeBtn;
/** 折叠框灰色背景 */
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, weak) RLBDetailNoDataTipView *noDetailTipView;

@end

@implementation NewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"产品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //右侧搜索按钮
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(toShareProduct)];
    self.shareItem = shareItem;
    
    //创建webView
    [self cretaeWebView];
    [self createUI];
    
    [self requestProductDetailDataWithId:self.Id];
    [self createInsuranceDetailNoDataView];
    
    
}

#pragma mark - 请求产品详情数据
- (void)requestProductDetailDataWithId:(NSString *)Id{
    WeakSelf
    [[RequestManager sharedInstance]postProductDetailWithId:Id userId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            strongSelf.infoDict = TipDic[@"data"];

            //添加推广费展示view
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self createShowFeeView];
            });
            
            
            //判断产品状态
            [self judgeProductStatus];

        }else {
            self.noDetailTipView.tipType = NoDataTipTypeRequestError;
        }
        
    } Error:^(NSError *error) {
            self.noDetailTipView.tipType = NoDataTipTypeRequestError;
    }];
}

#pragma mark - 无数据view
-(void)createInsuranceDetailNoDataView{
    RLBDetailNoDataTipView *noDetailTipView = [[RLBDetailNoDataTipView alloc]initWithFrame:self.view.frame imageName:@"NoData" tipText:KInsuranceDetailDataRemoved];
    noDetailTipView.tipType = NoDataTipTypeRequestLoading;
    noDetailTipView.tapClick = ^(NoDataTipType tipType) {
        if (tipType == NoDataTipTypeNoData) {
            if(self.noDataBlock != nil){
                self.noDataBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [self requestProductDetailDataWithId:self.Id];
        }
    };
    [self.view addSubview:noDetailTipView];
    [self.view bringSubviewToFront:noDetailTipView];
    _noDetailTipView = noDetailTipView;
}

#pragma mark - 数据删除回调
- (void)createInsuranceDetailAlertVC{
    self.noDetailTipView.tipType = NoDataTipTypeNoData;
    if ([self.infoDict[@"productStatus"] isEqualToString:@"delete"]){
        [self.noDetailTipView changeTipLabel:KInsuranceDetailDataRemoved];
        
    }else if ([self.infoDict[@"productStatus"] isEqualToString:@"down"]){
        [self.noDetailTipView changeTipLabel:KInsuranceDetailDataDown];
        
    }else {
        [self.noDetailTipView changeTipLabel:KInsuranceDetailDataNonExist];
    }
}

#pragma mark - 设置界面元素
- (void)cretaeWebView {
    //webView
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window - Height_Statusbar_NavBar)];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    
    NSString *userIdStr;
    if ([[StoreTool getUserID] isEqualToString:@""]) {
        userIdStr = @"null";
        
    }else {
        userIdStr = [StoreTool getUserID];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@://%@/product/h5/detail/%@/%@",webHttp,RequestHeader,self.Id,userIdStr];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
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
    
    //OC注册供JS调用的方法
    WeakScriptMessageDelegate *weakScriptDelegateSelf = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
    //跳转登录
    [[self.webView configuration].userContentController addScriptMessageHandler:weakScriptDelegateSelf name:@"toMyLogin"];
    
    //pdf跳转
    [[self.webView configuration].userContentController addScriptMessageHandler:weakScriptDelegateSelf name:@"toMyPDF"];
}

#pragma mark - 创建底部view
- (void)createUI {
    /** 底部view */
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Window-Height_View_HomeBar-44, Width_Window, Height_View_HomeBar+44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.hidden = NO;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 1)];
    yellowView.backgroundColor = [UIColor customLightYellowColor];
    [bottomView addSubview:yellowView];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, Width_Window-150, 20)];
    moneyLabel.text = @"0.00元起";
    moneyLabel.textColor = [UIColor customDetailColor];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    UILabel *feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, moneyLabel.bottom, Width_Window/2-10, 20)];
    feeLabel.text = @"推广费：0.00%";
    feeLabel.textColor = [UIColor customDetailColor];
    feeLabel.font = [UIFont systemFontOfSize:14];
    feeLabel.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:feeLabel];
    self.feeLabel = feeLabel;
    
    //推广费折叠view
    UIButton *feeBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.feeLabel.right, self.moneyLabel.bottom, 15, 20)];
    [feeBtn setImage:[UIImage imageNamed:@"home_product_up"] forState:UIControlStateNormal];
    [feeBtn setImage:[UIImage imageNamed:@"home_product_down"] forState:UIControlStateSelected];
    [feeBtn addTarget:self action:@selector(showFeeView:) forControlEvents:UIControlEventTouchUpInside];
    feeBtn.selected = NO;
    [self.bottomView addSubview:feeBtn];
    self.feeBtn = feeBtn;
    self.feeBtn.hidden = YES;
    
    UIButton *prospectusBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window-140, 7, 60, 30)];
    [prospectusBtn setTitle:@"计划书" forState:UIControlStateNormal];
    [prospectusBtn setTitleColor:[UIColor customLightYellowColor] forState:UIControlStateNormal];
    prospectusBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [prospectusBtn addTarget:self action:@selector(goProspectusVC:) forControlEvents:UIControlEventTouchUpInside];
    prospectusBtn.backgroundColor = [UIColor whiteColor];
    prospectusBtn.layer.masksToBounds = YES;
    prospectusBtn.layer.cornerRadius = 15;
    prospectusBtn.layer.borderWidth = 1;
    prospectusBtn.layer.borderColor = [UIColor customLightYellowColor].CGColor;
    [bottomView addSubview:prospectusBtn];
    self.prospectusBtn = prospectusBtn;
    
    UIButton *purchaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window-70, 7, 60, 30)];
    [purchaseBtn setTitle:@"购买" forState:UIControlStateNormal];
    [purchaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    purchaseBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [purchaseBtn addTarget:self action:@selector(purchaseBtn:) forControlEvents:UIControlEventTouchUpInside];
    purchaseBtn.backgroundColor = [UIColor customLightYellowColor];
    purchaseBtn.layer.masksToBounds = YES;
    purchaseBtn.layer.cornerRadius = 15;
    [bottomView addSubview:purchaseBtn];
    self.purchaseBtn = purchaseBtn;
}

/** 展示推广费view */
- (void)showFeeView:(UIButton *)btn {
    btn.selected = !btn.selected;

    if (btn.selected) {
        //展开
        [btn setImage:[UIImage imageNamed:@"home_product_down"] forState:UIControlStateSelected];
        self.bgView.hidden = NO;
        
    } else {
        //关闭
        [btn setImage:[UIImage imageNamed:@"home_product_up"] forState:UIControlStateNormal];
        self.bgView.hidden = YES;

    }
}

/** 收起推广费view */
- (void)dismissView:(UIButton *)btn {
    self.bgView.hidden = YES;
    self.feeBtn.selected = NO;
    [self.feeBtn setImage:[UIImage imageNamed:@"home_product_up"] forState:UIControlStateNormal];
}

/** 判断产品状态 */
- (void)judgeProductStatus {
    //产品状态:normal：正常；delete：已删除;down：已下架
    if ([self.infoDict[@"productStatus"] isEqualToString:@"normal"]) {
        [self.noDetailTipView removeFromSuperview];
        
        //添加分享按钮
        self.navigationItem.rightBarButtonItem = self.shareItem;
        //显示底部view
        self.bottomView.hidden = NO;
        
        //最低保费(加分位符)
        if ([self.infoDict[@"minimumPremium"] isEqualToString:@""]) {
            self.moneyLabel.text = @"--元起";
            
        }else {
            NSString *commissionStr = [NSString stringWithFormat:@"%@",self.infoDict[@"minimumPremium"]];
            NSString *changeNum = [[ChangeNumber alloc]changeNumber:commissionStr];
            self.moneyLabel.text = [NSString stringWithFormat:@"%@元起",changeNum];
        }
        
        //判断是否登录
        if ([StoreTool getLoginStates]) {
            //已登录
            //判断是否认证
            if ([StoreTool getCheckStatusForSuccess]) {
                //已认证
                //推广费   计算text的layout
                NSString *feeStr = [NSString stringWithFormat:@"推广费：%@%%",self.infoDict[@"promotionMoney"]];
                CGFloat feeWidth = [NSString sizeWithFont:[UIFont systemFontOfSize:14] Size:CGSizeMake(MAXFLOAT, 20) Str:feeStr].width;
                self.feeLabel.frame = CGRectMake(10, self.moneyLabel.bottom, feeWidth, 20);
                self.feeLabel.text = feeStr;
                
                //折叠按钮
                self.feeBtn.frame = CGRectMake(self.feeLabel.right+5, self.moneyLabel.bottom, 15, 20);
                
                //期限长短显示
                if ([self.infoDict[@"type"] isEqualToString:@"shortTermInsurance"]) {
                    //短期险(显示购买)
                    self.prospectusBtn.hidden = YES;
                    [self.purchaseBtn setTitle:@"购买" forState:UIControlStateNormal];
                    
                    //长期险点击 弹出多个推广费
                    self.feeBtn.hidden = YES;
                    
                } else {
                    //长期险(显示计划书和预约)
                    if ([self.infoDict[@"prospectusStatus"] isEqualToString:@"yes"]) {
                        //prospectusStatus  是否有计划书
                        self.prospectusBtn.hidden = NO;
                        
                    }else{
                        self.prospectusBtn.hidden = YES;
                    }
                    
                    [self.purchaseBtn setTitle:@"预约" forState:UIControlStateNormal];

                    //满足以下条件才弹出推广费view
                    //1、登录 2、认证通过 3、长期险
                    self.feeBtn.hidden = NO;
                    
                }
                
            }else{
                //已登录未认证
                //推广费
                self.feeLabel.text = @"推广费：认证可见";
                //长期险点击 弹出多个推广费
                self.feeBtn.hidden = YES;
            }
        }else {
            //未登录
            //推广费
            self.feeLabel.text = @"推广费：认证可见";
            //长期险点击 弹出多个推广费
            self.feeBtn.hidden = YES;
        }
        
    } else if ([self.infoDict[@"productStatus"] isEqualToString:@"delete"] || [self.infoDict[@"productStatus"] isEqualToString:@"down"]){
        [self createInsuranceDetailAlertVC];
        //隐藏分享按钮
        self.navigationItem.rightBarButtonItem = nil;
        //隐藏底部view
        self.bottomView.hidden = YES;
        
    }else{
        self.noDetailTipView.tipType = NoDataTipTypeRequestError;
        //隐藏分享按钮
        self.navigationItem.rightBarButtonItem = nil;
        //隐藏底部view
        self.bottomView.hidden = YES;
    }
}

#pragma mark - 分享
- (void)toShareProduct{
    //调用自定义分享
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/product/detail/share/%@",RequestHeader,self.infoDict[@"id"]];
    [CustomShareUI shareWithUrl:urlStr Title:self.infoDict[@"name"] DesStr:self.infoDict[@"recommendations"]];
}

#pragma mark - 计划书
- (void)goProspectusVC:(UIButton *)btn{
    //关闭推广费展示页
    [self dismissView:self.feeBtn];
    
    if (![StoreTool getLoginStates]) {
        //未登录时候点击列表计划书直接跳转至登录页面
        [self toMyLogin];
    }else if (![StoreTool getCheckStatusForSuccess]){
        //已登录未认证时提示：请通过认证后在进行该操作！   取消/去认证
        [JumpToSellCertifyVCTool jumpToSellCertifyVCWithFatherViewController:self];
    }else{
        //判断是否下架或删除
        if ([self.infoDict[@"productStatus"] isEqualToString:@"normal"]) {
            QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
            webVC.urlStr = self.infoDict[@"prospectus"];
            webVC.titleStr = @"计划书";
            [self.navigationController pushViewController:webVC animated:YES];

        } else if ([self.infoDict[@"productStatus"] isEqualToString:@"delete"] || [self.infoDict[@"productStatus"] isEqualToString:@"down"]){
            [self createInsuranceDetailAlertVC];

        } else {
            self.noDetailTipView.tipType = NoDataTipTypeRequestError;
        }
    }
}

#pragma mark - 购买
- (void)purchaseBtn:(UIButton *)btn{
    //关闭推广费展示页
    [self dismissView:self.feeBtn];
    
    //根据登录状态判断
    if (![StoreTool getLoginStates]) {
        //未登录时候点击列表计划书直接跳转至登录页面
        [self toMyLogin];
    }else if (![StoreTool getCheckStatusForSuccess]){
        //已登录未认证时提示：请通过认证后在进行该操作！   取消/去认证
        [JumpToSellCertifyVCTool jumpToSellCertifyVCWithFatherViewController:self];
    }else{
        //短期险（购买），长期险（预约）
        if ([self.infoDict[@"type"] isEqualToString:@"shortTermInsurance"]) {
            //判断是否下架或删除
            if ([self.infoDict[@"productStatus"] isEqualToString:@"normal"]) {
                QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
                webVC.urlStr = self.infoDict[@"productLink"];
                webVC.titleStr = @"购买";
                [self.navigationController pushViewController:webVC animated:YES];

            }else if ([self.infoDict[@"productStatus"] isEqualToString:@"delete"] || [self.infoDict[@"productStatus"] isEqualToString:@"down"]){
                [self createInsuranceDetailAlertVC];

            }else{
                self.noDetailTipView.tipType = NoDataTipTypeRequestError;

            }
        }else{
            appointmentViewController *appointmentVC = [[appointmentViewController alloc]init];
            appointmentVC.companyName = self.infoDict[@"companyName"];
            appointmentVC.productId = self.infoDict[@"id"];
            appointmentVC.productName = self.infoDict[@"name"];
            appointmentVC.productCategory = self.infoDict[@"category"];
            [self.navigationController pushViewController:appointmentVC animated:YES];
        }
    }
}

#pragma mark - OC在JS调用方法做的处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"toMyLogin"]) {
        [self toMyLogin];
    }
    
    if ([message.name isEqualToString:@"toMyPDF"]) {
//        [self toMyPDF];
        //多条pdf数据
        QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
        NSDictionary *dict = message.body;
        webVC.urlStr = [NSString stringWithFormat:@"%@",dict[@"url"]];
        webVC.titleStr = [NSString stringWithFormat:@"%@",dict[@"name"]];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

/** pdf一条数据 */
/*-(void)toMyPDF{
 QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
 webVC.urlStr = self.infoDict[@"attachmentPath"];
 webVC.titleStr = self.infoDict[@"attachmentName"];
 [self.navigationController pushViewController:webVC animated:YES];
 }*/

/** 跳转登录 */
-(void)toMyLogin{
    dispatch_async(dispatch_get_main_queue(), ^{
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailToLoginSuccess)name:KNotificationLoginSuccess object:nil];
    });
}

//登录成功接收post，更新url
-(void)detailToLoginSuccess{
    [self.noDetailTipView removeFromSuperview];
    
    NSString *userIdStr;
    if ([[StoreTool getUserID] isEqualToString:@""]) {
        userIdStr = @"null";
    }else {
        userIdStr = [StoreTool getUserID];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@://%@/product/h5/detail/%@/%@",webHttp,RequestHeader,self.Id,userIdStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    [self judgeProductStatus];
}

-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"toMyLogin"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"toMyPDF"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationLoginSuccess object:nil];
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
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - 懒加载推广费view
- (UIView *)bgView{
    if (_bgView == nil) {
        //灰色背景
        //self方法实际上是用了get和set方法间接调用，下划线方法是直接对变量操作
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, Height_Window-Height_View_HomeBar-44)];
        bgView.backgroundColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:0.5];
        [self.navigationController.view addSubview:bgView];
        [self.navigationController.view bringSubviewToFront:bgView];
        
        UIView *feeView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.bottom-300, Width_Window, 300)];
        feeView.backgroundColor = [UIColor whiteColor];
        feeView.alpha = 1.0;
        [bgView addSubview:feeView];
        
        //取消按钮
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window-60, 5, 40, 40)];
        [cancelBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
        [feeView addSubview:cancelBtn];
        
        //判断推广费个数
        NSString *str = [NSString stringWithFormat:@"%@",self.infoDict[@"promotionMoney"]];
        NSString *str2 = [NSString stringWithFormat:@"%@",self.infoDict[@"promotionMoney2"]];
        NSString *str3 = [NSString stringWithFormat:@"%@",self.infoDict[@"promotionMoney3"]];
        NSString *str4 = [NSString stringWithFormat:@"%@",self.infoDict[@"promotionMoney4"]];
        NSString *str5 = [NSString stringWithFormat:@"%@",self.infoDict[@"promotionMoney5"]];
        
        NSMutableArray *titleArr = [NSMutableArray arrayWithCapacity:10];
        
        if (![str isEqualToString:@""]) {
            [titleArr addObject:[NSString stringWithFormat:@"第一年推广费：%@%%",str]];
        }
        if (![str2 isEqualToString:@""]) {
            [titleArr addObject:[NSString stringWithFormat:@"第二年推广费：%@%%",str2]];
        }
        if (![str3 isEqualToString:@""]) {
            [titleArr addObject:[NSString stringWithFormat:@"第三年推广费：%@%%",str3]];
        }
        if (![str4 isEqualToString:@""]) {
            [titleArr addObject:[NSString stringWithFormat:@"第四年推广费：%@%%",str4]];
        }
        if (![str5 isEqualToString:@""]) {
            [titleArr addObject:[NSString stringWithFormat:@"第五年推广费：%@%%",str5]];
        }
        //    NSLog(@"titleArr == %@",titleArr);
        
        for (int i = 0; i < titleArr.count; i++) {
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, 50*(i+1), Width_Window-40, 1)];
            line.backgroundColor = [UIColor customLineColor];
            [feeView addSubview:line];
            
            UILabel *percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50*(i+1), Width_Window-40, 50)];
            percentLabel.text = titleArr[i];
            percentLabel.textColor = [UIColor customTitleColor];
            percentLabel.textAlignment = NSTextAlignmentCenter;
            percentLabel.font = [UIFont systemFontOfSize:17];
            [feeView addSubview:percentLabel];
        }
        
        feeView.frame = CGRectMake(0, bgView.bottom-50*(titleArr.count+1), Width_Window, 50*(titleArr.count+1));
        
        _bgView = bgView;
        _bgView.hidden = YES;
    }
    return _bgView;
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
