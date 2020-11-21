//
//  AppointmentDetailViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/17.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "AppointmentDetailViewController.h"
#import "Configure.h"
#import "DetailLabel.h"
//保险产品详情
//#import "InsuranceDetailViewController.h"
#import "NewDetailViewController.h"
//无数据
#import "RLBDetailNoDataTipView.h"


@interface AppointmentDetailViewController ()<UIScrollViewDelegate,UITextViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *warningView;//提示信息
@property (nonatomic, weak) UIButton *cancelBtn;//取消预约
@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, weak) RLBDetailNoDataTipView *noDetailTipView;

@end

@implementation AppointmentDetailViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //取消performSelector
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(recordAotoStop) object:@"stopRecord"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"预约详情";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self requestAppointDetailDataWithId:self.Id];
}

#pragma mark - 请求预约详情数据
- (void)requestAppointDetailDataWithId:(NSString *)Id{
    WeakSelf
    [[RequestManager sharedInstance]postAppointDetailWithId:Id Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            strongSelf.infoDict = TipDic[@"data"];
            [self createUI];
           
        }else{
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
        }
    } Error:^(NSError *error) {
          [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar)];
    scrollView.backgroundColor = [UIColor customBackgroundColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //详情
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Width_Window, 200)];
    detailView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:detailView];
    
    UIControl *productCtl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 50)];
    productCtl.backgroundColor = [UIColor clearColor];
    [productCtl addTarget:self action:@selector(goToProduct) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:productCtl];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, Width_Window-40, 20)];
    nameLabel.text = [NSString stringWithFormat:@"%@",self.infoDict[@"productName"]];
    nameLabel.textColor = [UIColor customTitleColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:18];
    [productCtl addSubview:nameLabel];
    
    // 右侧箭头
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(Width_Window - 18, 18, 8, 14)];
    arrowImage.contentMode = UIViewContentModeScaleAspectFill;
    arrowImage.image = [UIImage imageNamed:@"arrow_r"];
    [productCtl addSubview:arrowImage];
    
    //横线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, productCtl.bottom, Width_Window, 1)];
    line.backgroundColor = [UIColor customLineColor];
    [detailView addSubview:line];
    
    //1>预约状态
    DetailLabel *typeLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, productCtl.bottom+20, 65, 20) text:@"预约状态:" fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:typeLabel];
    NSString *turnStr;
    if ([self.infoDict[@"auditStatus"] isEqualToString:@"confirming"]) {
        turnStr = @"待确认";
    }else if ([self.infoDict[@"auditStatus"] isEqualToString:@"confirmed"]){
        turnStr = @"已确认";
    }else if ([self.infoDict[@"auditStatus"] isEqualToString:@"refuse"]){
        turnStr = @"已驳回";
    }else if ([self.infoDict[@"auditStatus"] isEqualToString:@"canceled"]){
        turnStr = @"已取消";
    }else {
        turnStr = [NSString stringWithFormat:@"%@",self.infoDict[@"auditStatus"]];
    }
    
    DetailLabel *typeValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(typeLabel.right+5, productCtl.bottom+20,  Width_Window-typeLabel.right-20, 20) text:turnStr fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:typeValueLabel];
    //2>预约时间
    DetailLabel *startTimeLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, typeValueLabel.bottom+20, 65, 20) text:@"预约时间:" fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:startTimeLabel];
    DetailLabel *startTimeValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(startTimeLabel.right+5, typeValueLabel.bottom+20,  Width_Window-startTimeLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"createTime"]] fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:startTimeValueLabel];
    //3>预约人
    DetailLabel *detailNameLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, startTimeValueLabel.bottom+20, 65, 20) text:@"预约人:" fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:detailNameLabel];
    DetailLabel *detailNameValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(detailNameLabel.right+5, startTimeValueLabel.bottom+20,  Width_Window-detailNameLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"userName"]] fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:detailNameValueLabel];
    //4>预约电话
    DetailLabel *numberIdLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, detailNameValueLabel.bottom+20, 65, 20) text:@"预约电话:" fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:numberIdLabel];
    DetailLabel *numberIdValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(numberIdLabel.right+5, detailNameValueLabel.bottom+20,  Width_Window-numberIdLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"mobile"]] fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:numberIdValueLabel];
    //5>保险公司
    DetailLabel *customerNameLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, numberIdValueLabel.bottom+20, 65, 20) text:@"保险公司:" fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:customerNameLabel];
    DetailLabel *customerNameValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(customerNameLabel.right+5, numberIdValueLabel.bottom+20,  Width_Window-customerNameLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"companyName"]]  fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:customerNameValueLabel];
    //6>保险计划
    DetailLabel *idNumberLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, customerNameValueLabel.bottom+20, 65, 20) text:@"保险计划:" fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:idNumberLabel];
    DetailLabel *idNumberValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(idNumberLabel.right+5, customerNameValueLabel.bottom+20,  Width_Window-idNumberLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"insurancePlan"]] fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:idNumberValueLabel];
    //7>保险金额
    DetailLabel *timeLimitLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, idNumberValueLabel.bottom+20, 65, 20) text:@"保险金额:" fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:timeLimitLabel];
    DetailLabel *timeLimitValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(timeLimitLabel.right+5, idNumberValueLabel.bottom+20,  Width_Window-timeLimitLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"insuranceAmount"]] fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:timeLimitValueLabel];
    //8>年缴保费
    DetailLabel *payLimitLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, timeLimitValueLabel.bottom+20, 65, 20) text:@"年缴保费:" fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:payLimitLabel];
    DetailLabel *payLimitValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(payLimitLabel.right+5, timeLimitValueLabel.bottom+20,  Width_Window-payLimitLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"periodAmount"]] fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:payLimitValueLabel];
    //9>保险期限
    DetailLabel *continueDateLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, payLimitValueLabel.bottom+20, 65, 20) text:@"保险期限:" fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:continueDateLabel];
    DetailLabel *continueDateValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(continueDateLabel.right+5, payLimitValueLabel.bottom+20,  Width_Window-continueDateLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"insurancePeriod"]] fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:continueDateValueLabel];
    //10>缴费期限
    DetailLabel *giveMoneyLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, continueDateValueLabel.bottom+20, 65, 20) text:@"缴费期限:" fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:giveMoneyLabel];
    DetailLabel *giveMoneyValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(giveMoneyLabel.right+5, continueDateValueLabel.bottom+20,  Width_Window-giveMoneyLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"paymentPeriod"]] fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:giveMoneyValueLabel];
    //11>预计交单
    DetailLabel *popularizeFeeLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, giveMoneyValueLabel.bottom+20, 65, 20) text:@"预计交单:" fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:popularizeFeeLabel];
    DetailLabel *popularizeFeeValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(popularizeFeeLabel.right+5, giveMoneyValueLabel.bottom+20,  Width_Window-popularizeFeeLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"exceptSubmitTime"]] fontSize:14 textColor:[UIColor customDetailColor]];
    [detailView addSubview:popularizeFeeValueLabel];
    
    //重新设置detailView.frame
    detailView.frame = CGRectMake(0, 10, Width_Window,popularizeFeeValueLabel.bottom+10);
    
    //备注
    UIView *remarkView = [[UIView alloc]initWithFrame:CGRectMake(0, detailView.bottom+10, Width_Window, 200)];
    remarkView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:remarkView];
    
    UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Width_Window-20, 20)];
    remarkLabel.text = @"备注说明";
    remarkLabel.textAlignment = NSTextAlignmentCenter;
    remarkLabel.textColor = [UIColor customTitleColor];
    remarkLabel.font = [UIFont systemFontOfSize:16];
    [remarkView addSubview: remarkLabel];
    
    UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(10, remarkLabel.bottom+10, Width_Window-20, 200)];
    textView.backgroundColor =[UIColor whiteColor];
    textView.text = [NSString stringWithFormat:@"%@",self.infoDict[@"remark"]];
    textView.textColor = [UIColor customDetailColor];
    textView.font = [UIFont systemFontOfSize:14];
    textView.userInteractionEnabled = NO;
    [remarkView addSubview:textView];
    
    //取消预约
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Window-Height_View_HomeBar-44, Width_Window, Height_View_HomeBar+44)];
    bottomView.backgroundColor = [UIColor customLightYellowColor];
    [self.view addSubview:bottomView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 44)];
    [cancelBtn setTitle:@"取消预约" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor customLightYellowColor];
    [cancelBtn addTarget:self action:@selector(cancelAppointBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    bottomView.hidden = YES;
//    //判断取消按钮是否显示
//    if ([self.infoDict[@"auditStatus"] isEqualToString:@"confirming"]){
//        //待确认状时显示
//        bottomView.hidden = NO;
//    }else{
//        //其他情况不显示
//        bottomView.hidden = YES;
//    }
//
    //提示信息
    UIView *warningView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, 50)];
    warningView.backgroundColor = [UIColor customRedColor];
    [self.view addSubview:warningView];
    self.warningView = warningView;
    
    NSString *str = [NSString stringWithFormat:@"%@",self.infoDict[@"refuseReason"]];
    CGFloat warningHeight = [NSString sizeWithFont:[UIFont systemFontOfSize:16] Size:CGSizeMake(Width_Window-40, MAXFLOAT) Str:str].height;
    UILabel *warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, Width_Window-40, warningHeight)];
    warningLabel.textColor = [UIColor whiteColor];
    warningLabel.font = [UIFont systemFontOfSize:16];
    warningLabel.numberOfLines = 0;
    [warningView addSubview:warningLabel];
    
    self.warningView.frame = CGRectMake(0, Height_Statusbar_NavBar, Width_Window, warningLabel.bottom+15);
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window-30, 15, 20, 20)];
    [cancleBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [warningView addSubview:cancleBtn];
    
    //判断是否有提示信息、备注、取消按钮
    if (![self.infoDict[@"auditStatus"] isEqualToString:@"refuse"]){
        //无提示信息
        self.warningView.hidden = YES;
        self.scrollView.frame = CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar);
        //备注是否显示
        if ([self.infoDict[@"remark"] isEqualToString:@""]) {
            //无备注
            remarkView.hidden = YES;
            scrollView.contentSize = CGSizeMake(Width_Window, detailView.bottom+10+44);
            
        }else{//有备注
            remarkView.hidden = NO;
            scrollView.contentSize = CGSizeMake(Width_Window, remarkView.bottom+10+44);
        }
        
        //判断取消按钮是否显示
        if ([self.infoDict[@"auditStatus"] isEqualToString:@"confirming"]){
            //待确认状时显示
            bottomView.hidden = NO;
        }else{
            //其他情况不显示
            bottomView.hidden = YES;
        }
        
    }else{//有提示信息（驳回的有提示信息）
        self.warningView.hidden = NO;
        self.scrollView.frame =  CGRectMake(0, self.warningView.bottom, Width_Window, Height_Window-Height_Statusbar_NavBar);
        //无驳回信息时 显示：暂无驳回信息。｛XXXX-XX-XX｝
        if ([str isEqualToString:@""]) {
            warningLabel.text = [NSString stringWithFormat:@"暂无驳回信息。{%@}",self.infoDict[@"auditTime"]];
        }else{
            warningLabel.text = [NSString stringWithFormat:@"%@。{%@}",str,self.infoDict[@"auditTime"]];
        }
        
        if ([self.infoDict[@"remark"] isEqualToString:@""]) {
            //无备注时不显示
            remarkView.hidden = YES;
            scrollView.contentSize = CGSizeMake(Width_Window, self.warningView.bottom+detailView.bottom+10);
        }else{//有备注时显示
            remarkView.hidden = NO;
            scrollView.contentSize = CGSizeMake(Width_Window, self.warningView.bottom+remarkView.bottom+10);
        }
    }
}

#pragma mark - 取消预约
- (void)cancelAppointBtn:(UIButton *)btn{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确定取消预约吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *certifyAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //请求取消预约接口
        [self requestCancelAppointDataWithId:self.Id];
    }];
    //    [cancelction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    [alertVC addAction:certifyAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 请求取消预约接口
- (void)requestCancelAppointDataWithId:(NSString *)Id{
    [[RequestManager sharedInstance]postCancelAppointWithId:Id Success:^(id responseData) {
        self.cancelBtn.userInteractionEnabled = NO;
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                self.cancelBtn.userInteractionEnabled = NO;
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
                //延时1秒返回到预约列表
                [self performSelector:@selector(recordAotoStop) withObject:@"stopRecord" afterDelay:1.0];

            }else{
                self.cancelBtn.userInteractionEnabled = YES;
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
            }
        }else{
            self.cancelBtn.userInteractionEnabled = YES;
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
        }
    } Error:^(NSError *error) {
        self.cancelBtn.userInteractionEnabled = YES;
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

//延时1秒返回到预约列表
- (void)recordAotoStop{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 取消提示框
- (void)cancelBtn:(UIButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        self.warningView.alpha = 0.0;
        self.scrollView.frame = CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar);
        
    } completion:^(BOOL finished) {
        [self.warningView removeFromSuperview];
    }];
    
}

#pragma mark - 产品
- (void)goToProduct{
//    InsuranceDetailViewController *detailVC = [[InsuranceDetailViewController alloc]init];
//    detailVC.Id = self.infoDict[@"productId"];
//    [self.navigationController pushViewController:detailVC animated:YES];
    NewDetailViewController *newDetailVC = [[NewDetailViewController alloc]init];
    newDetailVC.Id = self.infoDict[@"productId"];
    [self.navigationController pushViewController:newDetailVC animated:YES];
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
