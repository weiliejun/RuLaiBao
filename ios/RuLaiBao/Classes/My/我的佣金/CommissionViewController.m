//
//  CommissionViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/12.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "CommissionViewController.h"
#import "Configure.h"
#import "MyCommissionCell.h"
/** 待发佣金 */
#import "UnpayCommissionViewController.h"
/** 已发佣金 */
#import "PayedCommissionViewController.h"
/** 我的工资单 */
#import "MySalaryViewController.h"
/** 我的银行卡 */
#import "MyBankCardViewController.h"
/** 扣税规则 */
#import "PayTaxRuleViewController.h"
#import "ChangeNumber.h"



@interface CommissionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
//佣金
@property (nonatomic, strong) UILabel *moneyLabel;
//待发佣金
@property (nonatomic, strong) UILabel *unpayMoneyLab;
//已发佣金
@property (nonatomic, strong) UILabel *payedMoneyLab;

@property (nonatomic, strong) NSDictionary *infoDict;

@end

@implementation CommissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的佣金";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createUI];
}

#pragma mark - 请求我的佣金数据
- (void)requestCommissionData {
    WeakSelf
    [[RequestManager sharedInstance]postCommissionWithUserId:[StoreTool getUserID] Success:^(id responseData) {
        StrongSelf
        [strongSelf.tableView.mj_header endRefreshing];
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            strongSelf.infoDict = TipDic[@"data"];
            //佣金
            self.moneyLabel.text = [[ChangeNumber alloc]changeNumber:strongSelf.infoDict[@"totalCommission"]];
            
            //待发佣金
            NSString *unpayMoneyLabStr = [[ChangeNumber alloc]changeNumber:strongSelf.infoDict[@"unCommissioned"]];
            self.unpayMoneyLab.text = [NSString stringWithFormat:@"%@元",unpayMoneyLabStr];
            //已发佣金
            NSString *payedMoneyLabStr = [[ChangeNumber alloc]changeNumber:strongSelf.infoDict[@"commissioned"]];
            self.payedMoneyLab.text = [NSString stringWithFormat:@"%@元",payedMoneyLabStr];
            
            [strongSelf.tableView reloadData];

        }else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
        
    } Error:^(NSError *error) {
        StrongSelf
        [strongSelf.tableView.mj_header endRefreshing];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 创建界面元素
- (void)createUI {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar+10, Width_Window, Height_Window-Height_Statusbar_NavBar-10) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [tableView.mj_header beginRefreshing];
    [self.view addSubview:tableView];
    self.tableView = tableView;

    // tableHeaderView
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 235)];
    headerView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headerView;
    
    //佣金
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, Width_Window -20, 40)];
    moneyLabel.text = @"0.00";
    moneyLabel.textColor = [UIColor customDeepYellowColor];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:40];
    [headerView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    UILabel *commossionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, moneyLabel.bottom+5, Width_Window - 20, 20)];
    commossionLabel.text = @"累计佣金(元)";
    commossionLabel.textColor = [UIColor customDetailColor];
    commossionLabel.textAlignment = NSTextAlignmentCenter;
    commossionLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:commossionLabel];
    
    //横线1
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, commossionLabel.bottom+50, Width_Window, 1)];
    line1.backgroundColor = [UIColor customLineColor];
    [headerView addSubview:line1];
    
    //待发佣金
    UIControl *unpayCtl = [[UIControl alloc]initWithFrame:CGRectMake(0, line1.bottom, Width_Window/2, 70)];
    [unpayCtl addTarget:self action:@selector(unpayCommission:) forControlEvents:UIControlEventTouchUpInside];
    unpayCtl.tag = 100000;
    [headerView addSubview:unpayCtl];
    
    UILabel *unpayMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, Width_Window/2-20, 20)];
    unpayMoneyLab.text = @"0.00元";
    unpayMoneyLab.textColor = [UIColor customTitleColor];
    unpayMoneyLab.textAlignment = NSTextAlignmentCenter;
    unpayMoneyLab.font = [UIFont systemFontOfSize:14];
    [unpayCtl addSubview:unpayMoneyLab];
    self.unpayMoneyLab = unpayMoneyLab;
    
    UILabel *unpayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, unpayMoneyLab.bottom, Width_Window/2-20, 20)];
    unpayLabel.text = @"待发佣金";
    unpayLabel.textColor = [UIColor customTitleColor];
    unpayLabel.textAlignment = NSTextAlignmentCenter;
    unpayLabel.font = [UIFont systemFontOfSize:14];
    [unpayCtl addSubview:unpayLabel];
    
    //竖线
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(Width_Window/2, line1.bottom+15, 1, 40)];
    line2.backgroundColor = [UIColor customLineColor];
    [headerView addSubview:line2];
    
    //已发佣金
    UIControl *payedCtl = [[UIControl alloc]initWithFrame:CGRectMake(Width_Window/2, line1.bottom, Width_Window/2, 70)];
    [payedCtl addTarget:self action:@selector(unpayCommission:) forControlEvents:UIControlEventTouchUpInside];
    payedCtl.tag = 100001;
    [headerView addSubview:payedCtl];
    
    UILabel *payedMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, Width_Window/2-20, 20)];
    payedMoneyLab.text = @"0.00元";
    payedMoneyLab.textColor = [UIColor customTitleColor];
    payedMoneyLab.textAlignment = NSTextAlignmentCenter;
    payedMoneyLab.font = [UIFont systemFontOfSize:14];
    [payedCtl addSubview:payedMoneyLab];
    self.payedMoneyLab = payedMoneyLab;
    
    UILabel *payedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, payedMoneyLab.bottom, Width_Window/2-20, 20)];
    payedLabel.text = @"已发佣金";
    payedLabel.textColor = [UIColor customTitleColor];
    payedLabel.textAlignment = NSTextAlignmentCenter;
    payedLabel.font = [UIFont systemFontOfSize:14];
    [payedCtl addSubview:payedLabel];
    
    // tableFooterView
    tableView.tableFooterView = [[UIView alloc]init];
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
}

#pragma mark 下拉加载更多数据
- (void)loadNewData{
    [self requestCommissionData];

}

#pragma mark - 待发、已发佣金
- (void)unpayCommission:(UIControl *)ctl {
    if (ctl.tag == 100000) {
        //待发佣金
        UnpayCommissionViewController *unpayVC = [[UnpayCommissionViewController alloc]init];
        [self.navigationController pushViewController:unpayVC animated:YES];

    } else {
        //已发佣金
        PayedCommissionViewController *payedVC = [[PayedCommissionViewController alloc]init];
        [self.navigationController pushViewController:payedVC animated:YES];
        
    }
}

#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"identifer";
    MyCommissionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[MyCommissionCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSArray *titleArr = @[@"我的工资单",@"我的银行卡",@"扣税规则"];
    NSArray *detailArr = @[@"查看各月的佣金情况",@"绑定银行卡后，佣金将于每月11日自动转入",@"推广佣金年年享"];
    [cell setTitleWithTitleStr:titleArr[indexPath.row] detailStr:detailArr[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //我的工资单
        MySalaryViewController *salaryVC = [[MySalaryViewController alloc]init];
        [self.navigationController pushViewController:salaryVC animated:YES];
        
    } else if (indexPath.row == 1) {
        //我的银行卡
        MyBankCardViewController *bankVC = [[MyBankCardViewController alloc]init];
        [self.navigationController pushViewController:bankVC animated:YES];
        
    } else {
        //扣税规则
        PayTaxRuleViewController *taxVC = [[PayTaxRuleViewController alloc]init];
        [self.navigationController pushViewController:taxVC animated:YES];
        
    }
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
