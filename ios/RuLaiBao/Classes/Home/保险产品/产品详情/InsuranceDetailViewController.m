//
//  InsuranceDetailViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/2.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "InsuranceDetailViewController.h"
#import "Configure.h"
/**  顶部视图 */
#import "HeaderView.h"
#import "InsuranceDetailModel.h"
/** 展开/折叠View */
#import "FoldView.h"
/** 自定义分享 */
#import "CustomShareUI.h"
/** 加分位符 */
#import "ChangeNumber.h"
/** webView */
#import "QLWKWebViewController.h"
/** 产品预约 */
#import "appointmentViewController.h"
/** 销售认证 */
//#import "SellCertifyViewController.h"
/** 无数据 */
#import "RLBDetailNoDataTipView.h"


@interface InsuranceDetailViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HeaderView *headerView;
/** 折叠的五项View */
@property (nonatomic, weak) FoldView *foldView1;
@property (nonatomic, weak) FoldView *foldView2;
@property (nonatomic, weak) FoldView *foldView3;
@property (nonatomic, weak) FoldView *foldView4;
@property (nonatomic, weak) FoldView *foldView5;

/** 最低保费 */
@property (nonatomic, strong) UILabel *moneyLabel;
/** 推广费 */
@property (nonatomic, strong) UILabel *feeLabel;
/** 计划书 */
@property (nonatomic, strong) UIButton *prospectusBtn;
/** 购买 */
@property (nonatomic, strong) UIButton *purchaseBtn;

@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, strong) InsuranceDetailModel *model;

@property (nonatomic, strong) NSDictionary *collectionDict;
/** 收藏状态 */
@property (nonatomic, strong) NSString *dataStatus;
/** 收藏id */
@property (nonatomic, strong) NSString *collectionId;

@property (nonatomic, weak) RLBDetailNoDataTipView *noDetailTipView;

@end

@implementation InsuranceDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestProductDetailDataWithId:self.Id];
    
    //请求页
    [self createInsuranceDetailNoDataView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"产品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    //右侧搜索按钮
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(toShareProduct)];
    self.navigationItem.rightBarButtonItem = shareItem;
    [self createUI];
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

#pragma mark - 请求产品详情数据
- (void)requestProductDetailDataWithId:(NSString *)Id{
    WeakSelf
    [[RequestManager sharedInstance]postProductDetailWithId:Id userId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            strongSelf.infoDict = TipDic[@"data"];
            
            //产品状态:normal：正常；delete：已删除;down：已下架
            if ([strongSelf.infoDict[@"productStatus"] isEqualToString:@"normal"]) {
                [strongSelf.noDetailTipView removeFromSuperview];
                strongSelf.model = [InsuranceDetailModel insuranceDetailModelWithDictionary:strongSelf.infoDict];
                
                //动态设置headerView高度
                NSString *recommendStr = [NSString stringWithFormat:@"%@",strongSelf.model.recommendations];
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:recommendStr];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 3.0;
                [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, recommendStr.length)];
                [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, recommendStr.length)];
                NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
                CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(Width_Window-20, MAXFLOAT) options:options context:nil];
                CGFloat warnHeight = rect.size.height+5;
                CGFloat Height = warnHeight > 20 ? warnHeight : 20;
                self.headerView.frame = CGRectMake(0, 0, Width_Window, 280+Height);
                [strongSelf.headerView setLabelWithInfoDict:strongSelf.model];
                
                //设置中间view数据
                self.foldView1.urlStr = [NSString stringWithFormat:@"%@",self.infoDict[@"securityResponsibility"]];
                self.foldView2.urlStr = [NSString stringWithFormat:@"%@",self.infoDict[@"coverNotes"]];
                self.foldView3.urlStr = [NSString stringWithFormat:@"%@",self.infoDict[@"dataTerms"]];
                self.foldView4.urlStr = [NSString stringWithFormat:@"%@",self.infoDict[@"claimProcess"]];
                self.foldView5.urlStr = [NSString stringWithFormat:@"%@",self.infoDict[@"commonProblem"]];
                
                //最低保费(加分位符)
                NSString *commissionStr = [NSString stringWithFormat:@"%@",self.infoDict[@"minimumPremium"]];
                NSString *changeNum = [[ChangeNumber alloc]changeNumber:commissionStr];
                strongSelf.moneyLabel.text = [NSString stringWithFormat:@"%@元起",changeNum];
                
                //判断是否登录
                if ([StoreTool getLoginStates]) {
                    //判断是否认证
                    if ([StoreTool getCheckStatusForSuccess]) {
                        //推广费
                        strongSelf.feeLabel.text = [NSString stringWithFormat:@"推广费：%@%%",strongSelf.infoDict[@"promotionMoney"]];
                    }else{
                        //推广费
                        strongSelf.feeLabel.text = @"推广费：认证可见";
                    }
                }else {
                    //推广费
                    strongSelf.feeLabel.text = @"推广费：认证可见";
                }
                
                //期限长短显示
                if ([strongSelf.infoDict[@"type"] isEqualToString:@"shortTermInsurance"]) {
                    //短期险
                    if ([strongSelf.infoDict[@"prospectusStatus"] isEqualToString:@"yes"]) {
                        //prospectusStatus  是否有计划书
                        strongSelf.prospectusBtn.hidden = NO;
                        
                    }else{
                        strongSelf.prospectusBtn.hidden = YES;
                        
                    }
                    
                    [strongSelf.purchaseBtn setTitle:@"购买" forState:UIControlStateNormal];
                }else{
                    //长期险
                    strongSelf.prospectusBtn.hidden = YES;
                    [strongSelf.purchaseBtn setTitle:@"预约" forState:UIControlStateNormal];
                }
                //设置收藏状态
                if ([strongSelf.infoDict[@"collectionDataStatus"] isEqualToString:@"invalid"]) {
                    strongSelf.dataStatus = @"valid";
                    
                }else{
                    strongSelf.dataStatus = @"invalid";
                }
                strongSelf.collectionId = strongSelf.infoDict[@"collectionId"];
                
            }else if ([strongSelf.infoDict[@"productStatus"] isEqualToString:@"delete"] || [strongSelf.infoDict[@"productStatus"] isEqualToString:@"down"]){
                [strongSelf createInsuranceDetailAlertVC];
                
            }else{
                self.noDetailTipView.tipType = NoDataTipTypeRequestError;
                
            }
            
        }else{
            self.noDetailTipView.tipType = NoDataTipTypeRequestError;
        }
        
    } Error:^(NSError *error) {
        self.noDetailTipView.tipType = NoDataTipTypeRequestError;
    }];
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

#pragma mark - 请求收藏，取消收藏数据
- (void)requestCollectionDataWithProductId:(NSString *)productId dataStatus:(NSString *)dataStatus{
    WeakSelf
    [[RequestManager sharedInstance]postCollectionWithDataStatus:dataStatus collectionId:self.collectionId productId:productId userId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                strongSelf.collectionDict = TipDic[@"data"];
                [strongSelf.headerView setCollectionWithInfoDict:strongSelf.collectionDict];
                
                if ([strongSelf.collectionDict[@"dataStatus"] isEqualToString:@"invalid"]) {
                    strongSelf.dataStatus = @"valid";
                    
                }else{
                    strongSelf.dataStatus = @"invalid";
                    
                }
                strongSelf.collectionId = strongSelf.collectionDict[@"collectionId"];
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",self.collectionDict[@"message"]]];
            }else{
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
            }
            
        }else{
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
        }
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor customBackgroundColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    /** 头部 */
    HeaderView *headerView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 370)];
    headerView.backgroundColor = [UIColor customBackgroundColor];
    [scrollView addSubview:headerView];
    self.headerView = headerView;
    [headerView setBtnClickBlock:^(NSString *pid) {
        //收藏按钮点击事件
        //判断是否登录
        if (![StoreTool getLoginStates]) {
            //未登录时候点击列表计划书直接跳转至登录页面
            [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
        }else if (![StoreTool getCheckStatusForSuccess]){
            //已登录未认证时提示：请通过认证后在进行该操作！   取消/去认证
            [JumpToSellCertifyVCTool jumpToSellCertifyVCWithFatherViewController:self];
            
        }else{
            //判断是否下架或删除
            if ([self.infoDict[@"productStatus"] isEqualToString:@"normal"]) {
                [self requestCollectionDataWithProductId:self.infoDict[@"id"] dataStatus:self.dataStatus];
                
            }else if ([self.infoDict[@"productStatus"] isEqualToString:@"delete"] || [self.infoDict[@"productStatus"] isEqualToString:@"down"] || [self.infoDict[@"productStatus"] isEqualToString:@"nonExistent"]){
                [self createInsuranceDetailAlertVC];
                
            }else{
                self.noDetailTipView.tipType = NoDataTipTypeRequestError;
                
            }
        }
    }];
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(scrollView, self);
    
    /** 中间五个view */
    [self createFlodView];
    [self createlayout];
    
    /** 底部view */
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Window-Height_View_HomeBar-44, Width_Window, Height_View_HomeBar+44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
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
    
    UILabel *feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, moneyLabel.bottom, Width_Window-150, 20)];
    feeLabel.text = @"推广费：0.00%";
    feeLabel.textColor = [UIColor customDetailColor];
    feeLabel.font = [UIFont systemFontOfSize:14];
    feeLabel.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:feeLabel];
    self.feeLabel = feeLabel;
    
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

//创建折叠展开的5个view
- (void)createFlodView{
    FoldView *foldView1 = [[FoldView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 44)];
    foldView1.backgroundColor = [UIColor whiteColor];
    foldView1.titleStr = @"保障责任";
    foldView1.urlStr = @"";
    [self.scrollView addSubview:foldView1];
    self.foldView1 = foldView1;
    
    FoldView *foldView2 = [[FoldView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 44)];
    foldView2.backgroundColor = [UIColor whiteColor];
    foldView2.titleStr = @"投保须知";
    foldView2.urlStr = @"";
    [self.scrollView addSubview:foldView2];
    self.foldView2 = foldView2;
    
    FoldView *foldView3 = [[FoldView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 44)];
    foldView3.backgroundColor = [UIColor whiteColor];
    foldView3.titleStr = @"条款资料";
    foldView3.urlStr = @"";
    [self.scrollView addSubview:foldView3];
    self.foldView3 = foldView3;
    
    FoldView *foldView4 = [[FoldView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 44)];
    foldView4.backgroundColor = [UIColor whiteColor];
    foldView4.titleStr = @"理赔流程";
    foldView4.urlStr = @"";
    [self.scrollView addSubview:foldView4];
    self.foldView4 = foldView4;
    
    FoldView *foldView5 = [[FoldView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 44)];
    foldView5.backgroundColor = [UIColor whiteColor];
    foldView5.titleStr = @"常见问题";
    foldView5.urlStr = @"";
    [self.scrollView addSubview:foldView5];
    self.foldView5 = foldView5;
}

- (void)createlayout {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(Height_Statusbar_NavBar);
        make.bottom.mas_equalTo(self.view).offset(-(Height_View_HomeBar+44));
    }];
    
    [self.foldView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(10.f);
        make.left.equalTo(self.headerView).offset(0);
        make.right.equalTo(self.headerView).offset(0);
        make.height.mas_equalTo(44);
        //        make.bottom.equalTo(self.scrollView).offset(-10);
        //        设置与容器View底部高度固定，contentLabel高度变化的时候，由于设置了容器View的高度动态变化，底部距离固定。 此时contentView的高度变化之后，ScrollView的contentSize就发生了变化，适配文字内容，滑动查看超出屏幕文字。
        //        make.height.greaterThanOrEqualTo(@16.f);//高度动态变化 大于等于16
    }];
    
    [self.foldView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.foldView1.mas_bottom).offset(10.f);
        make.left.equalTo(self.headerView).offset(0);
        make.right.equalTo(self.headerView).offset(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.foldView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.foldView2.mas_bottom).offset(10.f);
        make.left.equalTo(self.headerView).offset(0);
        make.right.equalTo(self.headerView).offset(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.foldView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.foldView3.mas_bottom).offset(10.f);
        make.left.equalTo(self.headerView).offset(0);
        make.right.equalTo(self.headerView).offset(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.foldView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.foldView4.mas_bottom).offset(10.f);
        make.left.equalTo(self.headerView).offset(0);
        make.right.equalTo(self.headerView).offset(0);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-10);
    }];
}

#pragma mark - 计划书
- (void)goProspectusVC:(UIButton *)btn{
    if (![StoreTool getLoginStates]) {
        //未登录时候点击列表计划书直接跳转至登录页面
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
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
            
        }else if ([self.infoDict[@"productStatus"] isEqualToString:@"delete"] || [self.infoDict[@"productStatus"] isEqualToString:@"down"]){
            [self createInsuranceDetailAlertVC];
            
        }else{
            self.noDetailTipView.tipType = NoDataTipTypeRequestError;
        }
    }
}

#pragma mark - 购买
- (void)purchaseBtn:(UIButton *)btn{
    //根据登录状态判断
    if (![StoreTool getLoginStates]) {
        //未登录时候点击列表计划书直接跳转至登录页面
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
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

#pragma mark - 分享
- (void)toShareProduct{
    //调用自定义分享
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/product/detail/share/%@",RequestHeader,self.infoDict[@"id"]];
    [CustomShareUI shareWithUrl:urlStr Title:self.infoDict[@"name"] DesStr:self.infoDict[@"recommendations"]];
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
