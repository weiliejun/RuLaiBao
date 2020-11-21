//
//  MyTakepartViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/18.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyTakepartViewController.h"
#import "Configure.h"
//滚动条 
#import "TYTabPagerBar.h"
#import "MyTakepartCell.h"
#import "MyAskedModel.h"
#import "MyTalkModel.h"
//问答详情
#import "QADetailViewController.h"
#import "QAListModel.h"
//话题详情
#import "GroupTopicViewController.h"
#import "GroupDetailTopicModel.h"
//无数据
#import "QLScrollViewExtension.h"


@interface MyTakepartViewController ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, weak)  UITableView *tableView;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) NSInteger askPage;
@property (nonatomic, strong) NSMutableArray *askArr;
@property (nonatomic, strong) MyAskedModel *askModel;

@property (nonatomic, assign) NSInteger talkPage;
@property (nonatomic, strong) NSMutableArray *talkArr;
@property (nonatomic, strong) MyTalkModel *talkModel;

@end

@implementation MyTakepartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我参与的";
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
    NSArray *titleArr = @[@"提问",@"话题"];
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
    return Width_Window/2-10;
    
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [pagerTabBar scrollToItemFromIndex:pagerTabBar.curIndex toIndex:index animate:NO];
//    NSLog(@"选中>>>%@,index==%ld",self.datas[index],index);
    self.selectIndex = index;
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
        if (self.selectIndex == 0) {
            self.askPage = 1;
            [self requestMyAskedListDataWithPage:self.askPage];
        }else{
            self.talkPage = 1;
            [self requestMyTalkListDataWithPage:self.talkPage];
        }
    }];
    self.tableView = tableView;
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
}

#pragma mark 上拉刷新
- (void)loadMoreData{
    if (self.selectIndex == 0) {
        [self requestMyAskedListDataWithPage:self.askPage];
    }else{
        [self requestMyTalkListDataWithPage:self.talkPage];
    }
}

#pragma mark 下拉加载更多数据
- (void)loadNewData{
    if (self.selectIndex == 0) {
        self.askPage = 1;
        [self requestMyAskedListDataWithPage:self.askPage];
    }else{
        self.talkPage = 1;
        [self requestMyTalkListDataWithPage:self.talkPage];
    }
}

#pragma mark - 请求提问列表数据
- (void)requestMyAskedListDataWithPage:(NSInteger)page{
    WeakSelf
    self.tableView.loading = YES;
    if (self.askArr == nil) {
        self.askArr = [[NSMutableArray alloc]init];
        self.askPage = 1;
    }
    [[RequestManager sharedInstance]postMyTakepartAsklistWithPage:page userId:[StoreTool getUserID] Success:^(id responseData) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                if(page == 1){
                    [strongSelf.askArr removeAllObjects];
                }
            
                NSArray *arr = TipDic[@"data"][@"list"];
                if (arr.count == 0) {
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    strongSelf.askPage++;
                    for (NSDictionary *temp in arr) {
                        strongSelf.askModel = [MyAskedModel myAskedListModelWithDictionary:temp];
                        [strongSelf.askArr addObject:strongSelf.askModel];
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

#pragma mark - 请求话题列表数据
- (void)requestMyTalkListDataWithPage:(NSInteger)page{
    WeakSelf
    self.tableView.loading = YES;
    if (self.talkArr == nil) {
        self.talkArr = [[NSMutableArray alloc]init];
        self.talkPage = 1;
    }
    [[RequestManager sharedInstance]postMyTakepartTalklistWithPage:page userId:[StoreTool getUserID] Success:^(id responseData) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                if(page == 1){
                    [strongSelf.talkArr removeAllObjects];
                }
                
                NSArray *arr = TipDic[@"data"][@"list"];
                if (arr.count == 0) {
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    strongSelf.talkPage++;
                    for (NSDictionary *temp in arr) {
                        strongSelf.talkModel = [MyTalkModel myTalkListModelWithDictionary:temp];
                        [strongSelf.talkArr addObject:strongSelf.talkModel];
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
    if (self.selectIndex == 0) {
        //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
        self.tableView.mj_footer.hidden = (self.askArr.count == 0);
        return self.askArr.count;
    }else{
        //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
        self.tableView.mj_footer.hidden = (self.talkArr.count == 0);
        return self.talkArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    MyTakepartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[MyTakepartCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    
    if (self.selectIndex == 0) {
        //提问
        [cell setAskedListModelWithDictionary:self.askArr[indexPath.row]];
    }else{
        //话题
        [cell setTalkListModelWithDictionary:self.talkArr[indexPath.row]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex == 0) {
        //问答详情
        QADetailViewController *detailVC = [[QADetailViewController alloc]init];
        MyAskedModel *model = self.askArr[indexPath.row];
        detailVC.questionId = model.questionId;
        detailVC.noDataBlock = ^{
            [self.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else{
        //话题详情
        MyTalkModel *model = self.talkArr[indexPath.row];
        NSDictionary *dict = [model yy_modelToJSONObject];
        GroupTopicViewController *detailVC = [[GroupTopicViewController alloc]init];
        detailVC.topicDetailModel = [GroupDetailTopicModel yy_modelWithDictionary:dict];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
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
