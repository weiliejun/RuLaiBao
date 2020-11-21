//
//  CourseDetailViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "Configure.h"

#import "DetailTopView.h"
/** 滚动条 */
#import "TYTabPagerBar.h"
#import "TYPagerController.h"

/** model */
#import "IntroduceModel.h"
/** 自定义分享 */
#import "CustomShareUI.h"

//简介
#import "IntroduceViewController.h"
//目录
#import "DirectoryViewController.h"
//研讨
#import "DiscussionViewController.h"
//PPT
#import "PPTViewController.h"


@interface CourseDetailViewController ()<TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDataSource,TYPagerControllerDelegate>
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;

@property (nonatomic, weak) DetailTopView *topView;

@property (nonatomic, strong) NSArray *tabBarTitleArr;
/** 四个分项的高度设置 */
@property (nonatomic, assign) CGFloat heightBottomView;

@property (nonatomic, strong) IntroduceModel *detailModel;
@end

@implementation CourseDetailViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.topView reloadWebViewUrl];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"课程详情";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain  target:self action:@selector(ShareQuestionItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self addTopmediaView];
    [self addTabPageBar];
    [self addPagerController];
    [self loadData];
    
    NSAssert(self.courseId.length != 0, @"id不能为空");
    self.tabBarTitleArr = @[@"简介",@"目录",@"研讨",@"PPT"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
}

#pragma mark - 此代码纯粹为了解决视频全屏后横屏然后在返回时的布局错误
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
}

-(void)endFullScreen {
    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
-(BOOL)prefersStatusBarHidden{
    return !UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}
#pragma mark - 接入热点
- (void)adjustStatusBar{
    CGFloat height =  Height_Window - Height_Statusbar-self.tabBar.bottom-1-44;
    CGRect frame = self.pagerController.view.frame;
    frame.size.height = height;
    self.pagerController.view.frame = frame;
}
#pragma mark - share
-(void)ShareQuestionItem{
    //判断model是否有值
    if (self.detailModel == nil) {
        return;
    }
    NSString *shareUrl = [NSString stringWithFormat:@"http://%@/appCourse/detail/share/content/%@",RequestHeader,self.courseId];
    NSString *shareTitle = [NSString stringWithFormat:@"%@",self.detailModel.courseName];
    NSString *shareDes = [NSString stringWithFormat:@"演讲人：%@\n课程类型：%@\n课程时间：%@",self.detailModel.realName,self.detailModel.typeName,self.detailModel.courseTime];
    [CustomShareUI shareWithUrl:shareUrl Title:shareTitle DesStr:shareDes];
}
#pragma mark - 头部视频
-(void)addTopmediaView{
    DetailTopView *topView = [[DetailTopView alloc]initWithFrame:CGRectMake(0, 0, Width_Window,Width_Window * 9/16)];
    [self.view addSubview:topView];
    _topView = topView;
}
#pragma mark - 中间滚动条
- (void)addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]initWithFrame:CGRectMake(0, self.topView.bottom+1, Width_Window, 48)];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.collectionView.scrollEnabled = NO;
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.layout.progressWidth = 60;
    tabBar.layout.normalTextColor = [UIColor customTitleColor];
    tabBar.layout.normalTextFont = [UIFont systemFontOfSize:18];
    tabBar.layout.selectedTextColor = [UIColor customNavBarColor];
    tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:18];
    tabBar.layout.progressColor = [UIColor customDeepYellowColor];
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.cellEdging = 0;
    tabBar.layout.cellWidth = Width_Window/4;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}
- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.view.frame = CGRectMake(0, self.tabBar.bottom+1, Width_Window, Height_Window-self.tabBar.bottom-1);
    self.heightBottomView = Height_Window - Height_Statusbar -44-self.tabBar.bottom-1;
    pagerController.layout.prefetchItemCount = 0;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}

- (void)loadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return 4;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.tabBarTitleArr[index];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource
-(NSInteger)numberOfControllersInPagerController {
    return 4;
}
-(UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    return [self pagerViewCForIndex:index];
}

#pragma mark - TYPagerControllerDelegate
-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}
-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}
-(UIViewController *)pagerViewCForIndex:(NSInteger)index{
    if (index == 0) {
        IntroduceViewController *vc = [[IntroduceViewController alloc]init];
        vc.courseDetailId = self.courseId;
        vc.viewHeight = self.heightBottomView;
        vc.courseVideoBlock = ^(IntroduceModel *model, BOOL isHaveData) {
            if (isHaveData) {
                self.detailModel = model;
                self.topView.urlStr = model.courseVideo;
            }else{
                [self createErrorDataAlertVC];
            }
        };
        return vc;
    }else if (index == 1){
        DirectoryViewController *vc = [[DirectoryViewController alloc]init];
        vc.speechmakeId = self.speechmakeId;
        vc.viewHeight = self.heightBottomView;
        return vc;
    }else if (index == 2){
        DiscussionViewController *vc = [[DiscussionViewController alloc]init];
        vc.courseDetailId = self.courseId;
        vc.speechmanId = self.speechmakeId;
        vc.viewHeight = self.heightBottomView;
        return vc;
    }else{
        PPTViewController *vc = [[PPTViewController alloc]init];
        vc.courseDetailId = self.courseId;
        vc.viewHeight = self.heightBottomView;
        return vc;
    }
}

#pragma mark - error弹框
-(void)createErrorDataAlertVC{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:KCourseDetailDataRemoved preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *errorAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if(self.noDataBlock != nil){
            self.noDataBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:errorAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
