//
//  RecordListViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "RecordListViewController.h"
#import "Configure.h"
//Label字体变色
#import "QLColorLabel.h"
#import "RecordListCell.h"
#import "RecordListModel.h"
//无数据
#import "QLScrollViewExtension.h"


@interface RecordListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) QLColorLabel *numberLabel;
@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) RecordListModel *listModel;

@end

@implementation RecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"推荐记录";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createUI];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
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
        [self requestRecordListDataWithPage:self.page];
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
    [self requestRecordListDataWithPage:self.page];
}

#pragma mark 下拉加载更多数据
- (void)loadNewData{
    self.page = 1;
    [self requestRecordListDataWithPage:self.page];
}

#pragma mark - 请求推荐记录数据
- (void)requestRecordListDataWithPage:(NSInteger)page{
    WeakSelf
    self.tableView.loading = YES;
    if (self.infoArr == nil) {
        self.infoArr = [[NSMutableArray alloc]init];
        self.page = 1;
    }
    [[RequestManager sharedInstance]postRecordListWithUserId:[StoreTool getUserID] page:page Success:^(id responseData) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if(page == 1){
                [strongSelf.infoArr removeAllObjects];
            }
            
            strongSelf.infoDict = TipDic[@"data"];
            //推荐好友数量
//            strongSelf.numberLabel.text = [NSString stringWithFormat:@"已推荐 <%@> 位好友",strongSelf.infoDict[@"total"]];
            
            NSArray *arr = self.infoDict[@"recommendList"];
            if (arr.count == 0) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                strongSelf.page++;
                for (NSDictionary *temp in arr) {
                    strongSelf.listModel = [RecordListModel recordListModelWithDictionary:temp];
                    [strongSelf.infoArr addObject:strongSelf.listModel];
                }
            }
            [strongSelf.tableView reloadData];
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerSecView = [[UIView alloc]init];
    headerSecView.backgroundColor = [UIColor whiteColor];
    
    //邀请好友数量
    QLColorLabel *numberLabel = [[QLColorLabel alloc]initWithFrame:CGRectMake(50, 0, Width_Window-100, 50)];
    numberLabel.backgroundColor = [UIColor customBlueColor];
    numberLabel.textColor = [UIColor whiteColor];
    [numberLabel setAnotherColor: [UIColor customLightYellowColor]];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont systemFontOfSize:16];
    [headerSecView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    //设置指定字体颜色
    NSString *str;
    if (self.infoDict[@"total"] == nil) {
        str = @"0";
    }else{
        str = [NSString stringWithFormat:@"%@",self.infoDict[@"total"]];
    }
    numberLabel.text = [NSString stringWithFormat:@"已推荐 <%@> 位好友",str];
    //设置左下，右下圆角
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:numberLabel.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
    maskLayer.frame = numberLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    numberLabel.layer.mask=maskLayer;
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, numberLabel.bottom+20, Width_Window/3-20, 20)];
    nameLabel.text = @"姓名";
    nameLabel.textColor = [UIColor customTitleColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [headerSecView addSubview:nameLabel];
    
    //手机号
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width_Window/3+10, numberLabel.bottom+20, Width_Window/3-20, 20)];
    phoneLabel.text = @"手机号";
    phoneLabel.textColor = [UIColor customTitleColor];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.font = [UIFont systemFontOfSize:16];
    [headerSecView addSubview:phoneLabel];
    
    //认证状态
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width_Window*2/3+10, numberLabel.bottom+20, Width_Window/3-20, 20)];
    statusLabel.text = @"认证状态";
    statusLabel.textColor = [UIColor customTitleColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = [UIFont systemFontOfSize:16];
    [headerSecView addSubview:statusLabel];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, statusLabel.bottom+20, Width_Window-10, 1)];
    line.backgroundColor = [UIColor customLineColor];
    [headerSecView addSubview:line];
    
    return headerSecView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
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
    RecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[RecordListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    
    [cell setRecoreListLabelValue:self.infoArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = NO;
    return cell;
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
