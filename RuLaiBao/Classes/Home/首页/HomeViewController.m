
//  HomeViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/3/26.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewCell.h"
#import "Configure.h"
/** 轮播图 */
#import <SDCycleScrollView.h>
/** 分页视图 */
#import "TYPagerView.h"
#import "TYPagerViewLayout.h"
#import "YYPageView.h"
/** 计划书 */
#import "ProspectusViewController.h"
/** 保险产品 */
#import "InsuranceViewController.h"
/** 保险产品详情 */
//#import "InsuranceDetailViewController.h"
#import "NewDetailViewController.h"
/** WKWebView*/
#import "QLWKWebViewController.h"
/** 轮播图 */
#import "ImageModel.h"
/** 热销 */
#import "HomeViewModel.h"
/** 重磅推荐 */
#import "PageViewModel.h"
/** 手势密码页 */
#import "LockViewController.h"
/** 无数据 */
#import "QLScrollViewExtension.h"


static NSString *sectionHeaderId = @"sectionHeaderId";

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,TYPagerViewDelegate,TYPagerViewDataSource>
/** 表格视图 */
@property (nonatomic, weak) UITableView *tableView;
//tableView的headerView(包含三部分：轮播图，广播，按钮分类)
@property (nonatomic, weak) UIView *headerView;
/** 轮播图 */
@property (nonatomic, weak) SDCycleScrollView *cycleView;
/** 广播和分类按钮所在View */
@property (nonatomic, weak)UIView *BtnView;
/** 小广播底部控件 */
@property (nonatomic, weak) UIControl *broadcastControl;
/** 小广播 */
@property (nonatomic, weak) UILabel *broadcastLabel;
/** 小广播id */
@property (nonatomic, strong) NSString *broadcastId;
/** 分页视图 */
@property (nonatomic, weak) UIView *bgPageView;
@property (nonatomic, weak) TYPagerView *pageView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIPageControl *pageControl;
//轮播图数据
@property (nonatomic, strong) NSMutableArray *cycleArray;
//重磅推荐
@property (nonatomic, strong) NSMutableArray *recommendArray;
//热销
@property (nonatomic, strong) NSMutableArray *sellArray;
@property (nonatomic, strong) ImageModel *imageModel;
@property (nonatomic, strong) HomeViewModel *sellModel;
@property (nonatomic, strong) PageViewModel *recommendModel;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self.cycleView adjustWhenControllerViewWillAppera];
    [self requestHomeListData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//弹出手势密码
-(void)tanchuLock{
    __block UIViewController *SELFVC = self;
    //app开始活动
    if ([StoreTool getLoginStates] && [StoreTool getHandpwd].length !=0) {
        LockViewController *lockVC = [[LockViewController alloc]init];
        lockVC.lockModel = LockModelUnLock;
        lockVC.fromVCType = FromVCTypePresent;
        lockVC.titleStr = @"解锁";
        [SELFVC.navigationController presentViewController:lockVC animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.cycleArray = [NSMutableArray array];
    self.recommendArray = [NSMutableArray array];
    self.sellArray = [NSMutableArray array];
    
    [self createUI];
    
    /**
     *  在此地方添加此方法主要是为了解决向下滑出IOS系统通知、向上滑出系统设置，都会弹出解锁页面此问题
     */
    [self tanchuLock];
}

#pragma mark - 请求首页数据
- (void)requestHomeListData{
    WeakSelf
    self.tableView.loading = YES;
    [[RequestManager sharedInstance]postHomeListWithUserId:[StoreTool getUserID] Success:^(id responseData) {
        self.tableView.loading = NO;
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                NSDictionary *infoDict = TipDic[@"data"];
                [strongSelf.cycleArray removeAllObjects];
                [strongSelf.recommendArray removeAllObjects];
                [strongSelf.sellArray removeAllObjects];
                
                //轮播图数据
                NSArray *cycleArray = infoDict[@"advertiseList"];
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *temp in cycleArray) {
                    strongSelf.imageModel = [ImageModel imageModelWithDictionary:temp];
                    [strongSelf.cycleArray addObject:self.imageModel];
                    
                    NSString *cycleStr = temp[@"picture"];
                    [array addObject:cycleStr];
                }
                //轮播图数据
                strongSelf.cycleView.imageURLStringsGroup = array.copy;
                
                //广播数据
                NSArray *broadcastArr = infoDict[@"bulletinlist"];
               
                if ([broadcastArr isEqualToArray:@[]]) {
                    strongSelf.broadcastLabel.text = @"暂无公告";
                    self.broadcastControl.enabled = NO;
                }else{
                    for (NSDictionary *temp in broadcastArr) {
                        strongSelf.broadcastLabel.text = temp[@"bulletinTopic"];
                        self.broadcastControl.enabled = YES;
                        strongSelf.broadcastId = temp[@"bulletinId"];
                    }
                }

                //重磅推荐数据
                NSArray *recommendArr = infoDict[@"recommendlist"];
                for (NSDictionary *temp in recommendArr) {
                    strongSelf.recommendModel = [PageViewModel pageViewModelWithDictionary:temp];
                    [strongSelf.recommendArray addObject:strongSelf.recommendModel];
                }
                //判断是否有重磅推荐
                if (recommendArr.count != 0) {
                    // 3> 重磅推荐
                    [strongSelf createPageView];
                    //重置 headerView.frame
                    strongSelf.headerView.frame = CGRectMake(self.headerView.frame.origin.x, strongSelf.headerView.frame.origin.y, Width_Window, strongSelf.bgPageView.bottom);
                    
                }else{
                    [strongSelf.bgPageView removeFromSuperview];
                    //重置 headerView.frame
                    strongSelf.headerView.frame = CGRectMake(strongSelf.headerView.frame.origin.x, strongSelf.headerView.frame.origin.y, Width_Window, strongSelf.BtnView.bottom);
                }
                
                [strongSelf tableViewHeaderViewReload];
                [strongSelf loadData];
                
                //热销数据
                NSArray *sellArr = infoDict[@"sellList"];
                if (sellArr.count == 0) {
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    for (NSDictionary *temp in sellArr) {
                        strongSelf.sellModel = [HomeViewModel homeViewModelWithDictionary:temp];
                        [strongSelf.sellArray addObject:strongSelf.sellModel];
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
         [self.tableView.mj_footer endRefreshing];
         [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, Height_Window-Height_View_HomeBar-49) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        [self requestHomeListData];
    }];
    self.tableView = tableView;
    
    /** tableView的headerView(包含三部分：轮播图，广播，按钮分类) */
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 300)];
    headerView.backgroundColor = [UIColor customBackgroundColor];
    tableView.tableHeaderView = headerView;
    self.headerView = headerView;

    #pragma mark - 1> 轮播图
    //动态设置轮播图高度
    CGFloat cycleViewH;
    if (Width_Window == 320) {
        cycleViewH = 150+Height_Statusbar;
    }else if(Width_Window == 375){
        cycleViewH = 203;
    }else{
        cycleViewH = 180+Height_Statusbar;
    }
        
    
    SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Width_Window, cycleViewH) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleView.autoScrollTimeInterval = 3.0f;
    cycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleView.clipsToBounds = YES;
    self.cycleView = cycleView;
    [headerView addSubview:cycleView];
    
    // 2> 广播视图 、分类按钮
    [self createBtnView];
    
    /** 添加footerView */
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width_Window, 40)];
    footLabel.textColor = [UIColor darkGrayColor];
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.font = [UIFont systemFontOfSize:13];
    footLabel.text = @"我也是有底线的";
    tableView.tableFooterView = footLabel;
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
}

#pragma mark - 2> 广播视图 、分类按钮
- (void)createBtnView{
    UIView *BtnView = [[UIView alloc]initWithFrame:CGRectMake(0, self.cycleView.bottom, Width_Window, 200)];
    BtnView.backgroundColor = [UIColor whiteColor];
    self.BtnView = BtnView;
    [self.headerView addSubview:BtnView];
    //广播视图
    UIControl *broadcastControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, Width_Window, 40)];
    broadcastControl.backgroundColor = [UIColor whiteColor];
    [broadcastControl addTarget:self action:@selector(broadcastBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.broadcastControl = broadcastControl;
    [BtnView addSubview:broadcastControl];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 15, 15)];
    imageView.image = [UIImage imageNamed:@"home_notice"];
    [broadcastControl addSubview:imageView];
    
    UILabel *verticalLine = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 1, 30)];
    verticalLine.backgroundColor = [UIColor customLineColor];
    [broadcastControl addSubview:verticalLine];
    
    UILabel *broadcastLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, Width_Window - 45, 39)];
    broadcastLabel.font = [UIFont systemFontOfSize:14];
    broadcastLabel.textColor = [UIColor customDetailColor];
    broadcastLabel.text = @"暂无公告";
    [broadcastControl addSubview:broadcastLabel];
    self.broadcastLabel = broadcastLabel;
    
    UILabel *horizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, Width_Window, 1)];
    horizontalLine.backgroundColor = [UIColor customLineColor];
    [broadcastControl addSubview:horizontalLine];
    
    //分类按钮
    CGFloat ctlWidth = Width_Window/4;
    CGFloat ctlHeight = Width_Window/4-10;
    CGFloat imageWidth = Width_Window/8;
    CGFloat spaceW = Width_Window/16;
    
    NSArray *imageArr = @[@"home_plan",@"home_disease",@"home_aged",@"home_property",@"home_accident",@"home_medical",@"home_oldYoung",@"home_enterprise"];
    NSArray *titleArr = @[@"计划书",@"疾病保障",@"养老保障",@"资产保障",@"意外保障",@"医疗保障",@"一老一小",@"企业团体"];
    
    for (int i = 0; i < 8; i++) {
        UIControl *ctl = [[UIControl alloc]initWithFrame:CGRectMake((i%4)*ctlWidth, broadcastControl.bottom+(i/4)*ctlHeight, ctlWidth, ctlHeight)];
        ctl.backgroundColor = [UIColor clearColor];
        ctl.tag = i+100;
        [ctl addTarget:self action:@selector(ctlClick:) forControlEvents:UIControlEventTouchUpInside];
        [BtnView addSubview:ctl];
        
        UIImageView *ctlImage = [[UIImageView alloc]initWithFrame:CGRectMake(spaceW, 10, imageWidth, imageWidth)];
        ctlImage.image = [UIImage imageNamed:imageArr[i]];
        [ctl addSubview:ctlImage];
        
        UILabel *ctlLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, ctlImage.bottom+5, ctlWidth-20, 20)];
        ctlLabel.text = titleArr[i];
        ctlLabel.textColor = [UIColor customTitleColor];
        ctlLabel.textAlignment = NSTextAlignmentCenter;
        ctlLabel.font = [UIFont systemFontOfSize:14];
        [ctl addSubview:ctlLabel];
    }
    BtnView.frame = CGRectMake(BtnView.frame.origin.x, BtnView.frame.origin.y, Width_Window, ctlHeight*2+broadcastControl.height+10);
    
    //重置 headerView.frame
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, Width_Window, BtnView.bottom);
    [self tableViewHeaderViewReload];
}

//更新tableView的headerView
-(void)tableViewHeaderViewReload{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView layoutIfNeeded];
        [self.tableView setTableHeaderView:self.headerView];
    });
}

#pragma mark - 广播详情
- (void)broadcastBtnClick:(UIControl *)ctl{
    QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
    webVC.titleStr = @"公告详情";
    webVC.urlStr = [NSString stringWithFormat:@"%@://%@/bulletin/detail?id=%@&userId=%@", webHttp, RequestHeader, self.broadcastId, [StoreTool getUserID]];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 分类按钮点击事件
- (void)ctlClick:(UIControl *)ctl{
    switch (ctl.tag) {//计划书
        case 100:
        {
            ProspectusViewController *prospectusVC = [[ProspectusViewController alloc]init];
            [self.navigationController pushViewController:prospectusVC animated:YES];
        }
            break;
        case 101:
        case 102:
        case 103:
        case 104:
        case 105:
        case 106:
        case 107:
        {
            //产品列表
            InsuranceViewController *insuranceVC = [[InsuranceViewController alloc]init];
            if (ctl.tag == 101) {
                //疾病保障：重疾险
                insuranceVC.selectIndex = 0;
            }else if (ctl.tag == 102){
                //养老保障：年金险
                insuranceVC.selectIndex = 1;
            }else if (ctl.tag == 103){
                //资产保障：终身寿险
                insuranceVC.selectIndex = 2;
            }else if (ctl.tag == 104){
                //意外保障：意外险
                insuranceVC.selectIndex = 3;
            }else if (ctl.tag == 105){
                //医疗保障：医疗险
                insuranceVC.selectIndex = 4;
            }else if (ctl.tag == 106){
                // 一老一小：意外险、重疾险、年金险
                insuranceVC.selectIndex = 5;
            }else {
                //企业团体：企业团体（ctl.tag == 107）
                insuranceVC.selectIndex = 6;
            }
            
            //一老一小: oldSmall.如果不是这个保障，不传;
            if (ctl.tag == 106) {
                insuranceVC.securityTypeStr = @"oldSmall";
            }else{
                insuranceVC.securityTypeStr = @"";
            }
            [self.navigationController pushViewController:insuranceVC animated:YES];
        }
            break;
       
        default:
            break;
    }
}

#pragma mark - 3> 重磅推荐
- (void)createPageView{
    UIView *bgPageView = [[UIView alloc]initWithFrame:CGRectMake(0, self.BtnView.bottom+10, Width_Window, 160)];
    bgPageView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:bgPageView];
    _bgPageView = bgPageView;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, Width_Window-30, 20)];
    titleLabel.text = @"重磅推荐";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [bgPageView addSubview:titleLabel];
    
    //横线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.bottom+10, Width_Window, 1)];
    line.backgroundColor = [UIColor customLineColor];
    [bgPageView addSubview:line];
    
    TYPagerView *pageView = [[TYPagerView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom+10, Width_Window, 120)];
    pageView.dataSource = self;
    pageView.delegate = self;
    _pageView = pageView;
    [bgPageView addSubview:pageView];
    
    //分页控件
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(10, pageView.bottom-30, Width_Window-20, 20)];
    pageControl.numberOfPages = self.recommendArray.count;//指定页数
    pageControl.currentPage = 0;//指定pagecontroll的值，默认选中第一个
    pageControl.pageIndicatorTintColor = [UIColor customLineColor];// 设置非选中页的圆点颜色
    pageControl.currentPageIndicatorTintColor = [UIColor customLightYellowColor]; // 设置选中页的圆点颜色
    pageControl.userInteractionEnabled = NO;
    self.pageControl = pageControl;
    [bgPageView addSubview:pageControl];
}

- (void)loadData {
    [self reloadData];
    //更新UI
    [self.pageControl updateCurrentPageDisplay];
}

- (void)reloadData {
    [_pageView reloadData];
}

#pragma mark - TYPagerViewDataSource
- (NSInteger)numberOfViewsInPagerView {
    return self.recommendArray.count;
}

- (UIView *)pagerView:(TYPagerView *)pagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching{
    YYPageView *view = [[YYPageView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 120)];
    [view setPageViewModel:self.recommendArray[index]];
    view.btnClickBlock = ^(NSString *pid) {
        NSLog(@"%@",pid);
        //点击跳转到详情
        PageViewModel *recommendModel = self.recommendArray[index];
//        InsuranceDetailViewController *insuranceDetailVC = [[InsuranceDetailViewController alloc]init];
//        insuranceDetailVC.Id = recommendModel.Id;
        NewDetailViewController *newDetailVC = [[NewDetailViewController alloc]init];
        newDetailVC.Id = recommendModel.Id;
        [self.navigationController pushViewController:newDetailVC animated:YES];
    };
    return view;
}

#pragma mark - TYPagerViewDelegate
- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    //分页控件选中页数等于scrollView当前页数
    self.pageControl.currentPage = toIndex;
//    NSLog(@"fromIndex:%ld, toIndex:%ld",fromIndex,toIndex);
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    NSLog(@"当前轮播的页数 --> %zd", index);
    ImageModel *loopModel = self.cycleArray[index];
    //url:h5页面;product:保险产品详情;none:无跳转
    if ([loopModel.linkType isEqualToString:@"url"]) {
        // h5页面
        QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
        webVC.urlStr = loopModel.targetUrl;
        webVC.titleStr = @"详情";
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else if ([loopModel.linkType isEqualToString:@"product"]){
//        InsuranceDetailViewController *detailVC = [[InsuranceDetailViewController alloc]init];
//        detailVC.Id = loopModel.targetUrl;
//        [self.navigationController pushViewController:detailVC animated:YES];
        NewDetailViewController *newDetailVC = [[NewDetailViewController alloc]init];
        newDetailVC.Id = loopModel.targetUrl;
        [self.navigationController pushViewController:newDetailVC animated:YES];
        
    }
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderId];
    if (headerView == nil){
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:sectionHeaderId];
        headerView.contentView.backgroundColor = [UIColor customBackgroundColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, Width_Window-30, 20)];
        titleLabel.text = @"热销精品";
        titleLabel.textColor = [UIColor customTitleColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [headerView addSubview:titleLabel];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeViewModel *sellModel = self.sellArray[indexPath.row];
    if ([sellModel.recommendations isEqualToString:@""]) {
        return 120;
    }else{
        return 155;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.sellArray.count == 0);
    return self.sellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[HomeViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    [cell setValueforCell:self.sellArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeViewModel *sellModel = self.sellArray[indexPath.row];
//    InsuranceDetailViewController *insuranceDetailVC = [[InsuranceDetailViewController alloc]init];
//    insuranceDetailVC.Id = sellModel.Id;
//    [self.navigationController pushViewController:insuranceDetailVC animated:YES];
    NewDetailViewController *newDetailVC = [[NewDetailViewController alloc]init];
    newDetailVC.Id = sellModel.Id;
    [self.navigationController pushViewController:newDetailVC animated:YES];
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
