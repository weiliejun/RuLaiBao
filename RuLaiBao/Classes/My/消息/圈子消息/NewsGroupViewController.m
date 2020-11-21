//
//  NewsGroupViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "NewsGroupViewController.h"
#import "Configure.h"
//无数据
#import "QLScrollViewExtension.h"

#import "NewsGroupTableViewCell.h"
#import "NewsGroupApplyModel.h"

static NSString *const NewsGroupCellIden = @"newsGroupCell";

@interface NewsGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 主view */
@property (nonatomic, weak) UITableView *tableView;
/** 主默认数组(左边title) */
@property (nonatomic, strong) NSMutableArray *newsInfoArr;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation NewsGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"圈子新成员";
    [self createUI];
    
    self.pageNum = 1;
    self.newsInfoArr = [NSMutableArray arrayWithCapacity:20];
    
}
#pragma mark - 请求数据
-(void)requestGroupApplyListDataWithPage:(NSInteger)listPage{
    WeakSelf
    self.tableView.loading = YES;
    [[RequestManager sharedInstance]postMessageGroupApplyListWithUserId:[StoreTool getUserID] PageNum:listPage Success:^(id responseData) {
        self.tableView.loading = NO;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if(listPage == 1){
                [strongSelf.newsInfoArr removeAllObjects];
            }
            
            NSDictionary *dataDict = dict[@"data"];
            NSArray *arr = dataDict[@"list"];
            if([arr count] == 0){
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"无更多数据!"];
            }else{
                strongSelf.pageNum++;
                for (NSDictionary *temp in arr) {
                    NewsGroupApplyModel *newsModel = [NewsGroupApplyModel yy_modelWithDictionary:temp];
                    [self.newsInfoArr addObject:newsModel];
                }
            }
            [strongSelf.tableView reloadData];
        } else {
            [self.tableView.mj_footer endRefreshing];
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}
#pragma mark - 同意
-(void)requestGroupApplyAgreeDataWithApplyID:(NSString *)applyId fatherCell:(NewsGroupTableViewCell *)cell{
    [[RequestManager sharedInstance]postMessageGroupApplyAgreeWithUserId:[StoreTool getUserID] ApplyId:applyId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                cell.IsAgreeState = YES;
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }else{
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}
#pragma mark - 删除
-(void)requestGroupApplyDeleteDataWithApplyID:(NSString *)applyId forIndexPath:(NSIndexPath *)indexPath{
    [[RequestManager sharedInstance]postMessageGroupApplyDeleteWithUserId:[StoreTool getUserID] ApplyId:applyId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                // 从数据源中删除
                [self.newsInfoArr removeObjectAtIndex:indexPath.row];
                // 从列表中删除
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }else{
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
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,Height_Statusbar_NavBar , Width_Window, Height_Window-Height_Statusbar_NavBar) style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.backgroundColor = [UIColor customBackgroundColor];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    tableview.showsVerticalScrollIndicator = NO;
    
    adjustsScrollViewInsets_NO(tableview, self);
    tableview.estimatedRowHeight = 0;
    tableview.estimatedSectionHeaderHeight = 0;
    tableview.estimatedSectionFooterHeight = 0;
    
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [tableview.mj_header beginRefreshing];
    
    //空数据方法
    [tableview addNoDataDelegateAndDataSource];
    tableview.emptyDataSetType = EmptyDataSetTypeOrder;
    tableview.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableview QLExtensionLoading:^{
        //进行请求数据
        self.pageNum = 1;
        [self requestGroupApplyListDataWithPage:self.pageNum];
    }];
    
    _tableView = tableview;
}
/** 下拉刷新 */
-(void)loadNewData{
    self.pageNum =1;
    [self requestGroupApplyListDataWithPage:self.pageNum];
}
/** 上啦加载更多 */
-(void)loadMoreData{
    [self requestGroupApplyListDataWithPage:self.pageNum];
}

#pragma mark --tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.newsInfoArr.count == 0);
    
    return self.newsInfoArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor customBackgroundColor];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsGroupCellIden];
    if (!cell) {
        cell = [[NewsGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsGroupCellIden];
    }
    cell.applyCellModel = self.newsInfoArr[indexPath.row];
    cell.btnClick = ^(NewsGroupTableViewCell *cell) {
        [self requestGroupApplyAgreeDataWithApplyID:cell.cellModel.applyId fatherCell:cell];
    };
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsGroupApplyModel *cellModel = self.newsInfoArr[indexPath.row];
    [self requestGroupApplyDeleteDataWithApplyID:cellModel.applyId forIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
