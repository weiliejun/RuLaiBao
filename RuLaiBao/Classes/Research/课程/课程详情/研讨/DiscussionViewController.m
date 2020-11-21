//
//  DiscussionViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "DiscussionViewController.h"
#import "Configure.h"
//无数据
#import "QLScrollViewExtension.h"
#import "XHInputView.h"
#import "RLBListNoDataTipView.h"
/** 自定义字符串 */
#import "TYAttributedLabel.h"

#import "DiscussionHeaderView.h"
#import "DiscussionTableViewCell.h"

/** model */
#import "InfoDataModel.h"
@interface DiscussionViewController ()<UITableViewDelegate,UITableViewDataSource,XHInputViewDelagete,TYAttributedLabelDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, weak) UILabel *headerLabel;
@property (nonatomic, strong) RLBListNoDataTipView *noDataFooterView;

@property (nonatomic, strong) NSMutableArray *headDataArr;

@property (nonatomic, assign) NSInteger listPage;

/** 回复时使用 */
@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *linkId;
@property (nonatomic, copy) NSString *commentName;

@property (nonatomic) BOOL isShowFooterViewWithNoMoreData;

@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, assign) CGFloat bgViewHeight;;

@end

@implementation DiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableViewHeight = self.viewHeight-50-Height_View_HomeBar;
    self.bgViewHeight = 50+Height_View_HomeBar;
    [self createUI];
    [self addInputControl];
    
    self.isShowFooterViewWithNoMoreData = NO;

    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, Width_Window, self.tableViewHeight);
    self.bgView.frame = CGRectMake(0, self.tableView.bottom, Width_Window, self.bgViewHeight);
}
#pragma mark - 接入热点
- (void)adjustStatusBar{
    CGFloat height = Height_View_SafeArea -44 - Width_Window * 9/16 - 51-50;
    CGRect frame = self.tableView.frame;
    frame.size.height = height;
    self.tableView.frame = frame;
    self.bgView.frame = CGRectMake(0, self.tableView.bottom, Width_Window, 50+Height_View_HomeBar);
}

#pragma mark - 请求数据
-(void)requestCourseDetailCourseComment:(NSInteger)page{
    WeakSelf
    [[RequestManager sharedInstance]postCourseDetailCommenWithPage:page CourseId:self.courseDetailId UserId:[StoreTool getUserID] Success:^(id responseData) {
        [self.tableView.mj_header endRefreshing];
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            strongSelf.headerLabel.text = [NSString stringWithFormat:@"  总共 %@ 条研讨",TipDic[@"total"]];
            if (page == 1) {
                [strongSelf.headDataArr removeAllObjects];
            }
            if ([TipDic[@"list"] count] == 0) {
                strongSelf.isShowFooterViewWithNoMoreData = YES;
            }else{
                strongSelf.listPage ++;
                strongSelf.isShowFooterViewWithNoMoreData = NO;
                for (NSDictionary *dict1 in TipDic[@"list"]) {
                    InfoDataModel *infoModel = [[InfoDataModel alloc]initWithDic:dict1 SpeechmanId:strongSelf.speechmanId];
                    [strongSelf.headDataArr addObject:infoModel];
                }
            }
            [strongSelf.tableView reloadData];
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 回复 & 发表post
-(void)postAddComment:(NSString *)commentStr commentId:(NSString *)commentId toUserId:(NSString *)toUserId linkId:(NSString *)linkId{
    WeakSelf
    [[RequestManager sharedInstance]postCourseDetailCommenAddWithCourseId:self.courseDetailId CommentId:commentId LinkId:linkId CommentContent:commentStr UserId:[StoreTool getUserID] ToUserId:toUserId Success:^(id responseData) {
        
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [QLMBProgressHUD showPromptViewInView:strongSelf.view WithTitle:TipDic[@"message"]];
                strongSelf.listPage = 1;
                [strongSelf requestCourseDetailCourseComment:self.listPage];
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
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, self.viewHeight-50-Height_View_HomeBar) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    adjustsScrollViewInsets_NO(tableView, self);
    [tableView registerClass:NSClassFromString(@"DiscussionHeaderView") forHeaderFooterViewReuseIdentifier:@"discussionHeaderView"];
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 44)];
    headerLabel.backgroundColor = [UIColor customBackgroundColor];
    headerLabel.textColor = [UIColor customTitleColor];
    headerLabel.font = [UIFont systemFontOfSize:16.0];
    headerLabel.text = @"  总共 0 条研讨";
    tableView.tableHeaderView = headerLabel;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(collectBottomloadMoreData)];
    
    // 添加无数据提示视图
    CGFloat imageWH = 100;
    CGFloat imageX =(Width_Window - imageWH) / 2;
    CGFloat imageY =  30;
    CGFloat titleY = 30 + imageWH ;
    RLBListNoDataTipView *noDataFooterView = [[RLBListNoDataTipView alloc]
                                              initWithFrame:CGRectMake(0, 0, Width_Window, 200)
                                              backgroundColor:[UIColor clearColor]
                                              imageFrame:CGRectMake(imageX, imageY, imageWH, imageWH)
                                              imageName:@"NoData"
                                              titleFrame:CGRectMake(10, titleY,Width_Window - 20, 30)
                                              tipText:@"暂无研讨"];
    tableView.tableFooterView = noDataFooterView;
    _noDataFooterView = noDataFooterView;
    
    _tableView = tableView;
    _headerLabel = headerLabel;
}
#pragma mark - 下拉刷新
-(void)loadNewData{
    self.listPage = 1;
    [self requestCourseDetailCourseComment:self.listPage];
}
-(void)collectBottomloadMoreData{
    [self requestCourseDetailCourseComment:self.listPage];
}
-(void)reloadTableFooterViewData:(UIView *)footerView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView layoutIfNeeded];
        [self.tableView setTableFooterView:footerView];
    });
}

#pragma mark - 底部输入框
-(void)addInputControl{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.bottom, Width_Window, 50+Height_View_HomeBar)];
    bgView.backgroundColor = [UIColor customBackgroundColor];
    [self.view addSubview:bgView];
    
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(8, 5, bgView.width-96, 40)];
    control.backgroundColor = [UIColor clearColor];
    [control addTarget:self action:@selector(showTextField:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:control];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, control.width, control.height)];
    textLabel.backgroundColor = [UIColor whiteColor];
    textLabel.text = @" 我也来说几句...(最多500字)";
    textLabel.textColor = [UIColor customDetailColor];
    [control addSubview:textLabel];
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(control.right, control.top, 80, 40)];
    [sendBtn setTitle:@"发表" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.backgroundColor = [UIColor customDeepYellowColor];
    [bgView addSubview:sendBtn];
    
    _bgView = bgView;
}

#pragma mark - 弹出输入框
-(void)showTextField:(UIControl *)sender{
    if (![StoreTool getLoginStates]) {
        //未登录时候点击列表计划书直接跳转至登录页面
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
        return;
    }
    if (![StoreTool getCheckStatusForSuccess]) {
        //未认证先认证
        [JumpToSellCertifyVCTool jumpToSellCertifyVCWithFatherViewController:self];
        return;
    }
    /*!
     1.底部发表按钮
     2.点击head回复按钮 nil
     */
    NSString *inputPlaceholder = @"";
    if (sender != nil) {
        self.toUserId = @"";
        self.commentId = @"";
        self.linkId = @"";
        inputPlaceholder = @"我也来说几句...(最多500字)";
    }else{
        inputPlaceholder = [NSString stringWithFormat:@"回复 %@：",self.commentName];
    }
    [XHInputView showWithStyle:InputViewStyleDefault configurationBlock:^(XHInputView *inputView) {
        /** 请在此block中设置inputView属性 */
        /** 代理 */
        inputView.delegate = self;
        /** 占位符文字 */
        inputView.placeholder = inputPlaceholder;
        /** 设置最大输入字数 */
        inputView.maxCount = 500;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        /** 更多属性设置,详见XHInputView.h文件 */
    } sendBlock:^BOOL(NSString *text) {
        if(text.length){
            NSLog(@"输入的信息为:%@",text);
            [self postAddComment:text commentId:self.commentId toUserId:self.toUserId linkId:self.linkId];
            return YES;//return YES,收起键盘
        }else{
            NSLog(@"显示提示框-请输入要评论的的内容");
            [QLMBProgressHUD showPromptViewInView:nil WithTitle:@"内容不得为空~"];
            return NO;//return NO,不收键盘
        }
    }];
}
//判断footer是否隐藏，判断footer停止刷新时显示"加载更多"还是"全部数据已加载完成"
-(void)checkFooterStatus {
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.headDataArr.count == 0);
    self.tableView.tableFooterView.hidden = (self.headDataArr.count != 0);
    if (self.headDataArr.count == 0) {
        [self reloadTableFooterViewData:self.noDataFooterView];
    }else{
        [self reloadTableFooterViewData:nil];
    }
    
    //用户滑到最下边就会自动启用footer刷新,现在数据回来了要footer停止刷新
    if (self.isShowFooterViewWithNoMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}
#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [self checkFooterStatus];
    return self.headDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    InfoDataModel *infoModel = self.headDataArr[section];
    return infoModel.textContainers.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    InfoDataModel *eachModel = self.headDataArr[section];
    return eachModel.headerHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DiscussionHeaderView *headerView = (DiscussionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"discussionHeaderView"];
    
    InfoDataModel *eachModel = self.headDataArr[section];
    headerView.model = eachModel;
    
    //回复
    [headerView setReplyBtnClickBlock:^(DiscussionHeaderView *headView) {
        //弹出视图
        self.toUserId = [NSString stringWithFormat:@"%@",eachModel.commentId];
        self.commentId = [NSString stringWithFormat:@"%@",eachModel.cid];
        self.linkId = [NSString stringWithFormat:@"%@",eachModel.cid];
        self.commentName = [NSString stringWithFormat:@"%@",eachModel.commentName];
        [self showTextField:nil];
    }];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 6, Width_Window-20, 1)];
    lineView.backgroundColor = [UIColor customLineColor];
    [view addSubview:lineView];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    InfoDataModel *eachModel = self.headDataArr[indexPath.section];
    TYTextContainer *textContaner = eachModel.textContainers[indexPath.row];
    return textContaner.textHeight+16;// after createTextContainer, have value
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    DiscussionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[DiscussionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    // Configure the cell...
    cell.label.delegate = self;
    InfoDataModel *eachModel = self.headDataArr[indexPath.section];
    cell.container = eachModel.textContainers[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
/*
#pragma mark - TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point{
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        id linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isKindOfClass:[NSString class]]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:linkStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}
*/
#pragma mark - 懒加载
-(NSMutableArray *)headDataArr{
    if (_headDataArr==nil) {
        _headDataArr = [NSMutableArray array];
    }
    return _headDataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

