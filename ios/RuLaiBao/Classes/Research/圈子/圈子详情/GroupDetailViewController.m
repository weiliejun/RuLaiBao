//
//  GroupDetailViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/11.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "Configure.h"
#import "WRNavigationBar.h"
//无数据
#import "RLBListNoDataTipView.h"

#import "GroupDetailTopView.h"
#import "GroupDetailTopCell.h"
#import "GroupDetailTableViewCell.h"

//话题详情
#import "GroupTopicViewController.h"
//发布话题
#import "PublishTopicViewController.h"
//权限
#import "GroupLimitViewController.h"

/** model */
#import "GroupListModel.h"
#import "GroupDetailInterModel.h"
#import "GroupDetailTopicModel.h"


#define NAVBAR_COLORCHANGE_POINT 120

static NSString *topCellId = @"topCellId";
static NSString *cellId = @"cellId";
static NSString *footerViewID = @"detailQuestionFooterView";

@interface GroupDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, strong) GroupDetailTopView *topView;
@property (nonatomic, strong) RLBListNoDataTipView *noDataFooterView;

/** 顶部view + section 0 的数据 */
@property (nonatomic, strong) GroupDetailInterModel *detailAllModel;
/** 底部话题列表的数组 */
@property (nonatomic, strong) NSMutableArray *topicDataArr;
@property (nonatomic, assign) NSInteger topicListPage;

@end

@implementation GroupDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self wr_setNavBarShadowImageHidden:YES];
    
    [self requestGroupDetailData];
    self.topicListPage = 1;
    [self requestGroupDetailTopicListDataWithPage:self.topicListPage];
    [self scrollViewDidScroll:self.tableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"圈子";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self createUI];
    [self createBottomBtn];
    
    [self wr_setNavBarTitleColor:[UIColor clearColor]];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:0];
}
#pragma mark - 接入热点
- (void)adjustStatusBar{
    CGFloat height = Height_Window-Height_View_HomeBar-Height_Statusbar_HotSpot-44;
    CGRect frame = self.tableView.frame;
    frame.size.height = height;
    self.tableView.frame = frame;
    
    self.bottomView.frame = CGRectMake(0, Height_Window-Height_Statusbar_HotSpot-Height_View_HomeBar-44, Width_Window, 44+Height_View_HomeBar);
}
#pragma mark - error弹框
-(void)createErrorDataAlertVC{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:KGroupDetailDataRemoved preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *errorAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if(self.noDataBlock != nil){
            self.noDataBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:errorAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - 请求圈子详情 & 置顶数据
-(void)requestGroupDetailData{
    WeakSelf
    [[RequestManager sharedInstance]postGroupDetailWithUserID:[StoreTool getUserID] GroupId:self.listModel.circleId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                GroupDetailInterModel *detailAllModel = [GroupDetailInterModel yy_modelWithDictionary:TipDic];
                strongSelf.detailAllModel = detailAllModel;
                
                [strongSelf reloadTableHeaderViewData:detailAllModel.appCircle];
                //刷新
                [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [strongSelf createErrorDataAlertVC];
            }
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark -- 请求话题列表
-(void)requestGroupDetailTopicListDataWithPage:(NSInteger)listPage{
    WeakSelf
    [[RequestManager sharedInstance]postGroupDetailTopicListWithUserID:[StoreTool getUserID] GroupId:self.listModel.circleId ListPage:listPage Success:^(id responseData) {
        [self.tableView.mj_footer endRefreshing];
        
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                if(strongSelf.topicListPage == 1){
                    [strongSelf.topicDataArr removeAllObjects];
                }
                
                NSArray *arr = TipDic[@"appTopics"];
                if([arr count] == 0){
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//                    [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"无更多数据!"];
                }else{
                    strongSelf.topicListPage ++;
                    
                    for (NSDictionary *temp in arr) {
                        GroupDetailTopicModel *hotlistModel = [GroupDetailTopicModel yy_modelWithDictionary:temp];
                        [strongSelf.topicDataArr addObject:hotlistModel];
                    }
                }
                //对第二组赋值
                [strongSelf.tableView reloadData];
            } else {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}
#pragma mark - -点赞
-(void)requestGroupDetailLikeData:(NSString *)topicId fatherCell:(GroupDetailTableViewCell *)cell{
    if (![StoreTool getLoginStates]) {
        //未登录时候跳转至登录页面
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
        return;
    }
    if (![self.detailAllModel.appCircle.isJoin isEqualToString:@"yes"]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请您加入该圈子后再进行相关操作..."];
        return;
    }
    [[RequestManager sharedInstance]postGroupTopicDetailLikeWithUserID:[StoreTool getUserID] TopicId:topicId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                cell.isLikeSelect = YES;
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
#pragma mark - 申请加入圈子
-(void)requestGroupApplyjoinDataWithCircleId:(NSString *)circleId{
    WeakSelf
    [[RequestManager sharedInstance]postGroupDetailApplyJoinWithUserID:[StoreTool getUserID] GroupId:circleId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
                //重新请求数据刷新UI
                [strongSelf requestGroupDetailData];
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
#pragma mark - 申请退出圈子
-(void)requestGroupApplyOutDataWithCircleId:(NSString *)circleId{
    WeakSelf
    [[RequestManager sharedInstance]postGroupDetailApplyOutWithUserID:[StoreTool getUserID] GroupId:circleId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
                //重新请求数据刷新UI
                [strongSelf requestGroupDetailData];
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
#pragma mark - UI
-(void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, Height_Window-Height_Statusbar_HotSpot-Height_View_HomeBar-44) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedRowHeight = 150;
    [tableView registerClass:[GroupDetailTopCell class] forCellReuseIdentifier:topCellId];
    [tableView registerClass:[GroupDetailTableViewCell class] forCellReuseIdentifier:cellId];
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:footerViewID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    adjustsScrollViewInsets_NO(tableView, self);
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    CGFloat imageWH = 120;
    CGFloat imageX =(Width_Window - imageWH) / 2;
    CGFloat imageY =  30;
    CGFloat titleY = 30 + imageWH ;
    RLBListNoDataTipView *noDataFooterView = [[RLBListNoDataTipView alloc]
                                              initWithFrame:CGRectMake(0, 0, Width_Window, 200)
                                              backgroundColor:[UIColor clearColor]
                                              imageFrame:CGRectMake(imageX, imageY, imageWH, imageWH)
                                              imageName:@"NoData"
                                              titleFrame:CGRectMake(10, titleY,Width_Window - 20, 30)
                                              tipText:@"暂无话题"];
    tableView.tableFooterView = noDataFooterView;
    _noDataFooterView = noDataFooterView;
    
    //头部详情
    GroupDetailTopView *topView = [[GroupDetailTopView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 105+Height_Statusbar+44)];
    tableView.tableHeaderView = topView;
    topView.topSetBtnClickBlock = ^(TopSetBtnType btnType) {
        [self topBtnClick:btnType];
    };
    /** 进行tableHeaderView 的自适应高度变换 */
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.equalTo(tableView);
    }];
    _topView = topView;
    
    [self reloadTableHeaderViewData:self.listModel];
}
-(void)reloadTableHeaderViewData:(GroupListModel *)model{
    //刷新TableHeaderView
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topView.detailTopModel = model;
        [self.tableView layoutIfNeeded];
        [self.tableView setTableHeaderView:self.topView];
    });
}
-(void)reloadTableFooterViewData:(UIView *)footerView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView layoutIfNeeded];
        [self.tableView setTableFooterView:footerView];
    });
}
/** 上啦加载更多 */
-(void)loadMoreData{
    [self requestGroupDetailTopicListDataWithPage:self.topicListPage];
}

#pragma mark - 顶部按钮点击
-(void)topBtnClick:(TopSetBtnType)btnType{
    if (![StoreTool getLoginStates]) {
        //未登录时候跳转至登录页面
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
        return;
    }
    if(btnType == TopSetBtnTypeSet){
        //权限
        GroupLimitViewController *limitVC = [[GroupLimitViewController alloc]init];
        limitVC.auditStatus = self.detailAllModel.appCircle.isNeedAduit;
        limitVC.circleID = self.listModel.circleId;
        [self.navigationController pushViewController:limitVC animated:YES];
    }else if(btnType == TopSetBtnTypeJoin){
        //加入
        if (![StoreTool getCheckStatusForSuccess]) {
            //未认证先认证
            [JumpToSellCertifyVCTool jumpToSellCertifyVCWithFatherViewController:self];
            return;
        }
        [self requestGroupApplyjoinDataWithCircleId:self.listModel.circleId];
    }else if(btnType == TopSetBtnTypeOut){
        //退出
        //已登录未认证时提示：请通过认证后在进行该操作！   取消/去认证
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确认退出\"%@\"吗？",self.detailAllModel.appCircle.circleName] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *certifyAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self requestGroupApplyOutDataWithCircleId:self.listModel.circleId];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:certifyAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

#pragma mark - 底部btn
-(void)createBottomBtn{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Window-Height_Statusbar_HotSpot-44-Height_View_HomeBar, Width_Window, 44+Height_View_HomeBar)];
    bottomView.backgroundColor = [UIColor customDeepYellowColor];
    [self.view addSubview:bottomView];
    
    UIButton *askBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bottomView.width, 40)];
    [askBtn setTitle:@"发布话题" forState:UIControlStateNormal];
    [askBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [askBtn addTarget:self action:@selector(askBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:askBtn];
    
    _bottomView = bottomView;
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
    if (![self.detailAllModel.appCircle.isJoin isEqualToString:@"yes"]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请您加入该圈子后再进行相关操作..."];
        return;
    }
    PublishTopicViewController *publishTopicVC = [[PublishTopicViewController alloc]init];
    publishTopicVC.circleID = self.listModel.circleId;
    [self.navigationController pushViewController:publishTopicVC animated:YES];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.detailAllModel.topAppTopics.count;
    }else{
        //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
        self.tableView.mj_footer.hidden = (self.topicDataArr.count == 0);
        self.tableView.tableFooterView.hidden = (self.topicDataArr.count != 0);
        if (self.topicDataArr.count == 0) {
            [self reloadTableFooterViewData:self.noDataFooterView];
        }else{
            [self reloadTableFooterViewData:nil];
        }
        return self.topicDataArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0.1;
    }else{
        return 10;
    }
}
#pragma mark - 无数据
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GroupDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellId forIndexPath:indexPath];
        GroupDetailTopicModel *topModel = self.detailAllModel.topAppTopics[indexPath.row];
        cell.titleStr = topModel.topicContent;
        return cell;
    }else{
        GroupDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        cell.controlClick = ^(GroupDetailCellControlType index, GroupDetailTableViewCell *detailCell) {
            //点赞
            [self requestGroupDetailLikeData:detailCell.groupDetailModel.topicId fatherCell:detailCell];
        };
        cell.groupDetailModel = self.topicDataArr[indexPath.row];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupTopicViewController *topicVC = [[GroupTopicViewController alloc]init];
    if (indexPath.section == 0) {
        topicVC.topicDetailModel = self.detailAllModel.topAppTopics[indexPath.row];
    }else{
        topicVC.topicDetailModel = self.topicDataArr[indexPath.row];
    }
    
    [self.navigationController pushViewController:topicVC animated:YES];
}

#pragma mark - navgationBar
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0)
    {
        CGFloat alpha = offsetY / NAVBAR_COLORCHANGE_POINT;
        [self wr_setNavBarBackgroundAlpha:alpha];
        [self wr_setNavBarTintColor:[[UIColor customNavBarColor] colorWithAlphaComponent:alpha]];
        [self wr_setNavBarTitleColor:[[UIColor customNavBarColor] colorWithAlphaComponent:alpha]];
        if (offsetY >= NAVBAR_COLORCHANGE_POINT) {
            [self wr_setNavBarShadowImageHidden:NO];
            [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
        }else{
            [self wr_setNavBarShadowImageHidden:YES];
            [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
        }
    }
    else{
        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
        [self wr_setNavBarBackgroundAlpha:0];
        [self wr_setNavBarTintColor:[UIColor whiteColor]];
        [self wr_setNavBarTitleColor:[UIColor clearColor]];
    }
}
#pragma mark - 懒
-(NSMutableArray *)topicDataArr{
    if (_topicDataArr == nil) {
        NSMutableArray *topicArr = [NSMutableArray arrayWithCapacity:10];
        _topicDataArr = topicArr;
    }
    return _topicDataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

