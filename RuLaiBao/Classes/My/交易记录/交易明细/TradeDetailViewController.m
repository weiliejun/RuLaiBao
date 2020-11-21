//
//  TradeDetailViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "TradeDetailViewController.h"
#import "Configure.h"
#import "DetailLabel.h"

@interface TradeDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSDictionary *infoDict;
//@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, weak) DetailLabel *typeValueLabel;

@end

@implementation TradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"交易明细";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self requestTradeDetailData];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar+10, Width_Window, Height_Window-Height_Statusbar_NavBar)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, Width_Window-20, 30)];
    moneyLabel.text = [NSString stringWithFormat:@"+%@",self.infoDict[@"commissionGained"]];
    moneyLabel.textColor = [UIColor blackColor];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.font = [UIFont systemFontOfSize:40];
    [scrollView addSubview:moneyLabel];
    
    //1>账单类型
    DetailLabel *typeLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, moneyLabel.bottom+50, 70, 20) text:@"账单类型:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:typeLabel];
    NSString *typeStr = [NSString stringWithFormat:@"%@",self.infoDict[@"orderType"]];
    DetailLabel *typeValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(typeLabel.right+5, moneyLabel.bottom+50,  Width_Window-typeLabel.right-20, 20) text:typeStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:typeValueLabel];
    self.typeValueLabel = typeValueLabel;
    
    //2>承保时间
    DetailLabel *startTimeLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, typeValueLabel.bottom+20, 70, 20) text:@"承保时间:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:startTimeLabel];
    NSString *startTimeStr = [NSString stringWithFormat:@"%@",self.infoDict[@"underwirteTime"]];
    DetailLabel *startTimeValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(startTimeLabel.right+5, typeValueLabel.bottom+20,  Width_Window-startTimeLabel.right-20, 20) text:startTimeStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:startTimeValueLabel];
    //3>产品名称
    DetailLabel *nameLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, startTimeValueLabel.bottom+20, 70, 20) text:@"产品名称:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:nameLabel];
    NSString *nameStr = [NSString stringWithFormat:@"%@",self.infoDict[@"productName"]];
    DetailLabel *nameValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(nameLabel.right+5, startTimeValueLabel.bottom+20,  Width_Window-nameLabel.right-20, 20) text:nameStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:nameValueLabel];
    //4>保单编号
    DetailLabel *numberIdLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, nameValueLabel.bottom+20, 70, 20) text:@"保单编号:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:numberIdLabel];
    NSString *numberIdStr = [NSString stringWithFormat:@"%@",self.infoDict[@"orderCode"]];
    DetailLabel *numberIdValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(numberIdLabel.right+5, nameValueLabel.bottom+20,  Width_Window-numberIdLabel.right-20, 20) text:numberIdStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:numberIdValueLabel];
    //5>客户姓名
    DetailLabel *customerNameLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, numberIdValueLabel.bottom+20, 70, 20) text:@"客户姓名:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:customerNameLabel];
    NSString *customerNameStr = [NSString stringWithFormat:@"%@",self.infoDict[@"customerName"]];
    DetailLabel *customerNameValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(customerNameLabel.right+5, numberIdValueLabel.bottom+20,  Width_Window-customerNameLabel.right-20, 20) text:customerNameStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:customerNameValueLabel];
    //6>身份证号
    DetailLabel *idNumberLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, customerNameValueLabel.bottom+20, 70, 20) text:@"身份证号:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:idNumberLabel];
    NSString *idNumberStr = [NSString stringWithFormat:@"%@",self.infoDict[@"idNo"]];
    DetailLabel *idNumberValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(idNumberLabel.right+5, customerNameValueLabel.bottom+20,  Width_Window-idNumberLabel.right-20, 20) text:idNumberStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:idNumberValueLabel];
    //7>保险期限
    DetailLabel *timeLimitLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, idNumberValueLabel.bottom+20, 70, 20) text:@"保险期限:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:timeLimitLabel];
    NSString *timeLimitStr = [NSString stringWithFormat:@"%@",self.infoDict[@"insurancePeriod"]];
    DetailLabel *timeLimitValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(timeLimitLabel.right+5, idNumberValueLabel.bottom+20,  Width_Window-timeLimitLabel.right-20, 20) text:timeLimitStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:timeLimitValueLabel];
    //8>缴费期限
    DetailLabel *payLimitLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, timeLimitValueLabel.bottom+20, 70, 20) text:@"缴费期限:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:payLimitLabel];
    NSString *payLimitStr = [NSString stringWithFormat:@"%@",self.infoDict[@"paymentPeriod"]];
    DetailLabel *payLimitValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(payLimitLabel.right+5, timeLimitValueLabel.bottom+20,  Width_Window-payLimitLabel.right-20, 20) text:payLimitStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:payLimitValueLabel];
    //9>续费日期
    DetailLabel *continueDateLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, payLimitValueLabel.bottom+20, 70, 20) text:@"续费日期:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:continueDateLabel];
    NSString *continueDateStr = [NSString stringWithFormat:@"%@",self.infoDict[@"renewalDate"]];
    DetailLabel *continueDateValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(continueDateLabel.right+5, payLimitValueLabel.bottom+20,  Width_Window-continueDateLabel.right-20, 20) text:continueDateStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:continueDateValueLabel];
    //10>已交保费
    DetailLabel *giveMoneyLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, continueDateValueLabel.bottom+20, 70, 20) text:@"已交保费:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:giveMoneyLabel];
    NSString *giveMoneyStr = [NSString stringWithFormat:@"%@元",self.infoDict[@"paymentedPremiums"]];
    DetailLabel *giveMoneyValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(giveMoneyLabel.right+5, continueDateValueLabel.bottom+20,  Width_Window-giveMoneyLabel.right-20, 20) text:giveMoneyStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:giveMoneyValueLabel];
    //11>推广费
    DetailLabel *popularizeFeeLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, giveMoneyValueLabel.bottom+20, 70, 20) text:@"推广费:" fontSize:16 textColor:[UIColor customTitleColor]];
    popularizeFeeLabel.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:popularizeFeeLabel];
    NSString *popularizeFeeStr = [NSString stringWithFormat:@"%@%%",self.infoDict[@"promotioinCost"]];
    DetailLabel *popularizeFeeValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(popularizeFeeLabel.right+5, giveMoneyValueLabel.bottom+20,  Width_Window-popularizeFeeLabel.right-20, 20) text:popularizeFeeStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:popularizeFeeValueLabel];
    //12>获得佣金
    DetailLabel *getCommissionLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, popularizeFeeValueLabel.bottom+20, 70, 20) text:@"获得佣金:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:getCommissionLabel];
    NSString *getCommissionStr = [NSString stringWithFormat:@"%@元",self.infoDict[@"commissionGained"]];
    DetailLabel *getCommissionValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(getCommissionLabel.right+5, popularizeFeeValueLabel.bottom+20,  Width_Window-getCommissionLabel.right-20, 20) text:getCommissionStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:getCommissionValueLabel];
    //13>记录日期
    DetailLabel *recordDateLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, getCommissionValueLabel.bottom+20, 70, 20) text:@"记录日期:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:recordDateLabel];
    NSString *recordDateStr = [NSString stringWithFormat:@"%@",self.infoDict[@"createTime"]];
    DetailLabel *recordDateValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(recordDateLabel.right+5, getCommissionValueLabel.bottom+20,  Width_Window-recordDateLabel.right-20, 20) text:recordDateStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:recordDateValueLabel];
    //14> 结算时间
    DetailLabel *endTimeLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, recordDateValueLabel.bottom+20, 70, 20) text:@"结算时间:" fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:endTimeLabel];
    NSString *endTimeStr = [NSString stringWithFormat:@"%@",self.infoDict[@"commissionedTime"]];
    DetailLabel *endTimeValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(endTimeLabel.right+5, recordDateValueLabel.bottom+20,  Width_Window-endTimeLabel.right-20, 20) text:endTimeStr fontSize:16 textColor:[UIColor customTitleColor]];
    [scrollView addSubview:endTimeValueLabel];

    scrollView.contentSize = CGSizeMake(Width_Window, endTimeValueLabel.bottom + 100);
}

#pragma mark - 请求交易明细数据
- (void)requestTradeDetailData{
    WeakSelf
    [[RequestManager sharedInstance]postTradeDetailWithId:self.Id userId:[StoreTool getUserID]  Success:^(id responseData) {
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
