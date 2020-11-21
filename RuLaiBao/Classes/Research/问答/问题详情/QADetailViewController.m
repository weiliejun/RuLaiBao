//
//  QADetailViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/9.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "QADetailViewController.h"
#import "configure.h"
/** 自定义分享 */
#import "CustomShareUI.h"
//无数据
#import "RLBListNoDataTipView.h"
#import "RLBDetailNoDataTipView.h"

/** 顶部 */
#import "DetailQuestionTopView.h"
/** cell */
#import "DetailQuestionCell.h"
/** 选择项 */
#import "DetailQuestionHeaderView.h"
//排序
#import "FTPopOverMenu.h"
//悬浮view
#import "QLDragFloatView.h"

/** 回答详情 */
#import "AnswerDetailViewController.h"
/** 回答 */
#import "AnswerUserViewController.h"

/** model*/
#import "QAListModel.h"
#import "DetailQuestionModel.h"

/** 选择排序 */
typedef NS_ENUM(NSInteger, BtnType) {
    BtnTypeDefault  = 100010,  //默认
    BtnTypeTime             ,  //最新
};
static NSString *headerViewID = @"detailQuestionHeaderView";
static NSString *footerViewID = @"detailQuestionFooterView";

@interface QADetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,QLTapViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) DetailQuestionTopView *topView;
@property (nonatomic, weak) RLBDetailNoDataTipView *noDetailTipView;
@property (nonatomic, strong) RLBListNoDataTipView *noDataFooterView;

/** 顶部view的数据 */
@property (nonatomic, strong) QAListModel *detailModel;
/** 底部问答列表的数组 */
@property (nonatomic, strong) NSMutableArray *topicDataArr;

@property (nonatomic, copy) NSString *answerNumTotal;
@property (nonatomic, assign) NSInteger topicListPage;

/** 排序 */
@property (nonatomic, assign) BtnType selectBtnType;
@property (nonatomic, copy) NSString *sortType;

@end

@implementation QADetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.topicListPage = 1;
    [self requestGroupDetailTopicListDataWithPage:self.topicListPage sortType:self.sortType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"问题详情";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain  target:self action:@selector(ShareQuestionItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self createUI];
    //悬浮按钮
    [self createFloatView];
    
    self.answerNumTotal = @"0";
    //默认值
    self.selectBtnType = BtnTypeDefault;
    self.sortType = @"default";
    
    
//    if(self.listModel != nil){
//        self.questionId = [NSString stringWithFormat:@"%@",self.listModel.questionId];
//    }
    //请求详情数据
    [self requestGroupDetailData];
    
    //请求页
    [self noDetailTipView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataAgain)name:KNotificationDataRemoved object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationDataRemoved object:nil];
}
#pragma mark - 接入热点
- (void)adjustStatusBar{
    CGFloat height =  Height_View_SafeArea-44;
    CGRect frame = self.tableView.frame;
    frame.size.height = height;
    self.tableView.frame = frame;
}
#pragma mark - 从回答详情返回请求
-(void)getDataAgain{
    [self requestGroupDetailData];
}
#pragma mark - 无数据view

-(RLBDetailNoDataTipView *)noDetailTipView{
    if (_noDetailTipView == nil) {
        RLBDetailNoDataTipView *noDetailTipView = [[RLBDetailNoDataTipView alloc]initWithFrame:self.view.frame imageName:@"NoData" tipText:KDetailPostDataRequestIng];
        noDetailTipView.tipType = NoDataTipTypeRequestLoading;
        noDetailTipView.tapClick = ^(NoDataTipType tipType) {
            if (tipType == NoDataTipTypeNoData) {
                if(self.noDataBlock != nil){
                    self.noDataBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self requestGroupDetailData];
            }
        };
        [self.view addSubview:noDetailTipView];
        [self.view bringSubviewToFront:noDetailTipView];
        _noDetailTipView = noDetailTipView;
    }
    return _noDetailTipView;
}

#pragma mark - share
-(void)ShareQuestionItem{
    //判断questionId是否有值
    if (self.detailModel == nil) {
        return;
    }
    NSString *shareUrl = [NSString stringWithFormat:@"http://%@/appQuestion/share/%@",RequestHeader,self.questionId];
    NSString *shareTitle = [NSString stringWithFormat:@"%@",self.detailModel.title];
    NSString *shareDes = [NSString stringWithFormat:@"%@",self.detailModel.descript];
    [CustomShareUI shareWithUrl:shareUrl Title:shareTitle DesStr:shareDes];
}
#pragma mark - 请求问题详情
-(void)requestGroupDetailData{
    WeakSelf
    [[RequestManager sharedInstance]postQAQuestionDetailWithQuestionId:self.questionId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [strongSelf.noDetailTipView removeFromSuperview];
                
                QAListModel *detailAllModel = [QAListModel yy_modelWithDictionary:TipDic[@"appQuestion"]];
                strongSelf.detailModel = detailAllModel;
                
                [strongSelf reloadTableHeaderViewData:detailAllModel];
            } else {
                if ([TipDic[@"code"] isEqualToString:@"6001"] || [TipDic[@"code"] isEqualToString:@"6002"]) {
                    [strongSelf createAlertVC];
                    
                }else{
                    self.noDetailTipView.tipType = NoDataTipTypeRequestError;
//                    [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
                }
            }
        } else {
            self.noDetailTipView.tipType = NoDataTipTypeRequestError;
        }
    } Error:^(NSError *error) {
        self.noDetailTipView.tipType = NoDataTipTypeRequestError;
    }];
}

#pragma mark - 数据删除回调
-(void)createAlertVC{
    [self reloadTableHeaderViewData: nil];
    self.navigationItem.rightBarButtonItem = nil;
    self.noDetailTipView.tipType = NoDataTipTypeNoData;
    
    [self.noDetailTipView changeTipLabel:KQuestionDetailDataRemoved];
}

#pragma mark -- 请求话题列表
-(void)requestGroupDetailTopicListDataWithPage:(NSInteger)listPage sortType:(NSString *)sortType{
    WeakSelf
    [[RequestManager sharedInstance]postQAQuestionDetailQuestionListWithUserID:[StoreTool getUserID] QuestionId:self.questionId ListPage:listPage SortType:sortType Success:^(id responseData) {
        NSDictionary *dict = responseData;
        [self.tableView.mj_footer endRefreshing];
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                if(strongSelf.topicListPage == 1){
                    [strongSelf.topicDataArr removeAllObjects];
                }
                self.answerNumTotal = [NSString stringWithFormat:@"%@",TipDic[@"total"]];
                
                NSArray *arr = TipDic[@"list"];
                if([arr count] == 0){
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    strongSelf.topicListPage ++;
                    
                    for (NSDictionary *temp in arr) {
                        DetailQuestionModel *hotlistModel = [DetailQuestionModel yy_modelWithDictionary:temp];
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
-(void)requestQAQuestionDetailLikeData:(NSString *)questionId fatherCell:(DetailQuestionCell *)cell{
    if (![StoreTool getLoginStates]) {
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
        return;
    }
    if (![StoreTool getCheckStatusForSuccess]) {
        //未认证先认证
        [JumpToSellCertifyVCTool jumpToSellCertifyVCWithFatherViewController:self];
        return;
    }
    [[RequestManager sharedInstance]postQAQuestionDetailLikeWithUserID:[StoreTool getUserID] AnswerId:questionId Success:^(id responseData) {
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
#pragma mark - UI
-(void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_View_SafeArea-44) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedRowHeight = 100;
    [tableView registerClass:[DetailQuestionHeaderView class] forHeaderFooterViewReuseIdentifier:headerViewID];
    [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:footerViewID];
    
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
                                              tipText:@"暂无回答"];
    tableView.tableFooterView = noDataFooterView;
    _noDataFooterView = noDataFooterView;
    
    DetailQuestionTopView *topView = [[DetailQuestionTopView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 0)];
    tableView.tableHeaderView = topView;
    _topView = topView;
    /** 进行tableHeaderView 的自适应高度变换 */
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.equalTo(tableView);
    }];
    //刷新TableHeaderView
    [self reloadTableHeaderViewData: nil];
}
-(void)reloadTableHeaderViewData:(QAListModel *)model{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topView.questionModel = model;
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
    [self requestGroupDetailTopicListDataWithPage:self.topicListPage sortType:self.sortType];
}

#pragma mark - 悬浮按钮
-(void)createFloatView{
    QLDragFloatView *floatView = [[QLDragFloatView alloc]initWithFrame:CGRectMake(Width_Window-70, Height_Window-Height_View_HomeBar-160, 60, 60)];
    floatView.delegate = self;
    floatView.contentInset = UIEdgeInsetsMake(Height_Statusbar_NavBar, 10, Height_View_HomeBar+10, 10);
    [self.view addSubview:floatView];
}
//回答问题
-(void)tapViewFloatingBall{
    if (![StoreTool getLoginStates]) {
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
        return;
    }
    if (![StoreTool getCheckStatusForSuccess]) {
        //未认证先认证
        [JumpToSellCertifyVCTool jumpToSellCertifyVCWithFatherViewController:self];
        return;
    }
    if (self.detailModel == nil) {
        return;
    }
    AnswerUserViewController *answerUserVC = [[AnswerUserViewController alloc]init];
    answerUserVC.detailModel = self.detailModel;
    [self.navigationController pushViewController:answerUserVC animated:YES];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DetailQuestionHeaderView *headerView = (DetailQuestionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewID];
    headerView.commentCount = self.answerNumTotal;
    [headerView setSortBtnClickBlock:^(DetailQuestionHeaderView *headView) {
        //排序
        [self handleHeaderBtnClick:headView.sortBtn];
    }];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    DetailQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[DetailQuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.controlClick = ^(QuestionCellControlType index, DetailQuestionCell *detailCell) {
        //点赞
        [self requestQAQuestionDetailLikeData:detailCell.questionModel.answerId fatherCell:detailCell];
    };
    cell.questionModel = self.topicDataArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AnswerDetailViewController *answerVC = [[AnswerDetailViewController alloc]init];
    answerVC.answerDetailModel = self.topicDataArr[indexPath.row];
    answerVC.questionId = self.questionId;
    [self.navigationController pushViewController:answerVC animated:YES];
}

#pragma mark - 排序处理
-(void)handleHeaderBtnClick:(UIView *)sourceView{
    //在无数据时，请设置为不可点击
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuSeparatorMargin = 0;
    configuration.textColor = [UIColor customTitleColor];
    configuration.textFont = [UIFont systemFontOfSize:15];
    configuration.selectedTextColor = [UIColor customDeepYellowColor];
    configuration.selectedCellBackgroundColor = [UIColor clearColor];
    configuration.tintColor = [UIColor whiteColor];
    //为了好看，此color请与遮罩层的颜色保持一致
    configuration.borderColor = [UIColor colorWithWhite:0.5 alpha:0.1f];
    BOOL IsSelect = NO;
    if (self.selectBtnType == BtnTypeDefault) {
        IsSelect = YES;
    }
    FTPopOverMenuModel *model1 = [[FTPopOverMenuModel alloc]initWithTitle:@"默认排序" image:nil selected:IsSelect];
    FTPopOverMenuModel *model2 = [[FTPopOverMenuModel alloc]initWithTitle:@"最新排序" image:nil selected:!IsSelect];
    
    [FTPopOverMenu showForSender:sourceView withMenuArray:@[model1,model2] doneBlock:^(NSInteger selectedIndex) {
        self.selectBtnType = selectedIndex + 100010;
        DetailQuestionHeaderView *view = (DetailQuestionHeaderView *)[self.tableView headerViewForSection:0];
        if (self.selectBtnType == BtnTypeDefault) {
            self.sortType = @"default";
            view.btnTitleStr = @"默认排序";
        }else{
            self.sortType = @"new";
            view.btnTitleStr = @"最新排序";
        }
        self.topicListPage = 1;
        [self requestGroupDetailTopicListDataWithPage:self.topicListPage sortType:self.sortType];
        [self viewAnimation];
    } dismissBlock:^{
        [self viewAnimation];
    }];
}
//取消动画
-(void)viewAnimation{
    DetailQuestionHeaderView *headerView = (DetailQuestionHeaderView *)[self.tableView headerViewForSection:0];
    [UIView animateWithDuration:0.3f animations:^{
        headerView.imageView.transform = CGAffineTransformIdentity;
    } completion:nil];
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
    
}

@end
