//
//  MyViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/3/26.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "MyViewController.h"
#import "Configure.h"
/** 导航条渐变 */
#import "WRNavigationBar.h"
/** 个人信息 */
#import "MyInformationView.h"
/** 自定义保单cell */
#import "MyGuaranteeCell.h"
/** 自定义cell */
#import "MyCustomCell.h"
/** 个人信息 */
#import "InformationViewController.h"
/** 交易记录 */
#import "TradeListViewController.h"

/** 我的佣金 */
#import "CommissionViewController.h"


/** 保单列表 */
#import "GuaranteeListViewController.h"
/** 续保提醒 */
#import "RenewContractViewController.h"
/** 我的预约 */
#import "MyAppointmentViewController.h"
/** 我的提问 */
#import "MyAskedViewController.h"
/** 我的话题 */
#import "MyTalkViewController.h"
/** 我参与的 */
#import "MyTakepartViewController.h"
/** 我的收藏 */
#import "MyCollectViewController.h"
/** 设置 */
#import "SettingViewController.h"
/** 我的消息 */
#import "NewsViewController.h"
/** 登录 */
#import "LoginViewController.h"
#import "JumpToLoginVCTool.h"
#import "MyListModel.h"
#import "MainNavigationController.h"
#import "UIBarButtonItem+Badge.h"

#define NAVBAR_COLORCHANGE_POINT 120

/** 重用标识符 */
static NSString *guaranteeCellId = @"guaranteeCellId";
static NSString *customCellId = @"customCellId";

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) MyInformationView *informationView;

@property (nonatomic, strong) NSArray <NSArray *>*titleArr;
@property (nonatomic, strong) MyListModel *myModel;


@end

@implementation MyViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self wr_setNavBarShadowImageHidden:YES];
    
    if ([StoreTool getLoginStates] ) {
        [self requestMyListData];
    }
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    //左侧搜索按钮
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(toSettingItem)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    //右侧信息按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"news_white"];
    //此方法用于使image的颜色与button的tintColor保持一致
    [button setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button addTarget:self action:@selector(toNewsItem) forControlEvents:UIControlEventTouchUpInside];
    //添加角标
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor redColor];
    
    // 设置导航栏背景颜色
    [self wr_setNavBarTitleColor:[UIColor clearColor]];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:0];
    
    self.titleArr = @[@[@{@"title":@"",@"imageName":@""},@{@"title":@"续保提醒",@"imageName":@"renewContract"},@{@"title":@"我的预约",@"imageName":@"appointment"}],
                      @[@{@"title":@"我的提问",@"imageName":@"ask"},@{@"title":@"我的话题",@"imageName":@"talk"},@{@"title":@"我参与的",@"imageName":@"takePart"}],
                      @[@{@"title":@"我的收藏",@"imageName":@"collection"}]];
    
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checklogin:)name:KNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkoutlogin:)name:KNotificationLogOff object:nil];
    // 注册从解锁手势密码页退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutFromHandPsw:) name:KNotificationHandPsw object:nil];
}

#pragma mark - 登录退出接收通知
- (void)checklogin:(NSNotification *)notification{
    //请求数据
    [self requestMyListData];
}

- (void)checkoutlogin:(NSNotification *)notification{
    self.myModel = nil;
    [self.informationView setLabelWithInfoDict:self.myModel];
    self.navigationItem.rightBarButtonItem.badgeValue = @"";
    [self tableViewHeaderViewReload];
    [self.tableView reloadData];
}

//手势密码使用其他账号登录
- (void)logOutFromHandPsw:(NSNotification *)notification{
    self.myModel = nil;
    [self.informationView setLabelWithInfoDict:self.myModel];
    self.navigationItem.rightBarButtonItem.badgeValue = @"";
    [self tableViewHeaderViewReload];
    [self.tableView reloadData];
}

#pragma mark - 释放观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 请求我的列表数据
- (void)requestMyListData{
    WeakSelf
    [[RequestManager sharedInstance]postMyListWithUserId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                NSDictionary *infoDict = TipDic[@"data"];
                //存储认证状态
                [StoreTool storeCheckStatus:infoDict[@"checkStatus"]];
                [StoreTool storePresonCardID:infoDict[@"idNo"]];
                
                strongSelf.myModel = [MyListModel myListModelWithDictionary:infoDict];
                [strongSelf.informationView setLabelWithInfoDict:strongSelf.myModel];
                
                // 设置导航栏右侧未读消息数量
                NSInteger unreadCount = [strongSelf.myModel.messageTotal integerValue];
                if (unreadCount > 9) {
                    strongSelf.navigationItem.rightBarButtonItem.badgeValue = @"9+";
                } else if (unreadCount <= 9 && unreadCount > 0) {
                    strongSelf.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",strongSelf.myModel.messageTotal];
                } else {
                    strongSelf.navigationItem.rightBarButtonItem.badgeValue = @"";
                }
                
                [strongSelf tableViewHeaderViewReload];
                [strongSelf.tableView reloadData];
            }else{
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
            }
        }else{
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
        }
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

//更新tableView的headerView
-(void)tableViewHeaderViewReload{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView layoutIfNeeded];
        [self.tableView setTableHeaderView:self.informationView];
    });
}

#pragma mark - 动态设置导航条颜色
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0){
        CGFloat alpha = offsetY / NAVBAR_COLORCHANGE_POINT;
        [self wr_setNavBarBackgroundAlpha:alpha];
        [self wr_setNavBarTintColor:[[UIColor customNavBarColor] colorWithAlphaComponent:alpha]];
        [self wr_setNavBarTitleColor:[[UIColor customNavBarColor] colorWithAlphaComponent:alpha]];
        if (offsetY >= NAVBAR_COLORCHANGE_POINT) {
            [self wr_setNavBarShadowImageHidden:NO];
        }else{
            [self wr_setNavBarShadowImageHidden:YES];
        }
    }else{
        [self wr_setNavBarBackgroundAlpha:0];
        [self wr_setNavBarTintColor:[UIColor whiteColor]];
        [self wr_setNavBarTitleColor:[UIColor clearColor]];
    }
}

#pragma mark - 设置
- (void)toSettingItem{
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
    
}

#pragma mark - 消息
- (void)toNewsItem{
    NewsViewController *newsVC = [[NewsViewController alloc]init];
    [self.navigationController pushViewController:newsVC animated:YES];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, Height_Window-Height_View_HomeBar-49) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[MyGuaranteeCell class] forCellReuseIdentifier:guaranteeCellId];
    [tableView registerClass:[MyCustomCell class] forCellReuseIdentifier:customCellId];
    //要将此句话写在registerClass下面
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
#pragma mark - 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    
    MyInformationView *informationView = [[MyInformationView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 210+Height_Statusbar_NavBar)];
    [informationView setBtnClickBlock:^(NSString *pid) {
        //根据登录状态进行跳转
        if (![StoreTool getLoginStates]) {
            //跳转到登录页
            LoginViewController *LoginVC = [[LoginViewController alloc]init];
            LoginVC.type = LogInAppearTypePresent;
            MainNavigationController *LoginNav = [[MainNavigationController alloc]initWithRootViewController:LoginVC];
            LoginNav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:LoginNav animated:YES completion:nil];
            
        }else{
            //跳转到个人信息页面
            InformationViewController *informationVC = [[InformationViewController alloc]init];
            [self.navigationController pushViewController:informationVC animated:YES];
        }
    }];
    
    [informationView setCommisionClickBlock:^(NSString *pid) {
        //佣金跳转
//        TradeListViewController *tradeVC = [[TradeListViewController alloc]init];
//        [self.navigationController pushViewController:tradeVC animated:YES];
        //我的佣金
        CommissionViewController *commissionVC = [[CommissionViewController alloc]init];
        [self.navigationController pushViewController:commissionVC animated:YES];
        
    }];
    tableView.tableHeaderView = informationView;
    _informationView = informationView;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 125;
    }else{
        return 50;

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 3;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        MyGuaranteeCell *cell = [tableView dequeueReusableCellWithIdentifier:guaranteeCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCompleteButtonClick:^(NSInteger selectIndex){
            if (![StoreTool getLoginStates]) {
                //未登录时候点击列表计划书直接跳转至登录页面
                [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
            }else{
                GuaranteeListViewController *vc = [GuaranteeListViewController new];
                if (selectIndex == 0) {//待审核
                    vc.selectIndex = 1;
                } else if (selectIndex == 1) {//已承保
                    vc.selectIndex = 2;
                } else if (selectIndex == 2) {//问题件
                    vc.selectIndex = 3;
                }else if (selectIndex == 3){//回执签收
                    vc.selectIndex = 4;
                }else if (selectIndex == 100){//全部
                    vc.selectIndex = 0;
                }
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        return cell;
    } else  {
        MyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:customCellId forIndexPath:indexPath];
        cell.infoDict = self.titleArr[indexPath.section][indexPath.row];
        if (indexPath.section == 0 && indexPath.row == 1) {
            if (![self.myModel.insuranceWarning isEqualToString:@"0"] && self.myModel != nil && [self.myModel.insuranceWarning integerValue] <=9) {
                cell.rightLabel.hidden = NO;
                cell.rightLabel.text = [NSString stringWithFormat:@"%@",self.myModel.insuranceWarning];
                
            }else if ([self.myModel.insuranceWarning integerValue] > 9) {
                cell.rightLabel.hidden = NO;
                cell.rightLabel.text = @"9+";
                
            }else{
                cell.rightLabel.hidden = YES;
            }
        }else {
            cell.rightLabel.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![StoreTool getLoginStates]) {
        //未登录时候点击列表计划书直接跳转至登录页面
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
    }else{
        if (indexPath.section == 0 &&indexPath.row == 1) {
            //续保提醒
            RenewContractViewController *renewVC = [[RenewContractViewController alloc]init];
            [self.navigationController pushViewController:renewVC animated:YES];
            
        }else if (indexPath.section == 0 &&indexPath.row == 2){
            //我的预约
            MyAppointmentViewController *appointVC = [[MyAppointmentViewController alloc]init];
            [self.navigationController pushViewController:appointVC animated:YES];
            
        }else if (indexPath.section == 1 &&indexPath.row == 0){
            //我的提问
            MyAskedViewController *askVC = [[MyAskedViewController alloc]init];
            [self.navigationController pushViewController:askVC animated:YES];
            
        }else if (indexPath.section == 1 &&indexPath.row == 1){
            //我的话题
            MyTalkViewController *talkVC = [[MyTalkViewController alloc]init];
            [self.navigationController pushViewController:talkVC animated:YES];
            
        }else if (indexPath.section == 1 &&indexPath.row == 2){
            //我参与的
            MyTakepartViewController *takepartVC = [[MyTakepartViewController alloc]init];
            [self.navigationController pushViewController:takepartVC animated:YES];
            
        }else if (indexPath.section == 2 &&indexPath.row == 0){
            //我的收藏
            MyCollectViewController *myCollectVC = [[MyCollectViewController alloc]init];
            [self.navigationController pushViewController:myCollectVC animated:YES];
        }
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
