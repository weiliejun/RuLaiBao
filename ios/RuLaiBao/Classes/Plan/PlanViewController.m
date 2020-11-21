//
//  PlanViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/3/26.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "PlanViewController.h"
#import "Configure.h"
#import "PlanCell.h"
/** 搜索功能 */
#import "MoreSearchViewController.h"
#import "PlanModel.h"
/** 保单详情 */
#import "GuaranteeDetailViewController.h"
//无数据
#import "QLScrollViewExtension.h"


#define Plan_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PlanData.plist"] // the path of search record cached


@interface PlanViewController ()<UITableViewDelegate,UITableViewDataSource,MoreSearchViewControllerDelegate,MoreSearchViewControllerDataSource>
@property (nonatomic, strong) MoreSearchViewController *moreSearchVC;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)UIView *noLoginView;
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, strong) NSMutableArray *suggestionArr;
@property (nonatomic, strong) PlanModel *model;

@end

@implementation PlanViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //先判断是否登录
    if ([StoreTool getLoginStates]) {
        //右侧搜索按钮
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(toSearchVC)];
        self.navigationItem.rightBarButtonItem = searchItem;
        
        [self.noLoginView removeAllSubviews];
        [self requestPlanSearchDataWithCustomerName:@""];
        [self createUI];
        
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        [self.tableView removeAllSubviews];
        [self createNoLoginUI];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"保单规划";
    self.view.backgroundColor = [UIColor customBackgroundColor];
}

#pragma mark - 搜索事件
- (void)toSearchVC{
//    NSArray *hotSeaches = @[@"平安保险", @"人寿保险",@"健康保险", @"平安保险", @"人寿保险"];
    NSArray *hotSeaches = nil;
    NSArray *hotSeachesArr = nil;
//    NSString *hotSearchTitle = @"热搜词：";
    NSString *HistoryTitle = @"历史搜索：";
    NSMutableArray *titleStrArr =[@[HistoryTitle] mutableCopy];
    MoreSearchViewController *moreSearchVC = [MoreSearchViewController searchViewControllerWithHotSearches:hotSeaches hotComSearcheArr:hotSeachesArr titleSearchArr:titleStrArr  searchBarPlaceholder:@"请输入客户姓名" didSearchBlock:^(MoreSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        //点击热搜词等，回调此方法，，直接调用下面的方法
        [self searchViewController:searchViewController searchTextDidChange:searchBar searchText:searchText];
    }];
    moreSearchVC.searchHistoriesCachePath = Plan_SEARCH_HISTORY_CACHE_PATH;
    moreSearchVC.delegate = self;
    moreSearchVC.dataSource = self;
    self.moreSearchVC = moreSearchVC;
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:moreSearchVC];
    [self presentViewController:nav1 animated:YES completion:nil];
}

#pragma mark - MoreSearchViewControllerDelegate
- (void)searchViewController:(MoreSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText{
    if (searchText.length) {
//        //热搜词
//        NSArray *hotArr = @[@"平安保险", @"人寿保险",@"健康保险", @"平安保险", @"人寿保险"];
//        //保险公司
//        NSString *hotStr;
//        if ([hotArr containsObject:searchText]) {
//            hotStr = searchText;
//        }else{
//            hotStr = @"";
//        }
//
        if (searchText.length) {
            [self requestPlanSearchDataWithCustomerName:searchText];
//            [self requestInfo:searchViewController];
        }
    }
}

-(void)requestInfo:(MoreSearchViewController *)searchViewController{
    // Simulate a send request to get a search suggestions
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        searchViewController.searchSuggestions = self.suggestionArr;
    });
}

#pragma mark - MoreSuggestionViewControllerDataSource
- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}

- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    PlanCell *cell = [searchSuggestionView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[PlanCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    [cell setPlanListModelWithDictionary:self.suggestionArr[indexPath.row]];
    cell.backgroundColor = [UIColor customBackgroundColor];
    return cell;
}

#pragma mark - 点击建议VC-->push
-(void)searchViewController:(MoreSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath searchBar:(UISearchBar *)searchBar{
    NSLog(@">>><<%@,,%@",indexPath,searchBar.text);
    // eg：Push to a temp view controller
    //保单详情
    PlanModel *model = self.suggestionArr[indexPath.section];
    GuaranteeDetailViewController *detailVC = [[GuaranteeDetailViewController alloc]init];
    detailVC.orderId = model.orderId;
    [searchViewController.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 设置未登录时界面
- (void)createNoLoginUI{
    UIView *noLoginView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_View_SafeArea-44-49)];
    noLoginView.backgroundColor = [UIColor customBackgroundColor];
    [self.view addSubview:noLoginView];
    self.noLoginView = noLoginView;
    
    UIImageView *noImageView = [[UIImageView alloc]initWithFrame:CGRectMake((Width_Window-70)/2, noLoginView.height/2-100, 70, 70)];
    noImageView.image = [UIImage imageNamed:@"my_header"];
    [noLoginView addSubview:noImageView];
    
    UILabel *warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, noImageView.bottom+10, Width_Window-20, 20)];
    warningLabel.text = @"您还没有登录，请登录后查看";
    warningLabel.textColor = [UIColor customDetailColor];
    warningLabel.font = [UIFont systemFontOfSize:17];
    warningLabel.textAlignment = NSTextAlignmentCenter;
    [noLoginView addSubview:warningLabel];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(30, warningLabel.bottom+50, Width_Window-60, 44)];
    [btn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor customDeepYellowColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 20;
    [btn addTarget:self action:@selector(pressGoLogin:) forControlEvents:UIControlEventTouchUpInside];
    [noLoginView addSubview:btn];
}

//登录/注册
- (void)pressGoLogin:(UIButton *)btn{
    //未登录时候点击列表计划书直接跳转至登录页面
    [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_View_SafeArea-44-49) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        [self requestPlanSearchDataWithCustomerName:@""];
    }];

#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
}

#pragma mark - 请求规划列表&规划搜索列表数据
- (void)requestPlanSearchDataWithCustomerName:(NSString *)customerName{
    WeakSelf
    self.tableView.loading = YES;
    
    if (self.infoArr == nil) {
        self.infoArr = [[NSMutableArray alloc]init];
    }
    [[RequestManager sharedInstance]postPlanSearchWithUserId:[StoreTool getUserID] customerName:customerName Success:^(id responseData) {
        self.tableView.loading = NO;
        
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                [strongSelf.suggestionArr removeAllObjects];
                [strongSelf.infoArr removeAllObjects];
                
                NSArray *arr = TipDic[@"data"][@"list"];
                if (arr.count == 0) {
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    for (NSDictionary *temp in arr) {
                        strongSelf.model = [PlanModel planListModelWithDictionary:temp];
                        [strongSelf.infoArr addObject:strongSelf.model];
                        [strongSelf.suggestionArr addObject:strongSelf.model];
                    }
                }
                //得到suggestionArr后再传给MoreSuggestionViewController
                [self requestInfo:self.moreSearchVC];
                            
                [self.tableView reloadData];
            }else{
//                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
            }
        }else{
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
        }

    } Error:^(NSError *error) {
        self.tableView.loading = NO;
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
    
}

#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
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
    PlanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[PlanCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    [cell setPlanListModelWithDictionary:self.infoArr[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor customBackgroundColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlanModel *model = self.infoArr[indexPath.section];
    GuaranteeDetailViewController *detailVC = [[GuaranteeDetailViewController alloc]init];
    detailVC.orderId = model.orderId;
    [self.navigationController pushViewController:detailVC  animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
