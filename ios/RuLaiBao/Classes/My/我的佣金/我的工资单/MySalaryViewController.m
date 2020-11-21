//
//  MySalaryViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MySalaryViewController.h"
#import "Configure.h"
#import "TYTabPagerBar.h"
//无数据
#import "QLScrollViewExtension.h"

#import "MySalaryCell.h"
//工资单详情
#import "SalaryDetailViewController.h"
#import "MySalaryModel.h"



@interface MySalaryViewController ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *yearArr;

@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) MySalaryModel *salaryModel;

@end

@implementation MySalaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的工资单";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    self.yearArr = [NSMutableArray arrayWithCapacity:20];
    self.infoArr = [NSMutableArray arrayWithCapacity:20];
    
    [self requestMySalaryData];
    
    self.page = 1;
    self.currentIndex = 0;
    
}

#pragma mark - 请求年份
- (void)requestMySalaryData {
    [[RequestManager sharedInstance]postSalaryYearWithUserId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *yearDict = TipDic[@"data"];
            self.yearArr = yearDict[@"wageYears"];
            
            //添加tableView
            [self createUI];
            
            if (self.yearArr.count != 0) {
                //有数据
                //添加头部滚动条
                [self addTabPageBar];
                [self loadData];

                 self.tableView.frame = CGRectMake(0, Height_Statusbar_NavBar+50, Width_Window, Height_Window-Height_Statusbar_NavBar-50);
                
            }else {
                //无数据
                self.yearArr = [NSMutableArray arrayWithObjects:@"", nil];
                self.tableView.frame = CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar);
            }

        }else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
        
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 请求工资单列表数据
- (void)requestMySalaryListDataWithYear:(NSString *)year page:(NSInteger)page {
    self.tableView.loading = YES;
    if (self.infoArr == nil) {
        self.infoArr = [[NSMutableArray alloc]init];
        self.page = 1;
    }
    WeakSelf
    [[RequestManager sharedInstance]postMySalaryListWithUserId:[StoreTool getUserID] currentYear:year page:page Success:^(id responseData) {
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
            NSArray *arr = strongSelf.infoDict[@"newList"];
            if (arr.count == 0) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                strongSelf.page++;
                for (NSDictionary *temp in arr) {
                    strongSelf.salaryModel = [MySalaryModel mySalaryModelWithDictionary:temp];
                    [strongSelf.infoArr addObject:strongSelf.salaryModel];
                    
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
    self.tableView = tableView;
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        self.page = 1;
        [self requestMySalaryListDataWithYear:self.yearArr[self.currentIndex] page:self.page];
    }];
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
}

#pragma mark 上拉刷新
- (void)loadMoreData{
    [self requestMySalaryListDataWithYear:self.yearArr[self.currentIndex] page:self.page];
}

#pragma mark 下拉加载更多数据
- (void)loadNewData{
    self.page = 1 ;
    [self requestMySalaryListDataWithYear:self.yearArr[self.currentIndex] page:self.page];
}

#pragma mark - 头部滚动条
- (void)addTabPageBar {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    CGFloat width_View = (self.yearArr.count * 60 + 10 * (self.yearArr.count+1));
    CGFloat widthView = width_View > Width_Window ? Width_Window : width_View;
    CGFloat tabbar_pointX = (Width_Window-widthView)/2;
    
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]initWithFrame:CGRectMake(tabbar_pointX, 0, widthView, 50)];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.layout.progressWidth = 60;
    tabBar.layout.normalTextFont = [UIFont systemFontOfSize:16];
    tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:17];
    tabBar.layout.normalTextColor = [UIColor customTitleColor];
    tabBar.layout.selectedTextColor = [UIColor customNavBarColor];
    tabBar.layout.progressColor = [UIColor customDeepYellowColor];
    tabBar.layout.cellSpacing = 10;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [bgView addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)loadData {
    NSArray *titleArr = self.yearArr;
    _datas = [titleArr copy];
    [self.tabBar reloadData];
    //当前选中index
    [self pagerTabBar:_tabBar didSelectItemAtIndex:self.yearArr.count-1];
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
    return 60;
    
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [pagerTabBar scrollToItemFromIndex:pagerTabBar.curIndex toIndex:index animate:YES];
        NSLog(@"选中>>>%@",self.datas[index]);
    self.currentIndex = index;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
    MySalaryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[MySalaryCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    
    [cell setMySalaryModelWithDictionary:self.infoArr[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customBackgroundColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MySalaryModel *model = self.infoArr[indexPath.section];
    SalaryDetailViewController *detailVC = [[SalaryDetailViewController alloc]init];
    detailVC.salaryId = model.mySalaryId;
//    detailVC.monthStr = [NSString stringWithFormat:@"%@-%@",self.yearArr[self.currentIndex],model.wageMonth];
    detailVC.monthStr = [NSString stringWithFormat:@"%@",model.wageMonth];
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
