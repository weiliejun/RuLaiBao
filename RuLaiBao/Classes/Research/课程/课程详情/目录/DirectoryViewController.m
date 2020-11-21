//
//  DirectoryViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "DirectoryViewController.h"
#import "Configure.h"
#import "CourseDetailViewController.h"
//无数据
#import "QLScrollViewExtension.h"
//cell
#import "CourseTableViewCell.h"

/** model */
#import "CourseListModel.h"
#import "CourseDiretoryModel.h"

@interface DirectoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

/** page */
@property (nonatomic, assign) NSInteger listPage;

@property (nonatomic, strong) NSMutableArray *infoDataArr;
@end

@implementation DirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createUI];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, Width_Window, self.viewHeight);
}
#pragma mark - 接入热点
- (void)adjustStatusBar{
    CGFloat height = Height_View_SafeArea -44 - Width_Window * 9/16 - 51;
    CGRect frame = self.tableView.frame;
    frame.size.height = height;
    self.tableView.frame = frame;
}
#pragma mark - 请求数据
-(void)requestCourseDetailCourseOutline:(NSInteger)page{
    WeakSelf
    self.tableView.loading = YES;
    [[RequestManager sharedInstance]postCourseDetailContentWithPage:page SpeechmakeId:self.speechmakeId Success:^(id responseData) {
        self.tableView.loading = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if (page == 1) {
                [strongSelf.infoDataArr removeAllObjects];
            }
            
            NSDictionary *TipDic = dict[@"data"];
            //数据处理
            CourseDiretoryModel *diretoryModel = [CourseDiretoryModel yy_modelWithDictionary:TipDic];
            if (diretoryModel.courseList.count == 0) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.listPage ++;
                [strongSelf.infoDataArr addObjectsFromArray:diretoryModel.courseList];
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
#pragma mark - 请求更多
-(void)collectBottomloadMoreData{
    [self requestCourseDetailCourseOutline:self.listPage];
}
#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, self.viewHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    adjustsScrollViewInsets_NO(tableView, self);
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(collectBottomloadMoreData)];
    tableView.mj_footer = footer;
    // Set title
    [footer setTitle:@"^_^点击查看更多课程" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载，请稍后..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多课程" forState:MJRefreshStateNoMoreData];

    //空数据方法
    //section ①无值-出现；②有值 row无值-不出现  row有值—出现
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/10;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        self.listPage = 1;
        [self requestCourseDetailCourseOutline:self.listPage];
    }];
}
-(void)loadNewData{
    self.listPage = 1;
    [self requestCourseDetailCourseOutline:self.listPage];
}
//判断footer是否隐藏，判断footer停止刷新时显示"加载更多"还是"全部数据已加载完成"
-(void)checkFooterStatus {
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.infoDataArr.count == 0);
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [self checkFooterStatus];
    return self.infoDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor customBackgroundColor];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Width_Window/2+60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[CourseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.cellInfoModel = self.infoDataArr[indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转新页面
    CourseDetailViewController *courseDetailVC = [[CourseDetailViewController alloc]init];
    CourseListModel *infoModel = self.infoDataArr[indexPath.section];
    courseDetailVC.courseId = infoModel.courseId;
    courseDetailVC.speechmakeId = infoModel.speechmakeId;
    [self.navigationController pushViewController:courseDetailVC animated:YES];
}

-(NSMutableArray *)infoDataArr{
    if (_infoDataArr == nil) {
        NSMutableArray *sectionArr = [NSMutableArray arrayWithCapacity:10];
        _infoDataArr = sectionArr;
    }
    return _infoDataArr;
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
