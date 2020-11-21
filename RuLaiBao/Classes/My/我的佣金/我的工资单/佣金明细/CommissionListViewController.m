//
//  CommissionListViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/14.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "CommissionListViewController.h"
#import "Configure.h"
#import "CommissionListCell.h"
#import "CommissionDetailViewController.h"
//无数据
#import "QLScrollViewExtension.h"
#import "CommissionListModel.h"
#import "ChangeNumber.h"


@interface CommissionListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) CommissionListModel *commissionListModel;
//佣金份数
@property (nonatomic, strong) UILabel *numberLabel;
//佣金总额
@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation CommissionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"佣金明细";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [tableView.mj_header beginRefreshing];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        self.page = 1;
        [self requestCommisionListDataWithPage:self.page];
    }];
    
    //tableHeaderView
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headerView;
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 20)];
    numberLabel.text = @"0份佣金";
    numberLabel.textColor = [UIColor customTitleColor];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width_Window/2, 20, Width_Window/2-20, 20)];
    moneyLabel.text = @"共计0.00元";
    moneyLabel.textColor = [UIColor customDeepYellowColor];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
}

#pragma mark 上拉刷新
- (void)loadMoreData{
    [self requestCommisionListDataWithPage:self.page];
}

#pragma mark 下拉加载更多数据
- (void)loadNewData{
    self.page = 1 ;
    [self requestCommisionListDataWithPage:self.page];
}


#pragma mark - 请求佣金明细数据
- (void)requestCommisionListDataWithPage:(NSInteger)page {
    self.tableView.loading = YES;
    if (self.infoArr == nil) {
        self.infoArr = [[NSMutableArray alloc]init];
        self.page = 1;
    }
    WeakSelf
    [[RequestManager sharedInstance]postCommissionListWithUserId:[StoreTool getUserID] page:page currentMonth:self.currentMonthStr Success:^(id responseData) {
        StrongSelf
        strongSelf.tableView.loading = NO;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            if(page == 1){
                [strongSelf.infoArr removeAllObjects];
            }
            
            strongSelf.infoDict = TipDic[@"data"];
            
            //佣金份数
            self.numberLabel.text = [NSString stringWithFormat:@"%@份佣金",strongSelf.infoDict[@"total"]];
            
            //佣金总数
            NSString *moneyStr = [[ChangeNumber alloc]changeNumber:strongSelf.infoDict[@"totalCommission"]];
            self.moneyLabel.text = [NSString stringWithFormat:@"共计%@元",moneyStr];

            NSArray *arr = strongSelf.infoDict[@"recordList"];
            if (arr.count == 0) {
//                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                strongSelf.page++;
                for (NSDictionary *temp in arr) {
                    strongSelf.commissionListModel = [CommissionListModel commissionListModelWithDictionary:temp];
                    [strongSelf.infoArr addObject:strongSelf.commissionListModel];
                    
                }
            }
            [strongSelf.tableView reloadData];
            
        }else {
            [strongSelf.tableView.mj_footer endRefreshing];
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
        
    } Error:^(NSError *error) {
        StrongSelf
        strongSelf.tableView.loading = NO;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    CommissionListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[CommissionListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    
    [cell setCommissionListModelWithDictionary:self.infoArr[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommissionListModel *model = self.infoArr[indexPath.row];
    CommissionDetailViewController *detailVC = [[CommissionDetailViewController alloc]init];
    detailVC.Id = model.commissionListId;
    [self.navigationController pushViewController:detailVC animated:YES];

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
