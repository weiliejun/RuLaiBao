//
//  GuaranteeDetailViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/8.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "GuaranteeDetailViewController.h"
#import "Configure.h"
#import "DetailLabel.h"
//#import "InsuranceDetailViewController.h"
//保险产品详情
#import "NewDetailViewController.h"
//图片预览
#import "HDPhotoBrowserView.h"
//无数据
#import "RLBDetailNoDataTipView.h"


@interface GuaranteeDetailViewController ()<UIScrollViewDelegate,UITextViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *warningView;//提示信息
@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, weak) UIView *photoView;// 图片

@property (nonatomic, weak) RLBDetailNoDataTipView *noDetailTipView;

@end

@implementation GuaranteeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"保单详情";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self requestGuaranteeDetailDataWithOrderId:self.orderId];
}

#pragma mark - 请求保单详情数据
- (void)requestGuaranteeDetailDataWithOrderId:(NSString *)orderId{
    WeakSelf
    [[RequestManager sharedInstance]postGuaranteeDetailWithOrderId:orderId userId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                strongSelf.infoDict = TipDic[@"data"];
                [self createUI];
                

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

- (void)createUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar)];
    scrollView.backgroundColor = [UIColor customBackgroundColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    /** 去掉错乱情况 */
    adjustsScrollViewInsets_NO(scrollView, self);
    
    //详情
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Width_Window, 200)];
    detailView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:detailView];
    
    UIControl *productCtl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 50)];
    productCtl.backgroundColor = [UIColor clearColor];
    [productCtl addTarget:self action:@selector(goToProduct) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:productCtl];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, Width_Window-40, 20)];
    nameLabel.text = [NSString stringWithFormat:@"%@",self.infoDict[@"insuranceName"]];
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
    
    //1>保单状态:
    DetailLabel *typeLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, productCtl.bottom+20, 70, 20) text:@"保单状态:" fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:typeLabel];
    
    //保单状态
    NSString *statusStr;
    if ([self.infoDict[@"status"] isEqualToString:@"init"]) {
        statusStr = @"待审核";
    }else if ([self.infoDict[@"status"] isEqualToString:@"payed"]){
        statusStr = @"已承保";
    }else if ([self.infoDict[@"status"] isEqualToString:@"rejected"]){
        statusStr = @"问题件";
    }else if ([self.infoDict[@"status"] isEqualToString:@"receiptSigned"]){
        statusStr = @"回执签收";
    }else if ([self.infoDict[@"status"] isEqualToString:@"commissioned"]){
        statusStr = @"已结算";
    }else if ([self.infoDict[@"status"] isEqualToString:@"renewing"]){
        statusStr = @"续保中";
    }else{//renewed
        statusStr = @"已续保";
    }

    DetailLabel *typeValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(typeLabel.right+5, productCtl.bottom+20,  Width_Window-typeLabel.right-20, 20) text:statusStr fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:typeValueLabel];
    //2>承保时间：
    DetailLabel *startTimeLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, typeValueLabel.bottom+20, 70, 20) text:@"承保时间:" fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:startTimeLabel];
    DetailLabel *startTimeValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(startTimeLabel.right+5, typeValueLabel.bottom+20,  Width_Window-startTimeLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"underwirteTime"]] fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:startTimeValueLabel];
    
    //判断是否显示承保时间
    if ([self.infoDict[@"status"] isEqualToString:@"receiptSigned"] || [self.infoDict[@"status"] isEqualToString:@"payed"] || [self.infoDict[@"status"] isEqualToString:@"commissioned"]) {
        //回执签收，已承保，已结算（显示承保时间，保单编号）
        //承保时间
        startTimeLabel.frame = CGRectMake(10, typeLabel.bottom+20, 70, 20);
        startTimeValueLabel.frame = CGRectMake(startTimeLabel.right+5, typeLabel.bottom+20,  Width_Window-startTimeLabel.right-20, 20);
    }else{
        //待审核，问题件（不显示承保时间，保单编号）
        startTimeLabel.frame = CGRectMake(0, typeLabel.bottom, 0, 0);
        startTimeValueLabel.frame = CGRectMake(0, typeLabel.bottom, 0, 0);
    }
    
    //3>产品名称：
    DetailLabel *detailNameLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, startTimeValueLabel.bottom+20, 70, 20) text:@"产品名称:" fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:detailNameLabel];
    DetailLabel *detailNameValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(detailNameLabel.right+5, startTimeValueLabel.bottom+20,  Width_Window-detailNameLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"insuranceName"]] fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:detailNameValueLabel];
    //4>保单编号：
    DetailLabel *numberIdLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, detailNameValueLabel.bottom+20, 70, 20) text:@"保单编号:" fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:numberIdLabel];
    DetailLabel *numberIdValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(numberIdLabel.right+5, detailNameValueLabel.bottom+20,  Width_Window-numberIdLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"orderCode"]] fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:numberIdValueLabel];
    
    //判断是否显示承保时间，保单编号
    if ([self.infoDict[@"status"] isEqualToString:@"receiptSigned"] || [self.infoDict[@"status"] isEqualToString:@"payed"] || [self.infoDict[@"status"] isEqualToString:@"commissioned"]) {
        //回执签收，已承保，已结算（显示承保时间，保单编号）
        //保单编号
        numberIdLabel.frame = CGRectMake(10, detailNameLabel.bottom+20, 70, 20);
        numberIdValueLabel.frame = CGRectMake(numberIdLabel.right+5, detailNameLabel.bottom+20,  Width_Window-numberIdLabel.right-20, 20);
    }else{
        //待审核，问题件（不显示承保时间，保单编号）
        numberIdLabel.frame = CGRectMake(0, detailNameLabel.bottom, 0, 0);
        numberIdValueLabel.frame = CGRectMake(0, detailNameLabel.bottom, 0, 0);
    }
    
    //5>客户姓名：
    DetailLabel *customerNameLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, numberIdValueLabel.bottom+20, 70, 20) text:@"客户姓名:" fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:customerNameLabel];
    DetailLabel *customerNameValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(customerNameLabel.right+5, numberIdValueLabel.bottom+20,  Width_Window-customerNameLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"customerName"]] fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:customerNameValueLabel];
    //6>身份证号：
    DetailLabel *idNumberLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, customerNameValueLabel.bottom+20, 70, 20) text:@"身份证号:" fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:idNumberLabel];
    DetailLabel *idNumberValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(idNumberLabel.right+5, customerNameValueLabel.bottom+20,  Width_Window-idNumberLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"customerIdNo"]] fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:idNumberValueLabel];
    //7>保险期限：
    DetailLabel *timeLimitLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, idNumberValueLabel.bottom+20, 70, 20) text:@"保险期限:" fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:timeLimitLabel];
    DetailLabel *timeLimitValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(timeLimitLabel.right+5, idNumberValueLabel.bottom+20, Width_Window-timeLimitLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"insurancePeriod"]]  fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:timeLimitValueLabel];
    //8>缴费期限：
    DetailLabel *payLimitLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, timeLimitValueLabel.bottom+20, 70, 20) text:@"缴费期限:" fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:payLimitLabel];
    DetailLabel *payLimitValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(payLimitLabel.right+5, timeLimitValueLabel.bottom+20,  Width_Window-payLimitLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"paymentPeriod"]]  fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:payLimitValueLabel];
    //9>续费日期：
    DetailLabel *continueDateLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, payLimitValueLabel.bottom+20, 70, 20) text:@"续费日期:" fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:continueDateLabel];
    DetailLabel *continueDateValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(continueDateLabel.right+5, payLimitValueLabel.bottom+20,  Width_Window-continueDateLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"renewalDate"]] fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:continueDateValueLabel];
    //10>已交保费
    DetailLabel *giveMoneyLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, continueDateValueLabel.bottom+20, 70, 20) text:@"已交保费:" fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:giveMoneyLabel];
    DetailLabel *giveMoneyValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(giveMoneyLabel.right+5, continueDateValueLabel.bottom+20,  Width_Window-giveMoneyLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"paymentedPremiums"]] fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:giveMoneyValueLabel];
    //11>推广费
    DetailLabel *popularizeFeeLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, giveMoneyValueLabel.bottom+20, 70, 20) text:@"推广费:" fontSize:16 textColor:[UIColor customDetailColor]];
    popularizeFeeLabel.textAlignment = NSTextAlignmentRight;
    [detailView addSubview:popularizeFeeLabel];
    DetailLabel *popularizeFeeValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(popularizeFeeLabel.right+5, giveMoneyValueLabel.bottom+20,  Width_Window-popularizeFeeLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"promotioinCost"]] fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:popularizeFeeValueLabel];
    
    //12>获得佣金
    DetailLabel *commissionFeeLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, popularizeFeeLabel.bottom+20, 70, 20) text:@"获得佣金:" fontSize:16 textColor:[UIColor customDetailColor]];
    popularizeFeeLabel.textAlignment = NSTextAlignmentRight;
    [detailView addSubview:commissionFeeLabel];
    DetailLabel *commissionFeeValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(commissionFeeLabel.right+5, popularizeFeeLabel.bottom+20,  Width_Window-commissionFeeLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"commissionGained"]] fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:commissionFeeValueLabel];
    
    //判断是否显示获得佣金
    if ([self.infoDict[@"status"] isEqualToString:@"commissioned"]) {
        //已结算（显示获得佣金）
        //获得佣金
        commissionFeeLabel.frame = CGRectMake(10, popularizeFeeLabel.bottom+20, 70, 20);
        commissionFeeValueLabel.frame = CGRectMake(commissionFeeLabel.right+5, popularizeFeeLabel.bottom+20,  Width_Window-commissionFeeLabel.right-20, 20);
    }else{
        commissionFeeLabel.frame = CGRectMake(0, popularizeFeeLabel.bottom, 0, 0);
        commissionFeeValueLabel.frame = CGRectMake(commissionFeeLabel.right+5, popularizeFeeLabel.bottom, 0, 0);
    }
    
    //13>记录日期：
    DetailLabel *recordDateLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, commissionFeeLabel.bottom+20, 70, 20) text:@"记录日期:" fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:recordDateLabel];
    DetailLabel *recordDateValueLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(recordDateLabel.right+5, commissionFeeLabel.bottom+20,  Width_Window-recordDateLabel.right-20, 20) text:[NSString stringWithFormat:@"%@",self.infoDict[@"recordTime"]]  fontSize:16 textColor:[UIColor customDetailColor]];
    [detailView addSubview:recordDateValueLabel];
    
    detailView.frame = CGRectMake(0, 10, Width_Window,recordDateLabel.bottom+20);

    // 图片
    UIView *photoView = [[UIView alloc]initWithFrame:CGRectMake(0, detailView.bottom+10, Width_Window, 360)];
    photoView.backgroundColor = [UIColor whiteColor];
    photoView.tag =  10000;
    [scrollView addSubview:photoView];
    self.photoView = photoView;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Width_Window-20, 20)];
    titleLabel.text = @"相关凭证";
    titleLabel.textColor = [UIColor customTitleColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [photoView addSubview:titleLabel];
    
    //身份证正面
    UIImageView *upIDImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, titleLabel.bottom+10, (Width_Window-30)/2, 100)];
    [upIDImage sd_setImageWithURL:[NSURL URLWithString:self.infoDict[@"idcardPositive"]] placeholderImage:[UIImage imageNamed:@"ID_front"]];
    upIDImage.tag = 1001;
    upIDImage.userInteractionEnabled = YES;
    [photoView addSubview:upIDImage];
    
    //身份证反面
    UIImageView *downIDImage = [[UIImageView alloc]initWithFrame:CGRectMake(Width_Window/2+5, titleLabel.bottom+10, (Width_Window-30)/2, 100)];
    [downIDImage sd_setImageWithURL:[NSURL URLWithString:self.infoDict[@"idcardNegative"]] placeholderImage:[UIImage imageNamed:@"ID_back"]];
    downIDImage.tag = 1002;
    downIDImage.userInteractionEnabled = YES;
    [photoView addSubview:downIDImage];
    
    //银行卡
    UIImageView *bankImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, upIDImage.bottom+10, (Width_Window-30)/2, 100)];
    [bankImage sd_setImageWithURL:[NSURL URLWithString:self.infoDict[@"bankCard"]] placeholderImage:[UIImage imageNamed:@"bankCard"]];
    bankImage.tag = 1003;
    bankImage.userInteractionEnabled = YES;
    [photoView addSubview:bankImage];
    
    //其他1
    UIImageView *otherImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(Width_Window/2+5, downIDImage.bottom+10, (Width_Window-30)/2, 100)];
    [otherImage1 sd_setImageWithURL:[NSURL URLWithString:self.infoDict[@"attachmentFirst"]] placeholderImage:[UIImage imageNamed:@"other"]];
    otherImage1.tag = 1004;
    otherImage1.userInteractionEnabled = YES;
    [photoView addSubview:otherImage1];

    //其他2
    UIImageView *otherImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, bankImage.bottom+10, (Width_Window-30)/2, 100)];
    [otherImage2 sd_setImageWithURL:[NSURL URLWithString:self.infoDict[@"attachmentSecond"]] placeholderImage:[UIImage imageNamed:@"other"]];
    otherImage2.tag = 1005;
    otherImage2.userInteractionEnabled = YES;
    [photoView addSubview:otherImage2];
    
    //添加手势
    if (![self.infoDict[@"idcardPositive"] isEqualToString:@""]) {
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGestureRecognizer:)];
        [upIDImage addGestureRecognizer:tapGesture1];
    }
    
    if (![self.infoDict[@"idcardNegative"] isEqualToString:@""]) {
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGestureRecognizer:)];
        [downIDImage addGestureRecognizer:tapGesture2];
    }
    
    if (![self.infoDict[@"bankCard"] isEqualToString:@""]) {
        UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGestureRecognizer:)];
        [bankImage addGestureRecognizer:tapGesture3];
    }
    if (![self.infoDict[@"attachmentFirst"] isEqualToString:@""]) {
        UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGestureRecognizer:)];
        [otherImage1 addGestureRecognizer:tapGesture4];
    }
    
    if (![self.infoDict[@"attachmentSecond"] isEqualToString:@""]) {
        UITapGestureRecognizer *tapGesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGestureRecognizer:)];
        [otherImage2 addGestureRecognizer:tapGesture5];
    }

    //备注
    UIView *remarkView = [[UIView alloc]initWithFrame:CGRectMake(0, photoView.bottom+10, Width_Window, 240+Height_View_HomeBar)];
    remarkView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:remarkView];
    
    UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Width_Window-20, 20)];
    remarkLabel.text = @"备注说明";
    remarkLabel.textAlignment = NSTextAlignmentCenter;
    remarkLabel.textColor = [UIColor customTitleColor];
    remarkLabel.font = [UIFont systemFontOfSize:16];
    [remarkView addSubview: remarkLabel];
    
    UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(10, remarkLabel.bottom+10, Width_Window-20, 200+Height_View_HomeBar)];
    textView.backgroundColor =[UIColor whiteColor];
    textView.text = [NSString stringWithFormat:@"%@",self.infoDict[@"remark"]];
    textView.textColor = [UIColor customDetailColor];
    textView.font = [UIFont systemFontOfSize:14];
    textView.userInteractionEnabled = NO;
    [remarkView addSubview:textView];

    //提示信息
    UIView *warningView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, 50)];
    warningView.backgroundColor = [UIColor customRedColor];
    [self.view addSubview:warningView];
    self.warningView = warningView;
    
    //反馈说明（问题保单）
    NSString *str = [NSString stringWithFormat:@"%@",self.infoDict[@"auditDesc"]];
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
    
    //是否有提示信息、备注
    if (![self.infoDict[@"status"] isEqualToString:@"rejected"]){
        //无提示信息
        self.warningView.hidden = YES;
        self.scrollView.frame = CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar);

        if ([self.infoDict[@"remark"] isEqualToString:@""]) {
            //无备注时不显示
            remarkView.hidden = YES;
            scrollView.contentSize = CGSizeMake(Width_Window, photoView.bottom+10);
        }else{//有备注时显示
            remarkView.hidden = NO;
            scrollView.contentSize = CGSizeMake(Width_Window, remarkView.bottom+10);
        }
        
    }else{//有提示信息
        //无驳回信息时 显示：暂无驳回信息。｛XXXX-XX-XX｝
        self.warningView.hidden = NO;
        self.scrollView.frame =  CGRectMake(0, self.warningView.bottom, Width_Window, Height_Window-Height_Statusbar_NavBar);
        if ([str isEqualToString:@""]) {
            warningLabel.text = [NSString stringWithFormat:@"暂无驳回信息。{%@}",self.infoDict[@"auditTime"]];
        }else{
            warningLabel.text = [NSString stringWithFormat:@"%@。{%@}",str,self.infoDict[@"auditTime"]];
        }
        if ([self.infoDict[@"remark"] isEqualToString:@""]) {
            //无备注时不显示
            remarkView.hidden = YES;
            scrollView.contentSize = CGSizeMake(Width_Window, self.warningView.bottom+photoView.bottom+10);
        }else{//有备注时显示
            remarkView.hidden = NO;
            scrollView.contentSize = CGSizeMake(Width_Window, self.warningView.bottom+remarkView.bottom+10);
        }
    }
}

//图片预览
- (void)tagGestureRecognizer:(UITapGestureRecognizer *)tagGesture{
    NSInteger imageTag = [[(UIGestureRecognizer *)tagGesture view] tag] - 1000;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    switch (imageTag) {
        case 1:{
           NSMutableArray *muArr = [NSMutableArray arrayWithObject:self.infoDict[@"idcardPositive"]];
            arr = muArr;
        }
            break;
        case 2:{
            NSMutableArray *muArr = [NSMutableArray arrayWithObject:self.infoDict[@"idcardNegative"]];
            arr = muArr;
        }
            break;
        case 3:{
            NSMutableArray *muArr = [NSMutableArray arrayWithObject:self.infoDict[@"bankCard"]];
            arr = muArr;
        }
            break;
        case 4:{
            NSMutableArray *muArr = [NSMutableArray arrayWithObject:self.infoDict[@"attachmentFirst"]];
            arr = muArr;
        }
            break;
        case 5:{
            NSMutableArray *muArr = [NSMutableArray arrayWithObject:self.infoDict[@"attachmentSecond"]];
            arr = muArr;
        }
            break;
        default:
            break;
    }
   
    HDPhotoBrowserView *browser = [[HDPhotoBrowserView alloc] initWithCurrentIndex:0 imageURLArray:arr placeholderImage:nil sourceView:nil];
    [browser show];
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

#pragma mark - 产品详情
- (void)goToProduct{
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
