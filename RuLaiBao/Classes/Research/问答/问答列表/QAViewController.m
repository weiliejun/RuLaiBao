//
//  QAViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/9.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "QAViewController.h"
#import "Configure.h"

/** 滚动条 */
#import "TYTabPagerBar.h"
//无数据
#import "QLScrollViewExtension.h"
//cell
#import "QATableViewCell.h"

#import "QADetailViewController.h"
//我要提问
#import "QuestionUserViewController.h"

#import "QAListModel.h"
#import "QAPageBarModel.h"

@interface QAViewController ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *bottomBgView;

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSArray *infoData;

/** 头部tabpagebar的数组 */
@property (nonatomic, strong) NSMutableArray *QATabBarArr;
/** 课程数组 */
@property (nonatomic, strong) NSMutableArray *QAListArr;

@property (nonatomic, copy) NSString *currentQAType;

/** 课程listpage */
@property (nonatomic, assign) NSInteger QAListPage;

@end

@implementation QAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"问答";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self addTabPageBar];
    [self createUI];
    //底部提问按钮
    [self createBottomBtn];
    
    self.QAListPage = 1;
    self.currentQAType = @"";
    [self requestQADataWithPage:self.QAListPage typeCode:self.currentQAType];
    [self requestQATypeData];
}

#pragma mark - 接入热点
- (void)adjustStatusBar{
    CGFloat height =  Height_View_SafeArea-self.tabBar.height-44-44;
    CGRect frame = self.tableView.frame;
    frame.size.height = height;
    self.tableView.frame = frame;
    self.bottomBgView.frame = CGRectMake(0, self.tableView.bottom, Width_Window, 44+Height_View_HomeBar);
}
#pragma mark - 请求tabBar类型列表
-(void)requestQATypeData{
    WeakSelf
    [[RequestManager sharedInstance]postQAListTypeSuccess:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                NSArray *arr = TipDic[@"list"];
                
                if(arr.count != 0){
                    QAPageBarModel *pageModel = [QAPageBarModel yy_modelWithDictionary:@{@"typeCode":@"",@"typeName":@"全部问答"}];
                    [strongSelf.QATabBarArr addObject:pageModel];
                }
                
                for (NSDictionary *temp in arr) {
                    QAPageBarModel *typelistModel = [QAPageBarModel yy_modelWithDictionary:temp];
                    [strongSelf.QATabBarArr addObject:typelistModel];
                }
                //刷新
                [strongSelf.tabBar reloadData];
            } else {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}
#pragma mark - 请求数据
-(void)requestQADataWithPage:(NSInteger)listPage typeCode:(NSString *)typeCode{
    WeakSelf
    self.tableView.loading = YES;
    [[RequestManager sharedInstance]postQAListWithPage:listPage TypeCode:typeCode Success:^(id responseData) {
        self.tableView.loading = NO;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                if(listPage == 1){
                    [strongSelf.QAListArr removeAllObjects];
                }
                
                NSArray *arr = TipDic[@"list"];
                if(arr.count == 0){
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    self.QAListPage ++;
                    for (NSDictionary *temp in arr) {
                        QAListModel *listModel = [QAListModel yy_modelWithDictionary:temp];
                        [strongSelf.QAListArr addObject:listModel];
                    }
                }
                
                [strongSelf.tableView reloadData];
            } else {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        self.tableView.loading = NO;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 头部滚动条
- (void)addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 50)];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.layout.barStyle = TYPagerBarStyleProgressView;
//    tabBar.layout.progressWidth = 60;
    tabBar.layout.normalTextColor = [UIColor customTitleColor];
    tabBar.layout.normalTextFont = [UIFont systemFontOfSize:17];
    tabBar.layout.selectedTextColor = [UIColor customNavBarColor];
    tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:17];
    tabBar.layout.progressColor = [UIColor customDeepYellowColor];
    tabBar.layout.cellSpacing = 10;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.QATabBarArr.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    QAPageBarModel *pageModel = self.QATabBarArr[index];
    cell.titleLabel.text = pageModel.typeName;
    return cell;
}

#pragma mark - TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    QAPageBarModel *pageModel = self.QATabBarArr[index];
    NSString *title = pageModel.typeName;
    return [pagerTabBar cellWidthForTitle:title]+10;
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    if (index == pagerTabBar.curIndex) {
        return;
    }
    [pagerTabBar scrollToItemFromIndex:pagerTabBar.curIndex toIndex:index animate:YES];
    QAPageBarModel *pageModel = self.QATabBarArr[index];
    self.QAListPage = 1;
    self.currentQAType = pageModel.typeCode;
    [self requestQADataWithPage:self.QAListPage typeCode:self.currentQAType];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.tabBar.bottom, Width_Window, Height_View_SafeArea-self.tabBar.height-44-44) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 170;
    adjustsScrollViewInsets_NO(tableView, self);
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        self.QAListPage = 1;
        [self requestQADataWithPage:self.QAListPage typeCode:self.currentQAType];
    }];
}
/** 下拉刷新 */
-(void)loadNewData{
    self.QAListPage = 1;
    [self requestQADataWithPage:self.QAListPage typeCode:self.currentQAType];
}
/** 上啦加载更多 */
-(void)loadMoreData{
    [self requestQADataWithPage:self.QAListPage typeCode:self.currentQAType];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.QAListArr.count == 0);
    return self.QAListArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor customBackgroundColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    QATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[QATableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.cellInfoModel = self.QAListArr[indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QADetailViewController *QADetailVC = [[QADetailViewController alloc]init];
    QAListModel *model = self.QAListArr[indexPath.section];
    QADetailVC.questionId = model.questionId;
    QADetailVC.noDataBlock = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:QADetailVC animated:YES];
}

#pragma mark - 底部btn
-(void)createBottomBtn{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.bottom, Width_Window, 44+Height_View_HomeBar)];
    bgView.backgroundColor = [UIColor customDeepYellowColor];
    [self.view addSubview:bgView];
    
    UIButton *askBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, bgView.width-20, 44)];
    [askBtn setTitle:@"我要提问" forState:UIControlStateNormal];
    [askBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [askBtn addTarget:self action:@selector(askBtnClick) forControlEvents:UIControlEventTouchUpInside];
    askBtn.backgroundColor = [UIColor customDeepYellowColor];
    [bgView addSubview:askBtn];
    
    _bottomBgView = bgView;
}
-(void)askBtnClick{
    if (![StoreTool getLoginStates]) {
        //未登录时候跳转至登录页面
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
        return;
    }
    if (![StoreTool getCheckStatusForSuccess]) {
        //未认证先认证
        [JumpToSellCertifyVCTool jumpToSellCertifyVCWithFatherViewController:self];
        return;
    }
    //提问
    if(self.QATabBarArr.count == 1 || self.QATabBarArr.count == 0){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"暂无问答类型"];
        return;
    }
    QuestionUserViewController *questionVC = [[QuestionUserViewController alloc]init];
    questionVC.strArray = self.QATabBarArr;
    questionVC.addBlock = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:questionVC animated:YES];
}

#pragma mark - 数组懒加载
-(NSMutableArray *)QATabBarArr{
    if (_QATabBarArr == nil) {
        NSMutableArray *QAArr = [NSMutableArray arrayWithCapacity:10];
        _QATabBarArr = QAArr;
    }
    return _QATabBarArr;
}
-(NSMutableArray *)QAListArr{
    if (_QAListArr == nil) {
        NSMutableArray *QAArr = [NSMutableArray arrayWithCapacity:10];
        _QAListArr = QAArr;
    }
    return _QAListArr;
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
