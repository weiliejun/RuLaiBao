//
//  InsuranceViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/2.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "InsuranceViewController.h"
/** 搜索功能 */
#import "MoreSearchViewController.h"
/** 滚动条 */
#import "TYTabPagerBar.h"
#import "Configure.h"
#import "InsuranceCell.h"
/** 保险详情 */
//#import "InsuranceDetailViewController.h"
#import "NewDetailViewController.h"

/** 产品列表Model */
#import "InsuranceListModel.h"
/** 搜索列表Model */
#import "InsuranceSearchModel.h"
//无数据
#import "QLScrollViewExtension.h"

#define Insurance_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"InsuranceData.plist"] // the path of search record cached

@interface InsuranceViewController ()<MoreSearchViewControllerDelegate,MoreSearchViewControllerDataSource,TYTabPagerBarDelegate,TYTabPagerBarDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MoreSearchViewController *moreSearchVC;
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, strong) NSMutableArray *suggestionArr;
//产品类型
@property (nonatomic, strong) NSString *categoryStr;

@property (nonatomic, strong) InsuranceListModel *model;
@property (nonatomic, strong) InsuranceSearchModel *searchModel;

//后台录入保险公司
@property (nonatomic, strong) NSArray *companyArr;

@end

@implementation InsuranceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"保险产品";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    //右侧搜索按钮
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(toSearchVC)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    [self addTabPageBar];
    [self loadData];
    
    [self createUI];
}

#pragma mark - 请求产品搜索列表数据
- (void)requestProductSearchDataWithKeyWord:(NSString *)keyWord {
    WeakSelf
    [[RequestManager sharedInstance]postProductSearchListWithKeyWord:keyWord userId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                [strongSelf.suggestionArr removeAllObjects];
            
                NSArray *arr = TipDic[@"data"][@"list"];
                if (arr.count == 0) {
//                    [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"无更多数据!"];
                    
                }else{
                    for (NSDictionary *temp in arr) {
                        strongSelf.searchModel = [InsuranceSearchModel insuranceSearchListModelWithDictionary:temp];
                        [strongSelf.suggestionArr addObject:strongSelf.searchModel];
                    }
                }
                //得到suggestionArr后再传给MoreSuggestionViewController
                [self requestInfo:self.moreSearchVC];
                
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

#pragma mark - 搜索事件
- (void)toSearchVC{
    //热搜词
    NSArray *hotSeaches = nil;
    //保险公司
    NSArray *hotSeachesArr = self.companyArr;
    
    NSString *HistoryTitle = @"历史搜索：";
    NSMutableArray *titleStrArr;
    if ([hotSeachesArr isEqualToArray:@[]]) {
        titleStrArr =[@[HistoryTitle] mutableCopy];
        
    }else{
        titleStrArr =[@[@"保险公司：",HistoryTitle] mutableCopy];
    }
    MoreSearchViewController *moreSearchVC = [MoreSearchViewController searchViewControllerWithHotSearches:hotSeaches hotComSearcheArr:hotSeachesArr titleSearchArr:titleStrArr  searchBarPlaceholder:@"请输入关键词语" didSearchBlock:^(MoreSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        //点击热搜词等，回调此方法，，直接调用下面的方法
        [self searchViewController:searchViewController searchTextDidChange:searchBar searchText:searchText];
        
    }];
    moreSearchVC.searchHistoriesCachePath = Insurance_SEARCH_HISTORY_CACHE_PATH;
    moreSearchVC.delegate = self;
    moreSearchVC.dataSource = self;
    self.moreSearchVC = moreSearchVC;
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:moreSearchVC];
    [self presentViewController:nav1 animated:YES completion:nil];
}

#pragma mark - MoreSearchViewControllerDelegate
- (void)searchViewController:(MoreSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText{
    [self requestProductSearchDataWithKeyWord:searchText];
//    [self requestInfo:searchViewController];
}

-(void)requestInfo:(MoreSearchViewController *)searchViewController{
    // Simulate a send request to get a search suggestions
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        searchViewController.searchSuggestions = self.suggestionArr;
        
    });
}

#pragma mark - MoreSearchViewControllerDataSource
- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}

- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    InsuranceCell *cell = [searchSuggestionView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[InsuranceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    [cell setSearchListModelWithDictionary:self.suggestionArr[indexPath.row]];
    return cell;
}

#pragma mark - 点击建议VC-->push
-(void)searchViewController:(MoreSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath searchBar:(UISearchBar *)searchBar{
    NSLog(@">>><<%@,,%@",indexPath,searchBar.text);
    // eg：Push to a temp view controller
    InsuranceSearchModel *model = self.suggestionArr[indexPath.row];
    NewDetailViewController *newDetailVC = [[NewDetailViewController alloc]init];
    newDetailVC.Id = model.Id;
    [searchViewController.navigationController pushViewController:newDetailVC animated:YES];
}

#pragma mark - 头部滚动条
- (void)addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, 50)];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.layout.barStyle = TYPagerBarStyleProgressView;
//    tabBar.layout.progressWidth = 60;
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
    NSArray *titleArr = @[@"重疾险",@"年金险",@"终身寿险",@"意外险",@"医疗险",@"一老一小",@"企业团体"];
    _datas = [titleArr copy];
    [self.tabBar reloadData];
    //当前选中index
    [self pagerTabBar:_tabBar didSelectItemAtIndex:self.selectIndex];
    
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
    self.categoryStr = [self changeStrWithIndex:index];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.tabBar.bottom+10, Width_Window, Height_Window-self.tabBar.bottom-10) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc]init];
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
        [self requestProductListDataWithPage:self.page withCategory:self.categoryStr securityType:self.securityTypeStr];
    }];
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    
    self.categoryStr = [self changeStrWithIndex:self.selectIndex];
}

//变换对应类型字段
- (NSString *)changeStrWithIndex:(NSInteger)index{
    //（criticalIllness:重疾险;annuity:年金险; wholeLife:终身寿险;accident:意外险;medical:医疗险;oldSmall:一老一小;enterpriseGroup:企业团体）
    NSString *str;
    if (index == 0) {
        //重疾险
        str = @"criticalIllness";
    }else if (index == 1){
        //年金险
        str = @"annuity";
    }else if (index == 2){
        //终身寿险
        str = @"wholeLife";
    }else if (index == 3){
        //意外险
        str = @"accident";
    }else if (index == 4){
        //医疗险
        str = @"medical";
    }else if (index == 5){
        //一老一小
        str = @"oldSmall";
    }else {
        //index == 6,企业团体
        str = @"enterpriseGroup";
    }
    return str;
}

#pragma mark 上拉刷新
- (void)loadMoreData{
    [self requestProductListDataWithPage:self.page withCategory:self.categoryStr securityType:self.securityTypeStr];
}

#pragma mark 下拉加载更多数据
- (void)loadNewData{
    self.page = 1;
    [self requestProductListDataWithPage:self.page withCategory:self.categoryStr securityType:self.securityTypeStr];
}

#pragma mark - 请求产品列表数据
- (void)requestProductListDataWithPage:(NSInteger)page withCategory:(NSString *)category securityType:(NSString *)securityType{
    WeakSelf
    self.tableView.loading = YES;
    if (self.infoArr == nil) {
        self.infoArr = [[NSMutableArray alloc]init];
        self.page = 1;
    }
    [[RequestManager sharedInstance]postProductListWithPage:page userId:[StoreTool getUserID] category:category securityType:securityType Success:^(id responseData) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                if(page ==1){
                    [strongSelf.infoArr removeAllObjects];
                }
                
                //保险公司
                self.companyArr = TipDic[@"data"][@"companyList"];
                
                NSArray *arr = TipDic[@"data"][@"list"];
                if (arr.count == 0) {
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    strongSelf.page++;
                    for (NSDictionary *temp in arr) {
                        strongSelf.model = [InsuranceListModel insuranceListModelWithDictionary:temp];
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

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.infoArr.count == 0);
    return self.infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    InsuranceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[InsuranceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    [cell setInsuranceListModelWithDictionary:self.infoArr[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InsuranceListModel *model = self.infoArr[indexPath.row];
    NewDetailViewController *newDetailVC = [[NewDetailViewController alloc]init];
    newDetailVC.Id = model.Id;
    [self.navigationController pushViewController:newDetailVC animated:YES];
}

- (NSMutableArray *)suggestionArr{
    if (_suggestionArr == nil) {
        _suggestionArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _suggestionArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
