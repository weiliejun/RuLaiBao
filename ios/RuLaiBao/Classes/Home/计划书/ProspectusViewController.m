//
//  ProspectusViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/2.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "ProspectusViewController.h"
#import "Configure.h"
#import "ProspectusCell.h"
/** 保险公司按钮 */
#import "SelectBtnView.h"
/** 搜索功能 */
#import "MoreSearchViewController.h"
/** 销售认证 */
#import "SellCertifyViewController.h"
/** 计划书列表Model */
#import "ProspectusModel.h"
/** 搜索列表Model */
#import "SearchListModel.h"
/** webView */
#import "QLWKWebViewController.h"
//无数据
#import "QLScrollViewExtension.h"


#define Prospectus_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ProspectusData.plist"] // the path of search record cached

@interface ProspectusViewController ()<UITableViewDelegate,UITableViewDataSource,SelectBtnViewDelegate,MoreSearchViewControllerDelegate,MoreSearchViewControllerDataSource>
@property (nonatomic, strong) MoreSearchViewController *moreSearchVC;
@property (nonatomic, weak) UITableView *tableView;
/** 条件按钮所在view */
@property (nonatomic, strong) SelectBtnView *btnView;
/** 选择按钮名称 */
@property (nonatomic, strong) NSArray *btnTitleArr;

/** 选择按钮种类数组 */
@property (nonatomic, strong) NSString *selectStr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, strong) ProspectusModel *model;
@property (nonatomic, strong) NSMutableArray *suggestionArr;

@end

@implementation ProspectusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"计划书";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    //右侧搜索按钮
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(toSearchVC)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    [self createUI];
}

#pragma mark - 请求搜索列表数据
- (void)requestSearchDataWithName:(NSString *)name{
    WeakSelf
    [[RequestManager sharedInstance]postProSearchListWithName:name userId:[StoreTool getUserID] Success:^(id responseData) {
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
                        strongSelf.model = [ProspectusModel prospectusListModelWithDictionary:temp];
                        [strongSelf.suggestionArr addObject:strongSelf.model];
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
//    NSArray *hotSeaches = @[@"平安保险", @"人寿保险",@"健康保险", @"平安保险", @"人寿保险"];
    NSArray *hotSeaches = nil;
    NSArray *hotSeachesArr = nil;
//    NSString *hotSearchTitle = @"热搜词：";
    NSString *HistoryTitle = @"历史搜索：";
    NSMutableArray *titleStrArr =[@[HistoryTitle] mutableCopy];
    MoreSearchViewController *moreSearchVC = [MoreSearchViewController searchViewControllerWithHotSearches:hotSeaches hotComSearcheArr:hotSeachesArr titleSearchArr:titleStrArr  searchBarPlaceholder:@"请输入关键词语" didSearchBlock:^(MoreSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        //点击热搜词等，回调此方法，，直接调用下面的方法
        [self searchViewController:searchViewController searchTextDidChange:searchBar searchText:searchText];
        
    }];
    moreSearchVC.searchHistoriesCachePath = Prospectus_SEARCH_HISTORY_CACHE_PATH;
    moreSearchVC.delegate = self;
    moreSearchVC.dataSource = self;
    self.moreSearchVC = moreSearchVC;
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:moreSearchVC];
    nav1.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav1 animated:YES completion:nil];
}

#pragma mark - MoreSearchViewControllerDelegate
- (void)searchViewController:(MoreSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText{
    if (searchText.length) {
        [self requestSearchDataWithName:searchText];
//        [self requestInfo:searchViewController];
    }
}

-(void)requestInfo:(MoreSearchViewController *)searchViewController{
    // Simulate a send request to get a search suggestions
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        searchViewController.searchSuggestions = self.suggestionArr;
    });
}

#pragma mark - MoreSearchViewControllerDataSource
- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
    
}

- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    ProspectusCell *cell = [searchSuggestionView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[ProspectusCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    [cell setSearchListModelWithDictionary:self.suggestionArr[indexPath.row]];
    
    return cell;
}

#pragma mark - 点击建议VC-->push
- (void)searchViewController:(MoreSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath searchBar:(UISearchBar *)searchBar{
    NSLog(@">>><<%@,,%@",indexPath,searchBar.text);
    // eg：Push to a temp view controller
    if (![StoreTool getLoginStates]) {
        //未登录时候点击列表计划书直接跳转至登录页面
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:searchViewController methodType:LogInAppearTypePresent];
    }else {//登录
        if ([StoreTool getCheckStatusForSuccess]){
            SearchListModel *model = self.suggestionArr[indexPath.row];
            QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
            webVC.urlStr = [NSString stringWithFormat:@"%@",model.prospectus];
            webVC.isRightItem2Share = YES;
            webVC.shareTitle = [NSString stringWithFormat:@"%@",model.name];
            webVC.shareDesStr = [NSString stringWithFormat:@"%@",model.recommendations];
            webVC.titleStr = @"计划书";
            [searchViewController.navigationController pushViewController:webVC animated:YES];
        }else{
            //已登录未认证时提示：请通过认证后在进行该操作！   取消/去认证
            [JumpToSellCertifyVCTool jumpToSellCertifyVCWithFatherViewController:searchViewController];
        }
    }
}

#pragma mark - 设置界面元素
- (void)createUI{
    //1、创建tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar+10+44, Width_Window, Height_Window-Height_Statusbar_NavBar-54) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        [self requestDataWithPage:self.page withCompanyName:self.selectStr];
    }];
    
    self.tableView = tableView;

#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    
    //2、创建保险按钮
    SelectBtnView *btnView = [[SelectBtnView alloc]initWithBtnStr:@"保险公司"];
    btnView.backgroundColor = [UIColor clearColor];
    self.btnView = btnView;
    btnView.delegate = self;
    [self.view addSubview:btnView];
    
    self.selectStr = @"";
}

#pragma mark - 按钮点击事件
- (void)selectViewBtnClick:(NSMutableString *)string{
    self.selectStr = string;
//    NSLog(@"---%@",string);
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 上拉刷新
- (void)loadMoreData{
    [self requestDataWithPage:self.page withCompanyName:self.selectStr];
}

#pragma mark 下拉加载更多数据
- (void)loadNewData{
    self.page = 1;
    [self requestDataWithPage:self.page withCompanyName:self.selectStr];
    
}

#pragma mark - 请求计划书列表数据
- (void)requestDataWithPage:(NSInteger)page withCompanyName:(NSString *)companyName{
    WeakSelf
    self.tableView.loading = YES;
    if (self.infoArr == nil) {
        self.infoArr = [[NSMutableArray alloc]init];
        self.page = 1;
    }
    [[RequestManager sharedInstance]postProspectusListWithPage:page companyName:companyName userId:[StoreTool getUserID] Success:^(id responseData) {
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
                
                //设置下拉框数据
                self.btnTitleArr = TipDic[@"data"][@"companyList"];
                self.btnView.titleArray = self.btnTitleArr;
                
                NSArray *arr = TipDic[@"data"][@"list"];
                if (arr.count == 0) {
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    strongSelf.page++;
                    for (NSDictionary *temp in arr) {
                        strongSelf.model = [ProspectusModel prospectusListModelWithDictionary:temp];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
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
    ProspectusCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[ProspectusCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    [cell setProspectusModelWithDictionary:self.infoArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![StoreTool getLoginStates]) {
        //未登录时候点击列表计划书直接跳转至登录页面
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
    }else {//登录
        if ([StoreTool getCheckStatusForSuccess]){
            //认证成功
            ProspectusModel *model = self.infoArr[indexPath.row];
            QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
            webVC.urlStr = model.prospectus;
            webVC.isRightItem2Share = YES;
            webVC.shareTitle = [NSString stringWithFormat:@"%@",model.name];
            webVC.shareDesStr = [NSString stringWithFormat:@"%@",model.recommendations];
            webVC.titleStr = @"计划书";
            [self.navigationController pushViewController:webVC animated:YES];
        }else {
            //已登录未认证时提示：请通过认证后在进行该操作！   取消/去认证
            [JumpToSellCertifyVCTool jumpToSellCertifyVCWithFatherViewController:self];
        }
    }
}

-(NSMutableArray *)suggestionArr{
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
