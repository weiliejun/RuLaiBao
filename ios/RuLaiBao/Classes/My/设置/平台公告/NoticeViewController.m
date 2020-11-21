//
//  NoticeViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "NoticeViewController.h"
#import "Configure.h"
#import "NoticeCell.h"
#import "NoticeModel.h"
//WKWebView
#import "QLWKWebViewController.h"
//无数据
#import "QLScrollViewExtension.h"


static NSString *identifer = @"identifer";

@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NoticeModel *model;

@end

@implementation NoticeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"平台公告";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createUI];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [tableView.mj_header beginRefreshing];
    [self.view addSubview:tableView];
    
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        self.page = 1;
        [self requestNoticeDataWithPage:self.page];
    }];
    self.tableView = tableView;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 10)];
    headerView.backgroundColor = [UIColor customBackgroundColor];
    tableView.tableHeaderView = headerView;
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
}

#pragma mark 上拉刷新
- (void)loadMoreData{
    [self requestNoticeDataWithPage:self.page];
}

#pragma mark 下拉加载更多数据
- (void)loadNewData{
    self.page = 1;
    [self requestNoticeDataWithPage:self.page];
}

#pragma mark - 请求公告列表数据
- (void)requestNoticeDataWithPage:(NSInteger)page{
    WeakSelf
    self.tableView.loading = YES;
    if (self.infoArr == nil) {
        self.infoArr = [[NSMutableArray alloc]init];
        self.page = 1;
    }
    [[RequestManager sharedInstance]postNoticeWithPage:page userId:[StoreTool getUserID] Success:^(id responseData) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                if(page == 1){
                    [strongSelf.infoArr removeAllObjects];
                }
                
                NSArray *arr = TipDic[@"data"][@"list"];
                if (arr.count == 0) {
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                } else {
                    strongSelf.page++;
                    for (NSDictionary *temp in arr) {
                        strongSelf.model = [NoticeModel noticeListModelWithDictionary:temp];
                        [strongSelf.infoArr addObject:strongSelf.model];
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

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.infoArr.count == 0);
    return self.infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[NoticeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }

    [cell setNoticeModelWithDictionary:self.infoArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoticeModel *model = self.infoArr[indexPath.row];
    QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
    webVC.titleStr = @"公告详情";
    webVC.urlStr = [NSString stringWithFormat:@"%@://%@/bulletin/detail?id=%@&userId=%@", webHttp, RequestHeader, model.Id, [StoreTool getUserID]];
    [self.navigationController pushViewController:webVC animated:YES];
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
