//
//  TradeListViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "TradeListViewController.h"
#import "Configure.h"
#import "TradeListCell.h"
/** 交易明细 */
#import "TradeDetailViewController.h"
#import "TradeListModel.h"
//无数据
#import "QLScrollViewExtension.h"


@interface TradeListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UILabel *moneyLabel;//佣金

@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) TradeListModel *tradeModel;

@end

@implementation TradeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"交易记录";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createUI];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [tableView.mj_header beginRefreshing];
    [self.view addSubview:tableView];
    
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        self.page = 1;
        [self requestTradeListDataWithPage:self.page];
    }];
    
    self.tableView = tableView;
    
    //tableHeaderView
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 170)];
    headerView.backgroundColor = [UIColor customBackgroundColor];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Width_Window, 150)];
    bgView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:bgView];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, Width_Window-20, 50)];
    moneyLabel.text = @"0.00";
    moneyLabel.textColor = [UIColor customDeepYellowColor];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:40];
    [bgView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    UILabel *moneyLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, moneyLabel.bottom, Width_Window-20, 20)];
    moneyLabel2.text = @"累计佣金(元)";
    moneyLabel2.textColor = [UIColor customDetailColor];
    moneyLabel2.textAlignment = NSTextAlignmentCenter;
    moneyLabel2.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:moneyLabel2];
    tableView.tableHeaderView = headerView;

#pragma mark -- 适配iOS 11
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    /** 去掉错乱情况 */
    adjustsScrollViewInsets_NO(tableView, self);
}

#pragma mark 上拉刷新
- (void)loadMoreData{
    [self requestTradeListDataWithPage:self.page];
}

#pragma mark 下拉加载更多数据
- (void)loadNewData{
    self.page = 1;
    [self requestTradeListDataWithPage:self.page];
}

#pragma mark - 请求交易记录数据
- (void)requestTradeListDataWithPage:(NSInteger)page{
    WeakSelf
    self.tableView.loading = YES;
    if (self.infoArr == nil) {
        self.infoArr = [[NSMutableArray alloc]init];
        self.page = 1;
    }
    
    [[RequestManager sharedInstance]postTradeListWithPage:page userId:[StoreTool getUserID] Success:^(id responseData) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if(page == 1){
                [strongSelf.infoArr removeAllObjects];
            }

            strongSelf.page++;
            strongSelf.infoDict = TipDic[@"data"];
            //累计佣金
            strongSelf.moneyLabel.text = [NSString stringWithFormat:@"%@",strongSelf.infoDict[@"totalCommission"]];
            
            NSArray *arr = strongSelf.infoDict[@"recordList"];
            if (arr.count == 0) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                strongSelf.page++;
                for (NSDictionary *temp in arr) {
                    strongSelf.tradeModel = [TradeListModel tradeListModelWithDictionary:temp];
                    [strongSelf.infoArr addObject:strongSelf.tradeModel];
                }
            }
            [strongSelf.tableView reloadData];
        }else{
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
        }

    } Error:^(NSError *error) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.infoArr.count == 0);
    return self.infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    TradeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[TradeListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    
    [cell setTradeListModelWithDictionary:self.infoArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TradeListModel *tradeModel = self.infoArr[indexPath.row];
    TradeDetailViewController *tradeDetailVC = [[TradeDetailViewController alloc]init];
    tradeDetailVC.Id = tradeModel.Id;
    [self.navigationController pushViewController:tradeDetailVC animated:YES];
    
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
