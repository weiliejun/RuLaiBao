//
//  SalaryDetailViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "SalaryDetailViewController.h"
#import "Configure.h"
#import "CommissionListViewController.h"


@interface SalaryDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSDictionary *infoDict;

@end

@implementation SalaryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"工资单详情";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self requestSalaryDetailData];
}

#pragma mark - 请求工资单详情数据
- (void)requestSalaryDetailData {
    WeakSelf
    [[RequestManager sharedInstance]postSalaryDetailWithUserId:[StoreTool getUserID] id:self.salaryId Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            strongSelf.infoDict = TipDic[@"data"];
            
            [strongSelf createUI];
            
        }else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
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
    
    UIView *commissionView = [self createLabelWithRect:CGRectMake(0, 10, Width_Window, 50) labelTag:1 lineColor:[UIColor colorWithRed:89/255.0 green:232/255.0 blue:96/255.0 alpha:1.0] leftLabelStr:@"佣金收入" rightLabelStr:@"" superView:scrollView];
    UIView *profitView = [self createLabelWithRect:CGRectMake(0, commissionView.bottom+1, Width_Window, 50) labelTag:1 lineColor:[UIColor whiteColor] leftLabelStr:@"佣金收益" rightLabelStr:[NSString stringWithFormat:@"%@元",self.infoDict[@"commission"]] superView:scrollView];
    
    
    UIView *reduceView = [self createLabelWithRect:CGRectMake(0, profitView.bottom+10, Width_Window, 50) labelTag:1 lineColor:[UIColor colorWithRed:0/255.0 green:184/255.0 blue:238/255.0 alpha:1.0] leftLabelStr:@"佣金扣减" rightLabelStr:@"" superView:scrollView];
    UIView *personTaxView = [self createLabelWithRect:CGRectMake(0, reduceView.bottom+1, Width_Window, 50) labelTag:1 lineColor:[UIColor whiteColor] leftLabelStr:@"个人所得税" rightLabelStr:[NSString stringWithFormat:@"%@元",self.infoDict[@"individualTax"]] superView:scrollView];
    UIView *addTaxView = [self createLabelWithRect:CGRectMake(0, personTaxView.bottom+1, Width_Window, 50) labelTag:1 lineColor:[UIColor whiteColor] leftLabelStr:@"增值税" rightLabelStr:[NSString stringWithFormat:@"%@元",self.infoDict[@"valueaddedTax"]] superView:scrollView];
    UIView *surchargeView = [self createLabelWithRect:CGRectMake(0, addTaxView.bottom+1, Width_Window, 50) labelTag:1 lineColor:[UIColor whiteColor] leftLabelStr:@"附加税" rightLabelStr:[NSString stringWithFormat:@"%@元",self.infoDict[@"additionalTax"]] superView:scrollView];
    
    UIView *detailView = [self createLabelWithRect:CGRectMake(0, surchargeView.bottom+10, Width_Window, 50) labelTag:1 lineColor:[UIColor colorWithRed:241/255.0 green:142/255.0 blue:51/255.0 alpha:1.0] leftLabelStr:@"发放明细" rightLabelStr:@"" superView:scrollView];
    UIView *bankCardView = [self createLabelWithRect:CGRectMake(0, detailView.bottom+1, Width_Window, 50) labelTag:1 lineColor:[UIColor whiteColor] leftLabelStr:@"银行账号" rightLabelStr:[NSString stringWithFormat:@"%@",self.infoDict[@"bankcardNo"]] superView:scrollView];
    UIView *moneyView = [self createLabelWithRect:CGRectMake(0, bankCardView.bottom+1, Width_Window, 50) labelTag:1 lineColor:[UIColor whiteColor] leftLabelStr:@"到账金额" rightLabelStr:[NSString stringWithFormat:@"%@元",self.infoDict[@"income"]] superView:scrollView];
    UIView *statusView = [self createLabelWithRect:CGRectMake(0, moneyView.bottom+1, Width_Window, 50) labelTag:1 lineColor:[UIColor whiteColor] leftLabelStr:@"状态" rightLabelStr:[NSString stringWithFormat:@"%@",self.infoDict[@"status"]] superView:scrollView];
    
    //查看佣金明细
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, statusView.bottom+50, Width_Window, 100)];
    footerView.backgroundColor = [UIColor customBackgroundColor];
    [scrollView addSubview:footerView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window/2-100, 40, 200, 40)];
    //文字加下划线，设置颜色
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"查看佣金明细"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor customDeepYellowColor] range:strRange];
    
    [btn setAttributedTitle:str forState:UIControlStateNormal];//这个状态要加上
    
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(gotoCommissionVC:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    
    scrollView.contentSize = CGSizeMake(Width_Window, footerView.bottom + 100);
}

#pragma mark - 创建Label
- (UIView *)createLabelWithRect:(CGRect)viewRect labelTag:(NSInteger)tag lineColor:(UIColor *)lineColor leftLabelStr:(NSString *)leftLabelStr rightLabelStr:(NSString *)rightLabelStr superView:(UIView *)bgScrollView {
    UIView *bgView = [[UIView alloc]initWithFrame:viewRect];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:bgView];
    
    //左侧
    UILabel *colorLine = [[UILabel alloc]initWithFrame:CGRectMake(10, 17, 2, 15)];
    colorLine.backgroundColor = lineColor;
    [bgView addSubview:colorLine];

    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 20)];
    titleLabel.text = leftLabelStr;
    titleLabel.textColor = [UIColor customTitleColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:titleLabel];
    
    //右侧内容
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right+10, 15, Width_Window-titleLabel.right-20, 20)];
    detailLabel.text = rightLabelStr;
    detailLabel.textColor = [UIColor customTitleColor];
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:detailLabel];
    
    return bgView;
}

#pragma mark - 查看佣金明细
- (void)gotoCommissionVC:(UIButton *)btn {
    
    CommissionListViewController *listVC = [[CommissionListViewController alloc]init];
    listVC.currentMonthStr = self.monthStr;
    [self.navigationController pushViewController:listVC animated:YES];
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
