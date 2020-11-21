//
//  NewsTypeViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "NewsTypeViewController.h"
#import "Configure.h"
//无数据
#import "QLScrollViewExtension.h"

/** 佣金cell */
#import "NewsCommissionTableViewCell.h"
/** 保单cell */
#import "NewsPolicyTableViewCell.h"
#import "NewsOtherTableViewCell.h"

#import "NewsTypeModel.h"

/** 交易明细 */
#import "TradeDetailViewController.h"
/** 保单详情 */
#import "GuaranteeDetailViewController.h"

static NSString *const NewsCommissionCellIden = @"newsCommissionCell";
static NSString *const NewsPolicyCellIden = @"newsPolicyCell";
static NSString *const NewsOtherCellIden = @"newsOtherCell";

@interface NewsTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *newsInfoArr;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, copy) NSString *busiType;

/** 显示footerview */
@property (nonatomic) BOOL isShowFooterViewWithNoMoreData;

@end

@implementation NewsTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleStr;
    
    self.pageNum = 1;
    self.newsInfoArr = [NSMutableArray arrayWithCapacity:20];
    self.isShowFooterViewWithNoMoreData = NO;
    
    [self createUI];
    if(self.newsType == NewsTypeCommission){
        self.busiType = @"commission";
    }else if(self.newsType == NewsTypePolicy){
        self.busiType = @"insurance";
    }else{
        self.busiType = @"otherMessage";
    }
}
#pragma mark - 请求数据
-(void)requestMessageDataWithPage:(NSInteger)listPage BusiType:(NSString *)busiType{
    WeakSelf
    self.tableView.loading = YES;
//    18042709525931594357
    [[RequestManager sharedInstance]postMessagebusiTypeListWithUserId:[StoreTool getUserID] busiType:busiType PageNum:listPage Success:^(id responseData) {
        self.tableView.loading = NO;
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if(listPage == 1){
                [strongSelf.newsInfoArr removeAllObjects];
            }
            
            NSDictionary *dataDict = dict[@"data"];
            NSArray *arr = dataDict[@"list"];
            if([arr count] == 0){
                self.isShowFooterViewWithNoMoreData = YES;
//                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"无更多数据!"];
            }else{
                strongSelf.pageNum++;
                self.isShowFooterViewWithNoMoreData = NO;
                for (NSDictionary *temp in arr) {
                    NewsTypeModel *newsModel = [NewsTypeModel yy_modelWithDictionary:temp];
                    [self.newsInfoArr addObject:newsModel];
                }
            }
            [strongSelf.tableView reloadData];
        } else {
            [self.tableView.mj_footer endRefreshing];
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
        [self.tableView.mj_header endRefreshing];
    } Error:^(NSError *error) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - UI
-(void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    adjustsScrollViewInsets_NO(tableView, self);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [tableView.mj_header beginRefreshing];
    
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        self.pageNum = 1;
        [self requestMessageDataWithPage:self.pageNum BusiType:self.busiType];
    }];
    _tableView = tableView;
}

/** 下拉刷新 */
-(void)loadNewData{
    self.pageNum = 1;
    [self requestMessageDataWithPage:self.pageNum BusiType:self.busiType];
}
/** 上啦加载更多 */
-(void)loadMoreData{
    [self requestMessageDataWithPage:self.pageNum BusiType:self.busiType];
}

//判断footer是否隐藏，判断footer停止刷新时显示"加载更多"还是"全部数据已加载完成"
-(void)checkFooterStatus {
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.newsInfoArr.count == 0);
    
    //用户滑到最下边就会自动启用footer刷新,现在数据回来了要footer停止刷新
    if (self.isShowFooterViewWithNoMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark --tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self checkFooterStatus];
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
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.newsType == NewsTypeCommission) {
        NewsCommissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCommissionCellIden];
        if (!cell) {
            cell = [[NewsCommissionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCommissionCellIden];
        }
        cell.newsCellModel = self.newsInfoArr[indexPath.row];
        return cell;
    }else if(self.newsType == NewsTypePolicy){
        NewsPolicyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsPolicyCellIden];
        if (!cell) {
            cell = [[NewsPolicyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsPolicyCellIden];
        }
        cell.newsCellModel = self.newsInfoArr[indexPath.row];
        return cell;
    }else{
        NewsOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsOtherCellIden];
        if (!cell) {
            cell = [[NewsOtherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsOtherCellIden];
        }
        cell.newsCellModel = self.newsInfoArr[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.newsType == NewsTypeCommission) {
        TradeDetailViewController *vc= [[TradeDetailViewController alloc]init];
        NewsTypeModel *model = self.newsInfoArr[indexPath.row];
        vc.Id = model.busiPriv;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(self.newsType == NewsTypePolicy){
        GuaranteeDetailViewController *vc= [[GuaranteeDetailViewController alloc]init];
        NewsTypeModel *model = self.newsInfoArr[indexPath.row];
        vc.orderId = model.busiPriv;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //其他消息
        
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
