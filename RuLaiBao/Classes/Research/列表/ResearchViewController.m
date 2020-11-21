//
//  ResearchViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/3/26.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "ResearchViewController.h"
#import "configure.h"
#import "WRNavigationBar.h"

/** 头部按钮 */
#import "ResearchModulesView.h"
/** 最新课程 */
#import "ResearchCollectHeaderView.h"
/** collection的headerView */
#import "CourseHeaderView.h"
/** 底部无数据时展示 */
#import "CourseFooterView.h"

/** 精品课程的cell */
#import "CourseCollectionViewCell.h"
/** 热门问答的cell */
#import "QACollectionViewCell.h"

/** model */
#import "ResearchModel.h"
/** 底部热门回答model */
#import "ResearchHotListModel.h"

#import "CourseListModel.h"

/*!
 跳转部分
 */
//课程VC
#import "CourseViewController.h"
//问答VC
#import "QAViewController.h"
//圈子
#import "GroupViewController.h"

/** 课程详情 */
#import "CourseDetailViewController.h"
/** 问答详情 */
#import "QADetailViewController.h"

static NSString *CourseCellID = @"CourseCollectionViewCell";
static NSString *QACellID = @"QACollectionViewCell";
static NSString *courseHeaderView = @"CourseHeaderView";
static NSString *courseFooterView = @"CourseFooterView";

#define minimumInteritemSpacing 10.f

@interface ResearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** 上次选中的索引(或者控制器) */
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@property (nonatomic, weak) UICollectionView *collectionView;

/** 课程推荐 */
@property (nonatomic, weak) ResearchCollectHeaderView *collectHeaderView;
/** 课程推荐model */
@property (nonatomic, strong) CourseListModel *headerCourseModel;
/** 第一组数组 */
@property (nonatomic, strong) NSMutableArray *sectionOneArr;
/** 第二组数组 */
@property (nonatomic, strong) NSMutableArray *sectionTwoArr;

/** 换一换page */
@property (nonatomic, assign) NSInteger changePage;
/** 换一换总的page数 */
@property (nonatomic, assign) NSInteger changePageCount;
/** 热门问答page */
@property (nonatomic, assign) NSInteger hotListPage;

@property (nonatomic, assign) BOOL isOneEndRequest;
@property (nonatomic, assign) BOOL isTwoEndRequest;

@property (nonatomic, strong) MJRefreshNormalHeader *headerRefresh;

@end

@implementation ResearchViewController

-(void)dealloc{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self wr_setNavBarShadowImageHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //监听tabbar点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarDidRepeatSeleted) name:KNotificationTabBarDidSelected object:nil];
    
    [self createUI];
    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark - 接入热点
- (void)adjustStatusBar{
    if (Height_Statusbar == 0) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    CGFloat height = Height_View_SafeArea - 110-44-49;
    CGRect frame = self.collectionView.frame;
    frame.size.height = height;
    self.collectionView.frame = frame;
}

-(void)firstRequestData{
    self.changePage = 1;
    self.changePageCount = 2;
    self.hotListPage = 1;
    self.isOneEndRequest = NO;
    self.isTwoEndRequest = NO;
    [self requestAllData];
    [self collectBottomloadMoreData];
}
#pragma mark - 首次进请求数据
-(void)requestAllData{
    WeakSelf
    [[RequestManager sharedInstance]postResearchIndexSuccess:^(id responseData) {
        NSDictionary *dict = responseData;
        self.isOneEndRequest = YES;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            
            NSDictionary *TipDic = dict[@"data"];
            ResearchModel *researchModel = [ResearchModel yy_modelWithDictionary:TipDic];
            //对header赋值
            strongSelf.headerCourseModel = researchModel.courseRecommend;
//            strongSelf.collectHeaderView.infoModel = ;
            
            strongSelf.sectionOneArr = [researchModel.qualityCourseList mutableCopy];
            //对第一组赋值
            [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
        [self endRefersh];
    } Error:^(NSError *error) {
        self.isOneEndRequest = YES;
        [self endRefersh];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 请求换一换数据
-(void)requestInfoData:(CourseHeaderView *)view{
    WeakSelf
    self.changePage = (self.changePage +1) % self.changePageCount == 0 ? (self.changePage +1) % self.changePageCount + self.changePageCount :(self.changePage +1) % self.changePageCount;
    [[RequestManager sharedInstance]postResearchChangeCourseWithPage:self.changePage Success:^(id responseData) {
        NSDictionary *dict = responseData;
        view.isAnimation = NO;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            //处理page总数
            strongSelf.changePageCount = ([TipDic[@"count"] integerValue]+3)/4 == 0 ? 1 : ([TipDic[@"count"] integerValue]+3)/4;
            
            ResearchModel *researchModel = [ResearchModel yy_modelWithDictionary:TipDic];
            strongSelf.sectionOneArr = [researchModel.qualityCourseList mutableCopy];
            //对第一组赋值
            [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        view.isAnimation = NO;
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 请求更多
-(void)collectBottomloadMoreData{
    WeakSelf
    [[RequestManager sharedInstance]postResearchQuestionHotListWithPage:self.hotListPage Success:^(id responseData) {
        StrongSelf
        strongSelf.isTwoEndRequest = YES;
        
        [strongSelf.collectionView.mj_footer endRefreshing];
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            if(strongSelf.hotListPage == 1){
                [self.sectionTwoArr removeAllObjects];
            }
            
            NSDictionary *TipDic = dict[@"data"];
            NSArray *arr = TipDic[@"list"];
            if([arr count] == 0){
                [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                strongSelf.hotListPage ++;
                for (NSDictionary *temp in arr) {
                    ResearchHotListModel *hotlistModel = [[ResearchHotListModel alloc]initHotListModelWithDic:temp];
                    [self.sectionTwoArr addObject:hotlistModel];
                }
                //对第二组赋值
//                [strongSelf.collectionView reloadData];
                [UIView performWithoutAnimation:^{
                    [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
                }];
            }
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
        [strongSelf endRefersh];
    } Error:^(NSError *error) {
        self.isTwoEndRequest = YES;
        [self endRefersh];
        [self.collectionView.mj_footer endRefreshing];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}
//判断footer是否隐藏，判断footer停止刷新时显示"加载更多"还是"全部数据已加载完成"
-(void)checkFooterStatus {
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.collectionView.mj_footer.hidden = (self.sectionTwoArr.count == 0);
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.sectionOneArr.count;
    }else{
        [self checkFooterStatus];
        return self.sectionTwoArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CourseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CourseCellID forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.cellInfoModel = self.sectionOneArr[indexPath.row];
        return cell;
    }else{
        QACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QACellID forIndexPath:indexPath];
        cell.cellInfoModel = self.sectionTwoArr[indexPath.row];
        return cell;
    }
}
//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //先通过kind类型判断是头还是尾巴，然后在判断是哪一组，如果都是一样的头尾，那么只要第一次判断就可以了
    if (kind == UICollectionElementKindSectionHeader){
        CourseHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:courseHeaderView forIndexPath:indexPath];
        headerView.indexPath = indexPath;
        __weak typeof(headerView) weakheaderView = headerView;
        headerView.exchangeBtnBlock = ^{
            [self requestInfoData:weakheaderView];
        };
        return headerView;
    }else{
        CourseFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:courseFooterView forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat itemW = Width_Window  * 0.5;
        return (CGSize){itemW,itemW/2+60};
    }else{
        ResearchHotListModel *eachModel = self.sectionTwoArr[indexPath.item];
        return eachModel.itemSize;
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return minimumInteritemSpacing;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeZero;
    }else{
        if (self.sectionTwoArr.count == 0) {
            return CGSizeMake(Width_Window, 200);
        }
        return CGSizeZero;
    }
}

#pragma mark - 点击跳转
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        CourseDetailViewController *courseDetailVC = [[CourseDetailViewController alloc]init];
        CourseListModel *infoModel = self.sectionOneArr[indexPath.row];
        courseDetailVC.courseId = infoModel.courseId;
        courseDetailVC.speechmakeId = infoModel.speechmakeId;
        [self.navigationController pushViewController:courseDetailVC animated:YES];
    }else{
        QADetailViewController *QADetailVC = [[QADetailViewController alloc]init];
        //转换model
        ResearchHotListModel *hotModel = self.sectionTwoArr[indexPath.row];
        QADetailVC.questionId = hotModel.questionId;
        QADetailVC.noDataBlock = ^{
            self.hotListPage = 1;
            [self collectBottomloadMoreData];
        };
        [self.navigationController pushViewController:QADetailVC animated:YES];
    }
}

#pragma mark - 创建UI
-(void)createUI{
    ResearchModulesView *modulesView = [[ResearchModulesView alloc]initWithFrame:CGRectMake(0, 10, Width_Window, 100)];
    modulesView.controlClick = ^(ControlType index) {
        //点击四个标签的回调
        [self selectTopFourTagView:index];
    };
    [self.view addSubview:modulesView];
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置头
    layout.headerReferenceSize = CGSizeMake(Width_Window, 44);
    // 设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //2.初始化collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, modulesView.bottom , Width_Window, Height_View_SafeArea - modulesView.bottom-44-49) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    // 隐藏指示器
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    adjustsScrollViewInsets_NO(collectionView, self);
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [collectionView registerClass:[CourseCollectionViewCell class] forCellWithReuseIdentifier:CourseCellID];
    [collectionView registerClass:[QACollectionViewCell class] forCellWithReuseIdentifier:QACellID];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [collectionView registerClass:[CourseHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:courseHeaderView];
    [collectionView registerClass:[CourseFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:courseFooterView];
    
    //4.设置代理
    collectionView.delegate = self;
    collectionView.dataSource = self;

    //5.添加头部视图-->类似于tableview的tableheaderview
    CGFloat headerHeight= Width_Window/2+60;
    ResearchCollectHeaderView *collectHeaderView = [[ResearchCollectHeaderView alloc]initWithFrame:CGRectMake(0, - headerHeight, Width_Window, headerHeight)];
    collectHeaderView.controlClick = ^{
        //点击课程推荐的回调
        CourseDetailViewController *courseDetailVC = [[CourseDetailViewController alloc]init];
        
        CourseListModel *infoModel = self.headerCourseModel;
        courseDetailVC.courseId = infoModel.courseId;
        courseDetailVC.speechmakeId = infoModel.speechmakeId;
        
        [self.navigationController pushViewController:courseDetailVC animated:YES];
    };
    [collectionView addSubview: collectHeaderView];
    //默认为空
    collectHeaderView.hidden = YES;
    
    MJRefreshNormalHeader *headerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.headerRefresh = headerRefresh;
    collectionView.mj_header = headerRefresh;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(collectBottomloadMoreData)];
    collectionView.mj_footer = footer;
    // Set title
    [footer setTitle:@"^_^点击查看更多问答" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载，请稍后..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多问答" forState:MJRefreshStateNoMoreData];
    
    _collectionView = collectionView;
    _collectHeaderView = collectHeaderView;
}
-(void)isShowcollectHeaderView{
    if (self.headerCourseModel.courseId != nil) {
        self.collectHeaderView.infoModel = self.headerCourseModel;
        self.collectHeaderView.hidden = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView layoutIfNeeded];
            //忽略值
            self.headerRefresh.ignoredScrollViewContentInsetTop = Width_Window/2+60;
            //ContentInset 添加顶部高度  44为刷新控件的高度
            self.collectionView.contentInset = UIEdgeInsetsMake(Width_Window/2+60, 0, 44, 0);
            [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.collectHeaderView.hidden = YES;
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
            self.headerRefresh.ignoredScrollViewContentInsetTop = 0;
        });
    }
}
#pragma mark - 下拉刷新
-(void)loadNewData{
    [self firstRequestData];
}
-(void)endRefersh{
    //只有两个请求都结束时，才停止刷新
    if (self.isOneEndRequest && self.isTwoEndRequest) {
        [self.collectionView.mj_header endRefreshingWithCompletionBlock:^{
            [self isShowcollectHeaderView];
        }];
    }
}
#pragma mark - 顶部四个跳转
-(void)selectTopFourTagView:(ControlType)index{
    switch (index) {
        case ControlTypeCourse:{
            //课程
            CourseViewController *courseVC = [[CourseViewController alloc]init];
            [self.navigationController pushViewController:courseVC animated:YES];
        }
            break;
        case ControlTypeQA:{
            //问答
            QAViewController *QAVC = [[QAViewController alloc]init];
            [self.navigationController pushViewController:QAVC animated:YES];
        }
            break;
        case ControlTypeGroup:{
            //圈子
            GroupViewController *groupVC = [[GroupViewController alloc]init];
            [self.navigationController pushViewController:groupVC animated:YES];
        }
            break;
        case ControlTypeFuture:{
            //展业
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"此功能暂未开通，敬请期待！"];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 重复点击请求数据
// 接收到通知实现方法
- (void)tabBarDidRepeatSeleted {
    // 如果是连续选中2次, 直接刷新
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex && [self isShowingOnKeyWindow]) {
        //直接写刷新代码
        [self.collectionView.mj_header beginRefreshing];
    }
    // 记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}
/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.view.frame fromView:self.view.superview];
    CGRect winBounds = keyWindow.bounds;
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    return !self.view.isHidden && self.view.alpha > 0.01 && self.view.window == keyWindow && intersects;
}

#pragma mark - 懒加载
-(NSMutableArray *)sectionOneArr{
    if (_sectionOneArr == nil) {
        NSMutableArray *sectionArr = [NSMutableArray arrayWithCapacity:10];
        _sectionOneArr = sectionArr;
    }
    return _sectionOneArr;
}
-(NSMutableArray *)sectionTwoArr{
    if (_sectionTwoArr == nil) {
        NSMutableArray *sectionArr = [NSMutableArray arrayWithCapacity:10];
        _sectionTwoArr = sectionArr;
    }
    return _sectionTwoArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
