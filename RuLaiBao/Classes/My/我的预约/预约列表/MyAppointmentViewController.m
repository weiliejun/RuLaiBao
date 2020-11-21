//
//  AppointmentViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/17.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyAppointmentViewController.h"
#import "Configure.h"
/** 滚动条 */
#import "TYTabPagerBar.h"
#import "MyAppointmentCell.h"
#import "MyAppointListModel.h"
/** 预约详情 */
#import "AppointmentDetailViewController.h"
//无数据
#import "QLScrollViewExtension.h"


@interface MyAppointmentViewController ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, strong) NSMutableArray *infoArr;
//状态
@property (nonatomic, strong) NSString *auditStatus;
@property (nonatomic, strong) MyAppointListModel *model;

@end

@implementation MyAppointmentViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    [self requestMyTAppointListDataWithPage:self.page auditStatus:self.auditStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"预约列表";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self addTabPageBar];
    [self loadData];
    [self createUI];
}

#pragma mark - 头部滚动条
- (void)addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, 50)];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.layout.progressWidth = 60;
    tabBar.layout.normalTextFont = [UIFont systemFontOfSize:16];
    tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:16];
    tabBar.layout.normalTextColor = [UIColor customTitleColor];
    tabBar.layout.selectedTextColor = [UIColor customNavBarColor];
    tabBar.layout.progressColor = [UIColor customDeepYellowColor];
    tabBar.layout.cellSpacing = 10;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)loadData {
    NSArray *titleArr = @[@"全部(0)",@"待确认(0)",@"已确认(0)",@"已驳回(0)"];
    _datas = [titleArr copy];
    [self.tabBar reloadData];
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return _datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    NSString *title = _datas[index];
    cell.titleLabel.text = title;
    return cell;
}

#pragma mark - TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return [pagerTabBar cellWidthForTitle:title]+10;
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [pagerTabBar scrollToItemFromIndex:pagerTabBar.curIndex toIndex:index animate:YES];
//    NSLog(@"选中>>>%@",self.datas[index]);
    self.auditStatus = [self changeStrWithIndex:index];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar+50, Width_Window, Height_Window-Height_Statusbar_NavBar-50) style:UITableViewStylePlain];
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
    
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        self.page = 1;
        [self requestMyTAppointListDataWithPage:self.page auditStatus:self.auditStatus];
    }];
    
    self.tableView = tableView;
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    
    self.auditStatus = [self changeStrWithIndex:0];
}

//变换对应类型字段
- (NSString *)changeStrWithIndex:(NSInteger)index{
    NSString *str;
    if (index == 0) {
        //全部
        str = @"all";
    }else if (index == 1){
        //待确认
        str = @"confirming";
    }else if (index == 2){
        //已确认
        str = @"confirmed";
    }else if (index == 3){
        //已驳回
        str = @"refuse";
    }else {
        //已取消
        str = @"canceled";
    }
    return str;
}

#pragma mark 上拉刷新
- (void)loadMoreData{
    [self requestMyTAppointListDataWithPage:self.page auditStatus:self.auditStatus];
}

#pragma mark 下拉加载更多数据
- (void)loadNewData{
    self.page = 1;
    [self requestMyTAppointListDataWithPage:self.page auditStatus:self.auditStatus];
}

#pragma mark - 请求预约列表数据
- (void)requestMyTAppointListDataWithPage:(NSInteger)page auditStatus:(NSString *)auditStatus{
    WeakSelf
    self.tableView.loading = YES;
    if (self.infoArr == nil) {
        self.infoArr = [[NSMutableArray alloc]init];
        self.page = 1;
    }
    [[RequestManager sharedInstance]postAppointListWithPage:page auditStatus:auditStatus userId:[StoreTool getUserID] Success:^(id responseData) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                if(page == 1){
                    [strongSelf.infoArr removeAllObjects];
                }
                
                //重置滚动条数据
                NSDictionary *infoDict = TipDic[@"data"];
                NSString *allTotal = [NSString stringWithFormat:@"全部(%@)",infoDict[@"totalCount"]];
                NSString *initTotal = [NSString stringWithFormat:@"待确认(%@)",infoDict[@"confirmingCount"]];
                NSString *payedTotal = [NSString stringWithFormat:@"已确认(%@)",infoDict[@"confirmedCount"]];
                NSString *rejectedTotal = [NSString stringWithFormat:@"已驳回(%@)",infoDict[@"refuseCount"]];
                NSString *receiptSignedTotal = [NSString stringWithFormat:@"已取消(%@)",infoDict[@"canceledCount"]];
                NSArray *titleArr = @[allTotal,initTotal,payedTotal,rejectedTotal,receiptSignedTotal];
                _datas = [titleArr copy];
                [strongSelf.tabBar reloadData];
                
                NSArray *arr = TipDic[@"data"][@"list"];
                if (arr.count == 0) {
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    strongSelf.page++;
                    for (NSDictionary *temp in arr) {
                        strongSelf.model = [MyAppointListModel appointListModelWithDictionary:temp];
                        [strongSelf.infoArr addObject:strongSelf.model];
                    }
                }
                [strongSelf.tableView reloadData];
            }else{
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
            }
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

#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.infoArr.count == 0);
    return self.infoArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    MyAppointmentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[MyAppointmentCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    [cell setMyAppointListModelWithDictionary:self.infoArr[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customBackgroundColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAppointListModel *model = self.infoArr[indexPath.section];
    AppointmentDetailViewController *detailVC = [[AppointmentDetailViewController alloc]init];
    detailVC.Id = model.Id;
    [self.navigationController pushViewController:detailVC animated:YES];
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
