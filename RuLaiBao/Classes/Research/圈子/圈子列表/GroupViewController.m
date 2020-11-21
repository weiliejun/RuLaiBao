//
//  GroupViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/11.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "GroupViewController.h"
#import "Configure.h"
//无数据
#import "QLScrollViewExtension.h"

#import "GroupTableViewCell.h"
#import "GroupDetailViewController.h"

/** model */
#import "GroupListInterModel.h"
#import "GroupListModel.h"

@interface GroupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

/** 圈子列表数组 */
@property (nonatomic, strong) NSMutableArray *groupListArr;
@property (nonatomic, strong) NSMutableArray *groupShowBtnArr;
@property (nonatomic, strong) NSMutableArray *groupSectionTitleArr;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部圈子";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createUI];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 登录退出接收通知
- (void)checklogin:(NSNotification *)notification{
    //请求数据
    [self requestGroupDataWithUserID:[StoreTool getUserID]];
}
#pragma mark - 释放观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 接入热点
- (void)adjustStatusBar{
    CGFloat height =  Height_View_SafeArea - 44;
    CGRect frame = self.tableView.frame;
    frame.size.height = height;
    self.tableView.frame = frame;
}
#pragma mark - 请求数据
-(void)requestGroupDataWithUserID:(NSString *)userId{
    WeakSelf
    self.tableView.loading = YES;
    [[RequestManager sharedInstance]postGroupListWithUserID:userId Success:^(id responseData) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                NSDictionary *TipDic = dict[@"data"];
                GroupListInterModel *groupAllModel = [GroupListInterModel yy_modelWithDictionary:TipDic];
                [strongSelf handleDataArr:groupAllModel];
            } else {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}
/** 处理数组数据 */
-(void)handleDataArr:(GroupListInterModel *)groupAllModel{
    //处理顶部tabbar数组
    [self.groupListArr removeAllObjects];
    [self.groupShowBtnArr removeAllObjects];
    [self.groupSectionTitleArr removeAllObjects];
    
    if (groupAllModel.myAppCircle.count != 0) {
        [self.groupShowBtnArr addObject:@"no"];
        [self.groupSectionTitleArr addObject:@"我的圈子"];
        [self.groupListArr addObject:groupAllModel.myAppCircle];
    }
    if (groupAllModel.myJoinAppCircle.count != 0) {
        [self.groupShowBtnArr addObject:@"no"];
        [self.groupSectionTitleArr addObject:@"我加入的圈子"];
        [self.groupListArr addObject:groupAllModel.myJoinAppCircle];
    }
    if (groupAllModel.myRecomAppCircle.count != 0) {
        [self.groupShowBtnArr addObject:@"yes"];
        [self.groupSectionTitleArr addObject:@"推荐圈子"];
        [self.groupListArr addObject:groupAllModel.myRecomAppCircle];
    }
    //刷新
    [self.tableView reloadData];
}
#pragma mark - 申请加入圈子
-(void)requestGroupApplyjoinDataWithCircleId:(NSString *)circleId{
    if (![StoreTool getLoginStates]) {
        //未登录时候跳转至登录页面
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checklogin:)name:KNotificationLoginSuccess object:nil];
        return;
    }
    if (![StoreTool getCheckStatusForSuccess]) {
        //未认证先认证
        [JumpToSellCertifyVCTool jumpToSellCertifyVCWithFatherViewController:self];
        return;
    }
    WeakSelf
    [[RequestManager sharedInstance]postGroupDetailApplyJoinWithUserID:[StoreTool getUserID] GroupId:circleId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
                //重新请求数据刷新UI
                [strongSelf requestGroupDataWithUserID:[StoreTool getUserID]];
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
#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_View_SafeArea-44) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    adjustsScrollViewInsets_NO(tableView, self);
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 10)];
    //底部10
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -10, 0);
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        [self requestGroupDataWithUserID:[StoreTool getUserID]];
    }];
    
    _tableView = tableView;
}
/** 下拉刷新 */
-(void)loadNewData{
    [self requestGroupDataWithUserID:[StoreTool getUserID]];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groupListArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.groupListArr[section];
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor customBackgroundColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:16.0];
    headerLabel.textColor = [UIColor customTitleColor];
    headerLabel.text = [NSString stringWithFormat:@"    %@",self.groupSectionTitleArr[section]];
    return headerLabel;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[GroupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    [cell InfoModel:self.groupListArr[indexPath.section][indexPath.row] showBtn:self.groupShowBtnArr[indexPath.section]];
    cell.controlClick = ^(GroupListModel *cellModel) {
        NSLog(@"%@>>",cellModel.circleName);
        [self requestGroupApplyjoinDataWithCircleId:cellModel.circleId];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupDetailViewController *groupDetailVC = [[GroupDetailViewController alloc]init];
    groupDetailVC.listModel = self.groupListArr[indexPath.section][indexPath.row];
    groupDetailVC.noDataBlock = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:groupDetailVC animated:YES];
}

#pragma mark - 懒
-(NSMutableArray *)groupListArr{
    if (_groupListArr == nil) {
        NSMutableArray *groupArr = [NSMutableArray arrayWithCapacity:10];
        _groupListArr = groupArr;
    }
    return _groupListArr;
}
-(NSMutableArray *)groupShowBtnArr{
    if (_groupShowBtnArr == nil) {
        NSMutableArray *showBtnArr = [NSMutableArray arrayWithCapacity:3];
        _groupShowBtnArr = showBtnArr;
    }
    return _groupShowBtnArr;
}
-(NSMutableArray *)groupSectionTitleArr{
    if (_groupSectionTitleArr == nil) {
        NSMutableArray *sectionTitleArr = [NSMutableArray arrayWithCapacity:3];
        _groupSectionTitleArr = sectionTitleArr;
    }
    return _groupSectionTitleArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
