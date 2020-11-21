//
//  MyBankCardViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyBankCardViewController.h"
#import "Configure.h"
#import "MyBankCardCell.h"
/** 新增银行卡 */
#import "AddBankCardViewController.h"

#import "SellCertifyViewController.h"
#import "MyBankCardModel.h"

//无数据
#import "QLScrollViewExtension.h"


@interface MyBankCardViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, strong) MyBankCardModel *bankModel;
@property (nonatomic, assign) NSInteger indexPath;

@end

@implementation MyBankCardViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [self requestMyBankCardData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的银行卡";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createUI];
    
    self.infoArr = [NSMutableArray arrayWithCapacity:20];
}

#pragma mark - 设置界面元素
- (void)createUI {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar-Height_View_HomeBar-44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor customBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    // tableFooterView
    tableView.tableFooterView = [[UIView alloc]init];
    
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/8;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        [self requestMyBankCardData];
        
    }];
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(tableView, self);
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    
    //新增银行卡按钮
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Window-Height_View_HomeBar-44, Width_Window, Height_View_HomeBar+44)];
    footerView.backgroundColor = [UIColor customLightYellowColor];
    [self.view addSubview:footerView];
    
    UIButton *addCardBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 44)];
    addCardBtn.backgroundColor = [UIColor customLightYellowColor];
    [addCardBtn setTitle:@"新增银行卡" forState:UIControlStateNormal];
    [addCardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addCardBtn addTarget:self action:@selector(addBankCard:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addCardBtn];
}

#pragma mark - 请求我的银行卡列表数据
- (void)requestMyBankCardData {
    self.tableView.loading = YES;
    if (self.infoArr == nil) {
        self.infoArr = [[NSMutableArray alloc]init];
    }
    WeakSelf
    [[RequestManager sharedInstance]postMyBankCardWithUserId:[StoreTool getUserID] Success:^(id responseData) {
        StrongSelf
        strongSelf.tableView.loading = NO;
        NSDictionary *TipDic = responseData;
         if ([TipDic[@"code"] isEqualToString:@"0000"]) {
             strongSelf.infoDict = TipDic[@"data"];
             [strongSelf.infoArr removeAllObjects];
             
             NSArray *arr = strongSelf.infoDict[@"userBankCardList"];
             for (NSDictionary *temp in arr) {
                 strongSelf.bankModel = [MyBankCardModel myBankCardModelWithDictionary:temp];
                 [strongSelf.infoArr addObject:strongSelf.bankModel];
             }
             [strongSelf.tableView reloadData];
             
         } else {
             
             [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
         }
        
    } Error:^(NSError *error) {
        StrongSelf
        strongSelf.tableView.loading = NO;
         [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 新增银行卡
- (void)addBankCard:(UIButton *)btn {
    //点击新增银行卡，未销售认证的提示去认证
    if ([StoreTool getCheckStatusForSuccess]) {
        AddBankCardViewController *addVC = [[AddBankCardViewController alloc]init];
        [self.navigationController pushViewController:addVC animated:YES];
        
    } else {
        // 点击新增银行卡，未销售认证的提示去认证：请通过认证后在进行该操作！   取消/去认证
        [JumpToSellCertifyVCTool jumpToSellCertifyVCWithFatherViewController:self];
    
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.infoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"identifer";
    MyBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[MyBankCardCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    
    //删除银行卡
    [cell setDeleteBlock:^{
        [self addUIAlertControllerWithType:@"删除银行卡" messageStr:@"是否确定删除该银行卡？" index:indexPath.section];
        
    }];
    
    //设为工资卡
    [cell setSalaryBlock:^{
        [self addUIAlertControllerWithType:@"设为工资卡" messageStr:@"是否确定设为工资卡?" index:indexPath.section];
        
    }];
    
    [cell setMyBankCardModelWithDictionary:self.infoArr[indexPath.section]];
    
    cell.backgroundColor = [UIColor customBackgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 请求删除、设置工资卡数据
- (void)requestDeleteDataWithDoType:(NSString *)doType bankId:(NSString *)bankId {
    WeakSelf
    [[RequestManager sharedInstance]postDeleteBankCardWithId:bankId userId:[StoreTool getUserID] doType:doType Success:^(id responseData) {
        StrongSelf
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
             if ([TipDic[@"data"][@"flag"] isEqualToString:@"true"]) {
                
                 [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
                 
                 [self requestMyBankCardData];
                 
             }else {
                 [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
             }
        }else {
             [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
        }
        [strongSelf.tableView reloadData];
        
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - UIAlertController提示信息
- (void)addUIAlertControllerWithType:(NSString *)typeStr messageStr:(NSString *)messageStr index:(NSInteger)indexPath {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        //取消
        //tableView取消编辑状态
        [self.tableView setEditing:NO animated:YES];
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //确定
        MyBankCardModel *model = self.infoArr[indexPath];
        self.indexPath = indexPath;
        if ([typeStr isEqualToString:@"删除银行卡"]) {
            //删除银行卡
            [self requestDeleteDataWithDoType:@"delete" bankId:model.bankCardId];
        
        } else {
            //设为工资卡
            [self requestDeleteDataWithDoType:@"setwagecard" bankId:model.bankCardId];
        }
    
        [self.tableView reloadData];
        
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:sureAction];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:messageStr];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attStr.length)];
    [alertC setValue:attStr forKey:@"attributedMessage"];
    [self presentViewController:alertC animated:YES completion:nil];
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
