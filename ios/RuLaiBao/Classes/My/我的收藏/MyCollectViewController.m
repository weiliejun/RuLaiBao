//
//  MyCollectViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyCollectViewController.h"
#import "Configure.h"
/** 滚动条 */
#import "TYTabPagerBar.h"
#import "MyCollectCell.h"
#import "MyCollectionModel.h"
//保险产品详情
//#import "InsuranceDetailViewController.h"
#import "NewDetailViewController.h"
//无数据
#import "QLScrollViewExtension.h"


@interface MyCollectViewController ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, assign) NSInteger page;
//产品类型
@property (nonatomic, strong) NSString *categoryStr;
@property (nonatomic, strong) MyCollectionModel *model;
@property (nonatomic, strong) NSDictionary *collectionDict;
/** 收藏状态 */
@property (nonatomic, strong) NSString *dataStatus;
/** 收藏id */
@property (nonatomic, strong) NSString *collectionId;

@end

@implementation MyCollectViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    [self requestMyCollectionListDataWithPage:self.page category:self.categoryStr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self addTabPageBar];
    [self loadData];
    [self createUI];
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
    //（accident:意外险;criticalIllness:重疾险;annuity:年金险;medical:医疗险; wholeLife:终身寿险;enterpriseGroup:企业团体）
    NSArray *titleArr = @[@"全部",@"重疾险",@"年金险",@"终身寿险",@"意外险",@"医疗险",@"一老一小",@"企业团体"];
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
    self.categoryStr = [self changeStrWithIndex:index];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar+50, Width_Window, Height_Window-Height_Statusbar_NavBar-50) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [tableView.mj_header beginRefreshing];
    [self.view addSubview: tableView];
    
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        self.page = 1;
        [self requestMyCollectionListDataWithPage:self.page category:self.categoryStr];
    }];
    
    self.tableView = tableView;
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    
    self.categoryStr = [self changeStrWithIndex:0];
    self.dataStatus = @"invalid";
}

#pragma mark 上拉刷新
- (void)loadMoreData{
    [self requestMyCollectionListDataWithPage:self.page category:self.categoryStr];
}

#pragma mark 下拉加载更多数据
- (void)loadNewData{
    self.page = 1;
    [self requestMyCollectionListDataWithPage:self.page category:self.categoryStr];
}

#pragma mark - 请求我的收藏列表数据
- (void)requestMyCollectionListDataWithPage:(NSInteger)page category:(NSString *)category{
    WeakSelf
    self.tableView.loading = YES;
    if (self.infoArr == nil) {
        self.infoArr = [[NSMutableArray alloc]init];
        self.page = 1;
    }
    [[RequestManager sharedInstance]postMyCollectionWithCategory:category page:page userId:[StoreTool getUserID] Success:^(id responseData) {
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
                
                NSArray *arr = TipDic[@"data"][@"list"];
                if (arr.count == 0) {
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    strongSelf.page++;
                    for (NSDictionary *temp in arr) {
                        strongSelf.model = [MyCollectionModel collectionListModelWithDictionary:temp];
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

//变换对应类型字段
- (NSString *)changeStrWithIndex:(NSInteger)index{
    //（accident:意外险;criticalIllness:重疾险;annuity:年金险;medical:医疗险; wholeLife:终身寿险;enterpriseGroup:企业团体）
    NSString *str;
    if (index == 0){
        //全部
        str = @"";
    }else if (index == 1) {
        //重疾险
        str = @"criticalIllness";
    }else if (index == 2){
        //年金险
        str = @"annuity";
    }else if (index == 3){
        //终身寿险
        str = @"wholeLife";
    }else if (index == 4){
        //意外险
        str = @"accident";
    }else if (index == 5){
        //医疗险
        str = @"medical";
    }else if (index == 6){
        //一老一小
        str = @"oldSmall";
    }else{
        //index ==7 企业团体
        str = @"enterpriseGroup";
    }
    return str;
}

#pragma mark - 请求收藏，取消收藏数据
- (void)requestCollectionDataWithProductId:(NSString *)productId collectionId:(NSString *)collectionId dataStatus:(NSString *)dataStatus{
    WeakSelf
    [[RequestManager sharedInstance]postCollectionWithDataStatus:dataStatus collectionId:collectionId productId:productId userId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            strongSelf.collectionDict = TipDic[@"data"];
            
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",self.collectionDict[@"message"]]];
        }else{
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
        }
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - TableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor customBackgroundColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
    MyCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[MyCollectCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    [cell setCollectionListModelWithDictionary:self.infoArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到产品详情
    MyCollectionModel *model = self.infoArr[indexPath.row];
//    InsuranceDetailViewController *detailVC = [[InsuranceDetailViewController alloc]init];
//    detailVC.Id = model.productId;
//    [self.navigationController pushViewController:detailVC animated:YES];
    NewDetailViewController *newDetailVC = [[NewDetailViewController alloc]init];
    newDetailVC.Id = model.productId;
    [self.navigationController pushViewController:newDetailVC animated:YES];
}

#pragma mark - 侧拉删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            //tableView取消编辑状态
            [self.tableView setEditing:NO animated:YES];
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            MyCollectionModel *model = self.infoArr[indexPath.section];
            //收藏按钮点击事件
            [self requestCollectionDataWithProductId:model.productId collectionId:model.collectionId dataStatus:self.dataStatus];
            
            [self.infoArr removeObjectAtIndex:indexPath.section];
            [self.tableView reloadData];
            
        }];
        [alertC addAction:cancelAction];
        [alertC addAction:sureAction];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"您确定要删除吗?"];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attStr.length)];
        [alertC setValue:attStr forKey:@"attributedMessage"];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
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
