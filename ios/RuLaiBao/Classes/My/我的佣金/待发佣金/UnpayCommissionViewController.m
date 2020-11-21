//
//  UnpayCommissionViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "UnpayCommissionViewController.h"
#import "Configure.h"
#import "UnpayCommissionCell.h"
//保单详情
#import "GuaranteeDetailViewController.h"
//无数据
#import "QLScrollViewExtension.h"
#import "UnpayCommissionModel.h"


@interface UnpayCommissionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UnpayCommissionModel *unpayModel;

@end

@implementation UnpayCommissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"待发佣金";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    self.page = 1;
    self.infoArr = [NSMutableArray arrayWithCapacity:20];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.backgroundColor = [UIColor customBackgroundColor];
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
        [self requestUnpayCommissionDataWithPage:self.page];
    }];
    
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
}

#pragma mark 上拉刷新
- (void)loadMoreData{
    [self requestUnpayCommissionDataWithPage:self.page];
}

#pragma mark 下拉加载更多数据
- (void)loadNewData{
    self.page = 1;
    [self requestUnpayCommissionDataWithPage:self.page];
}


#pragma mark - 请求待发佣金数据
- (void)requestUnpayCommissionDataWithPage:(NSInteger)page {
    
    self.tableView.loading = YES;
    if (self.infoArr == nil) {
        self.infoArr = [[NSMutableArray alloc]init];
        self.page = 1;
    }
    
    WeakSelf
    [[RequestManager sharedInstance]postUnpayCommissionWithUserId:[StoreTool getUserID] commissionStatus:@"no" page:page Success:^(id responseData) {
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
            NSArray *arr = strongSelf.infoDict[@"commisionList"];
            if (arr.count == 0) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];

            }else{
                strongSelf.page++;
                for (NSDictionary *temp in arr) {
                    strongSelf.unpayModel = [UnpayCommissionModel unpayCommissionModelWithDictionary:temp];
                    [strongSelf.infoArr addObject:strongSelf.unpayModel];
                    
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
        [QLMBProgressHUD showPromptViewInView:strongSelf.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.infoArr.count == 0);
    return self.infoArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"identifer";
    UnpayCommissionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UnpayCommissionCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    
    }
    
    [cell setUnpayModelWithDictionary:self.infoArr[indexPath.section]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customBackgroundColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UnpayCommissionModel *unpayModel = self.infoArr[indexPath.section];
    GuaranteeDetailViewController *detailVC = [[GuaranteeDetailViewController alloc]init];
    detailVC.orderId = unpayModel.orderId;
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
