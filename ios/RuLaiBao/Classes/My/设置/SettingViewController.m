//
//  SettingViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "SettingViewController.h"
#import "Configure.h"
/** 修改登录密码 */
#import "ModifyPwdViewController.h"
/** 推荐App给好友 */
#import "RecommendViewController.h"
/** 联系客服 */
#import "CustomerServiceViewController.h"
/** 平台公告 */
#import "NoticeViewController.h"
/** WKWebView*/
#import "QLWKWebViewController.h"
/** 手势密码 */
#import "LockViewController.h"


/** 手势密码开启条件判定 */
typedef NS_ENUM(NSInteger, LockType) {
    LockTypeOpen  = 1000,
    LockTypeClose ,
    LockTypeChange
};

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *footerView;

/** 未登录状态数组 */
@property (nonatomic, strong) NSArray *unloginArr;
/** 登录未打开Switch状态数组 */
@property (nonatomic, strong) NSArray *closeInfoArr;
/** 登录打开Switch状态数组 */
@property (nonatomic, strong) NSArray *openInfoArr;

/** 数组 */
@property (nonatomic, strong) NSArray *infoArr;

/** Switch */
@property (nonatomic, strong) UISwitch *switchOK;

@end

@implementation SettingViewController
/** 设置默认数据--返回刷新 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(![StoreTool getLoginStates]){
        self.infoArr = self.unloginArr;
        
    }else{
        if ([StoreTool getHandpwd].length == 0) {
             self.infoArr = self.closeInfoArr;
            
        }else{
            self.infoArr = self.openInfoArr;
            
        }
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createUI];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar-Height_View_HomeBar-49) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Window-Height_View_HomeBar-44, Width_Window, Height_View_HomeBar+44)];
    footerView.backgroundColor = [UIColor customLightYellowColor];
    [self.view addSubview:footerView];
    self.footerView = footerView;
    footerView.hidden = ![StoreTool getLoginStates];
    
    UIButton *logOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 44)];
    [logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logOutBtn.layer.cornerRadius = 6;
    logOutBtn.layer.masksToBounds = YES;
    [logOutBtn addTarget:self action:@selector(logOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logOutBtn];
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    
    self.unloginArr = @[@"联系客服",@"平台公告",@"服务协议",@"隐私政策",@"关于如来保"];
    self.closeInfoArr = @[@[@"手势密码",@"修改登录密码"],@[@"推荐App给好友",@"联系客服",@"平台公告",@"服务协议",@"隐私政策",@"关于如来保"]];
    self.openInfoArr =@[@[@"手势密码",@"修改手势密码",@"修改登录密码"],@[@"推荐App给好友",@"联系客服",@"平台公告",@"服务协议",@"隐私政策",@"关于如来保"]];
}

#pragma mark - 退出登录
- (void)logOutBtnClick{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确定退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *cancelction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //请求退出登录接口，清除数据
        [[RequestManager sharedInstance]postLogoffWithUserId:[StoreTool getUserID] Success:^(id responseData) {
            NSDictionary *Tipdic = responseData;
            NSLog(@"%@",Tipdic);
            
            // 清空用户数据信息
            [StoreTool storeLoginStates:NO];
            [StoreTool storeUserID:@""];
            [StoreTool storePhone:@""];
            [StoreTool storeRealname:@""];
            [StoreTool storeCheckStatus:@""];
            [StoreTool storeHandpwd:@""];
            
            self.infoArr = self.unloginArr;
            self.footerView.hidden = ![StoreTool getLoginStates];
            [self.tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationLogOff object:nil];
            
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:Tipdic[@"msg"]];
            //返回我的
            [self.navigationController popViewControllerAnimated:YES];
            
        } Error:^(NSError *error) {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }];
        
    }];
    [cancelction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    [alertVC addAction:cancelction];
    [alertVC addAction:cancelction1];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - TableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor customBackgroundColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.infoArr.count == 2) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([StoreTool getLoginStates]) {
        return [self.infoArr[section] count];
    }else{
        return self.infoArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    if ([StoreTool getLoginStates]) {
        //登录
        cell.textLabel.text = self.infoArr[indexPath.section][indexPath.row];
        if(indexPath.section == 0 && indexPath.row == 0){
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [self.switchOK removeFromSuperview];
            self.switchOK =nil;
            
            self.switchOK = [[UISwitch alloc]initWithFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width-60, 4, 50, 36)];
            [self.switchOK addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventValueChanged];
            if ([StoreTool getHandpwd].length ==0) {
                self.switchOK.on = NO;
            }else{
                self.switchOK.on = YES;
            }
            
            [cell addSubview:self.switchOK];
        }else if(indexPath.section == 1 && indexPath.row == 5){
            //显示版本号
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",currentVersion];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.detailTextLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        //未登录
        if (indexPath.row == 4) {
            //显示版本号
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",currentVersion];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.detailTextLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = self.infoArr[indexPath.row];
        [self.switchOK removeFromSuperview];
    }
    
    cell.textLabel.textColor = [UIColor customTitleColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 手势密码按钮开关
- (void)pressSwitch:(UISwitch *)OpenSwitch{
    if (OpenSwitch.on) {
        //关闭状态下，点击是去打开
        [self createAlertVCStr:LockTypeOpen];
    }else{
        //打开状态下，点击是去关闭
        [self createAlertVCStr:LockTypeClose];
    }
}

//手势密码
-(void)createAlertVCStr:(LockType)lockType{
    //直接跳转
    LockViewController *lockVC = [[LockViewController alloc]init];
    if (lockType == LockTypeClose) {
        //关闭手势密码
        lockVC.lockModel = LockModelClose;
        lockVC.titleStr = @"绘制手势密码";
    }else if(lockType == LockTypeOpen){
        //开启手势密码
        lockVC.lockModel = LockModelOpen;
        lockVC.titleStr = @"设置手势密码";
    }else if (lockType == LockTypeChange){
        lockVC.lockModel = LockModelChange;
        lockVC.titleStr = @"修改手势密码";
    }
    [self.navigationController pushViewController:lockVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([StoreTool getLoginStates]) {
        //登录
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:{
                    //手势密码
                    
                }
                    break;
                case 1:{
                    if([StoreTool getHandpwd].length == 0){
                        //修改登录密码
                        ModifyPwdViewController *ModifyPwdVC = [[ModifyPwdViewController alloc]init];
                        [self.navigationController pushViewController:ModifyPwdVC animated:YES];
                    }else{
                        //修改手势密码
                        [self createAlertVCStr:LockTypeChange];
                    }
                }
                    break;
                case 2:{
                    //修改登录密码
                    ModifyPwdViewController *ModifyPwdVC = [[ModifyPwdViewController alloc]init];
                    [self.navigationController pushViewController:ModifyPwdVC animated:YES];
                    
                }
                    break;
                default:
                    break;
            }
            
        }else if (indexPath.section == 1){
            switch (indexPath.row) {
                case 0:{
                    //推荐App给好友
                    RecommendViewController *recommendVC = [[RecommendViewController alloc]init];
                    [self.navigationController pushViewController:recommendVC animated:YES];
                }
                    break;
                case 1:{
                    //联系客服
                    CustomerServiceViewController *serviceVC = [[CustomerServiceViewController alloc]init];
                    [self.navigationController pushViewController:serviceVC animated:YES];
                }
                    break;
                case 2:{
                    //平台公告
                    NoticeViewController *noticeVC = [[NoticeViewController alloc]init];
                    [self.navigationController pushViewController:noticeVC animated:YES];
                }
                    break;
                case 3:{
                    //服务协议
                    QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
                    webVC.titleStr = @"服务协议";
                    webVC.urlStr = [NSString stringWithFormat:@"%@://%@/app/service/agreement", webHttp, RequestHeader];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                    break;
                case 4:{
                    //隐私政策
                    QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
                    webVC.titleStr = @"隐私政策";
                    webVC.urlStr = [NSString stringWithFormat:@"%@://%@/app/service/privacyPolicyStatement", webHttp, RequestHeader];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                    break;
                case 5:{
                    //关于如来保
                    QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
                    webVC.titleStr = @"关于如来保";
                    webVC.urlStr = [NSString stringWithFormat:@"%@://%@/app/about/us", webHttp, RequestHeader];
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
    }else{
        //未登录
        switch (indexPath.row) {
            case 0:{
                //联系客服
                CustomerServiceViewController *serviceVC = [[CustomerServiceViewController alloc]init];
                [self.navigationController pushViewController:serviceVC animated:YES];
            }
                break;
            case 1:{
                //平台公告
                NoticeViewController *noticeVC = [[NoticeViewController alloc]init];
                [self.navigationController pushViewController:noticeVC animated:YES];
            }
                break;
            case 2:{
                //服务协议
                QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
                webVC.titleStr = @"服务协议";
                webVC.urlStr = [NSString stringWithFormat:@"%@://%@/app/service/agreement", webHttp, RequestHeader];;
                [self.navigationController pushViewController:webVC animated:YES];
            }
                
                break;
            case 3:{
                //隐私政策
                QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
                webVC.titleStr = @"隐私政策";
                webVC.urlStr = [NSString stringWithFormat:@"%@://%@/app/service/privacyPolicyStatement", webHttp, RequestHeader];
                [self.navigationController pushViewController:webVC animated:YES];
            }
                break;
            case 4:{
                //关于如来保
                QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
                webVC.titleStr = @"关于如来保";
                webVC.urlStr = [NSString stringWithFormat:@"%@://%@/app/about/us", webHttp, RequestHeader];
                [self.navigationController pushViewController:webVC animated:YES];
            }
                break;
                
            default:
                break;
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
