//
//  CourseViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "CourseViewController.h"
#import "Configure.h"

/** 滚动条 */
#import "TYTabPagerBar.h"
//无数据
#import "QLScrollViewExtension.h"
//cell
#import "CourseTableViewCell.h"
//详情
#import "CourseDetailViewController.h"

/** list的model */
#import "CourseListModel.h"
/** 中间处理用model */
#import "CoursePageBarModel.h"

@interface CourseViewController ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) UITableView *tableView;

/** 头部tabpagebar的数组 */
@property (nonatomic, strong) NSMutableArray *courseTabBarArr;
/** 课程数组 */
@property (nonatomic, strong) NSMutableArray *courseListArr;

@property (nonatomic, copy) NSString *currentCourseType;
/** 课程listpage */
@property (nonatomic, assign) NSInteger listPage;
/** 只让显示一次 */
@property (nonatomic, assign) BOOL isFirstShowType;

@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"课程";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self addTabPageBar];
    [self createUI];
    self.isFirstShowType = YES;
    
    self.listPage = 1;
    self.currentCourseType = @"";
    [self requestCourseDataWithPage:self.listPage typeCode:self.currentCourseType];
}
#pragma mark - 接入热点
- (void)adjustStatusBar{
    CGFloat height =  Height_View_SafeArea-50-44;
    CGRect frame = self.tableView.frame;
    frame.size.height = height;
    self.tableView.frame = frame;
}
#pragma mark - 请求数据
-(void)requestCourseDataWithPage:(NSInteger)listPage typeCode:(NSString *)typeCode{
    WeakSelf
    self.tableView.loading = YES;
    [[RequestManager sharedInstance]postCourseListWithPage:listPage TypeCode:typeCode Success:^(id responseData) {
        self.tableView.loading = NO;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if(listPage == 1){
                [strongSelf.courseListArr removeAllObjects];
            }
            NSDictionary *TipDic = dict[@"data"];

            CourseListInterModel *courseAllModel = [CourseListInterModel yy_modelWithDictionary:TipDic];
        
            if (self.isFirstShowType) {
                if(courseAllModel.courseTypeList.count != 0){
                    //处理顶部tabbar数组
                    [strongSelf.courseTabBarArr removeAllObjects];
                    CoursePageBarModel *pageModel = [CoursePageBarModel yy_modelWithDictionary:@{@"typeCode":@"",@"typeName":@"全部课程"}];
                    [strongSelf.courseTabBarArr addObject:pageModel];
                    [strongSelf.courseTabBarArr addObjectsFromArray:courseAllModel.courseTypeList];
                    //刷新
                    [strongSelf.tabBar reloadData];
                }
                self.isFirstShowType = NO;
            }
            
            if(courseAllModel.courseList.count == 0){
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"无更多数据!"];
            }else{
                self.listPage ++;
                //数据处理
                [strongSelf.courseListArr addObjectsFromArray:courseAllModel.courseList];
            }
            [strongSelf.tableView reloadData];
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
    tabBar.layout.cellSpacing = 10;
    tabBar.layout.progressColor = [UIColor customDeepYellowColor];
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.courseTabBarArr.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    CoursePageBarModel *pageModel = self.courseTabBarArr[index];
    cell.titleLabel.text = pageModel.typeName;
    return cell;
}

#pragma mark - TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    CoursePageBarModel *pageModel = self.courseTabBarArr[index];
    NSString *title = pageModel.typeName;
    return [pagerTabBar cellWidthForTitle:title]+10;
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    if (index == pagerTabBar.curIndex) {
        return;
    }
    [pagerTabBar scrollToItemFromIndex:pagerTabBar.curIndex toIndex:index animate:YES];
    CoursePageBarModel *pageModel = self.courseTabBarArr[index];
    self.listPage = 1;
    self.currentCourseType = pageModel.typeCode;
    [self requestCourseDataWithPage:self.listPage typeCode:self.currentCourseType];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.tabBar.bottom, Width_Window, Height_View_SafeArea-self.tabBar.height-44) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
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
        self.listPage = 1;
        [self requestCourseDataWithPage:self.listPage typeCode:self.currentCourseType];
    }];
}
/** 下拉刷新 */
-(void)loadNewData{
    self.listPage = 1;
    [self requestCourseDataWithPage:self.listPage typeCode:self.currentCourseType];
}
/** 上啦加载更多 */
-(void)loadMoreData{
    [self requestCourseDataWithPage:self.listPage typeCode:self.currentCourseType];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.courseListArr.count == 0);
    return self.courseListArr.count;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Width_Window/2+60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[CourseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.cellInfoModel = self.courseListArr[indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourseDetailViewController *courseDetailVC = [[CourseDetailViewController alloc]init];
    CourseListModel *infoModel = self.courseListArr[indexPath.section];
    courseDetailVC.courseId = infoModel.courseId;
    courseDetailVC.speechmakeId = infoModel.speechmakeId;
    courseDetailVC.noDataBlock = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:courseDetailVC animated:YES];
}

#pragma mark - 数组懒加载
-(NSMutableArray *)courseTabBarArr{
    if (_courseTabBarArr == nil) {
        NSMutableArray *courseArr = [NSMutableArray arrayWithCapacity:10];
        _courseTabBarArr = courseArr;
    }
    return _courseTabBarArr;
}
-(NSMutableArray *)courseListArr{
    if (_courseListArr == nil) {
        NSMutableArray *courseArr = [NSMutableArray arrayWithCapacity:10];
        _courseListArr = courseArr;
    }
    return _courseListArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

