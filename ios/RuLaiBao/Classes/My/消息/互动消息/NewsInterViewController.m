//
//  NewsInterViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/20.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "NewsInterViewController.h"
#import "Configure.h"
//无数据
#import "QLScrollViewExtension.h"

#import "NewsInterTableViewCell.h"
#import "NewsInterModel.h"

//课程详情
#import "CourseDetailViewController.h"
//问题详情
#import "QADetailViewController.h"
//回答详情
#import "AnswerDetailViewController.h"
//话题详情
#import "GroupTopicViewController.h"

static NSString *const NewsInterCellIden = @"newsInterCell";

@interface NewsInterViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 主view */
@property (nonatomic, weak) UITableView *tableView;
/** 主默认数组(左边title) */
@property (nonatomic, strong) NSMutableArray *newsInfoArr;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation NewsInterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"互动消息";
    [self createUI];
    
    self.pageNum = 1;
    self.newsInfoArr = [NSMutableArray arrayWithCapacity:20];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataAgain)name:KNotificationDataRemoved object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationDataRemoved object:nil];
}
#pragma mark - 从回答详情返回请求
-(void)getDataAgain{
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 请求数据
-(void)requestMessageUserInteractListDataWithPage:(NSInteger)listPage{
    WeakSelf
    self.tableView.loading = YES;
    [[RequestManager sharedInstance]postMessageUserInteractListWithUserId:[StoreTool getUserID] PageNum:listPage Success:^(id responseData) {
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
                    NewsInterModel *newsModel = [NewsInterModel yy_modelWithDictionary:temp];
                    [self.newsInfoArr addObject:newsModel];
                }
            }
            [strongSelf.tableView reloadData];
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - UI
-(void)createUI{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,Height_Statusbar_NavBar , Width_Window, Height_Window-Height_Statusbar_NavBar) style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.backgroundColor = [UIColor customBackgroundColor];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    tableview.showsVerticalScrollIndicator = NO;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    adjustsScrollViewInsets_NO(tableview, self);
    tableview.estimatedRowHeight = 100;
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
        [self requestMessageUserInteractListDataWithPage:self.pageNum];
    }];
    
    _tableView = tableview;
}
/** 下拉刷新 */
-(void)loadNewData{
    self.pageNum =1;
    [self requestMessageUserInteractListDataWithPage:self.pageNum];
}
/** 上啦加载更多 */
-(void)loadMoreData{
    [self requestMessageUserInteractListDataWithPage:self.pageNum];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsInterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsInterCellIden];
    if (!cell) {
        cell = [[NewsInterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsInterCellIden];
    }
    cell.cellInfoModel = self.newsInfoArr[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsInterModel *model = self.newsInfoArr[indexPath.row];
    if ([model.messageType isEqualToString:@"question"]) {
        //跳转到提问详情
        QADetailViewController *qaDetailVC = [[QADetailViewController alloc]init];
        qaDetailVC.questionId = model.param1;
        [self.navigationController pushViewController:qaDetailVC animated:YES];
    }else if ([model.messageType isEqualToString:@"answer"]) {
        //跳转到回答详情
        AnswerDetailViewController *answerDetailVC = [[AnswerDetailViewController alloc]init];
        answerDetailVC.questionId = model.param1;
        answerDetailVC.answerId = model.param2;
        [self.navigationController pushViewController:answerDetailVC animated:YES];
    }else if ([model.messageType isEqualToString:@"topic"]) {
        //跳转到话题详情
        GroupTopicViewController *groupTopicDetailVC = [[GroupTopicViewController alloc]init];
        groupTopicDetailVC.appTopicId = model.param1;
        [self.navigationController pushViewController:groupTopicDetailVC animated:YES];
    }else if ([model.messageType isEqualToString:@"course"]) {
        //跳转到课程详情
        CourseDetailViewController *courseDetailVC = [[CourseDetailViewController alloc]init];
        courseDetailVC.courseId = model.param1;
        courseDetailVC.speechmakeId = model.param2;
        [self.navigationController pushViewController:courseDetailVC animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
