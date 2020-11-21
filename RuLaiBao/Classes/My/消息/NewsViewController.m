//
//  NewsViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "NewsViewController.h"
#import "Configure.h"

#import "NewsTableViewCell.h"
/** 佣金 & 保单 的VC */
#import "NewsTypeViewController.h"
/** 圈子 */
#import "NewsGroupViewController.h"
/** 互动消息 */
#import "NewsInterViewController.h"

static NSString *const NewsCellIden = @"newsCell";

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 主view */
@property (nonatomic, weak) UITableView *tableView;
/** 主默认数组(左边title) */
@property (nonatomic, strong) NSArray *newsInfoArr;
/** 主条数数组(右边) */
@property (nonatomic, strong) NSMutableArray *newsNumArr;

@end

@implementation NewsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //请求数据
    [self PostMessageUnreadCountWithUserId:[StoreTool getUserID]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息";
    [self createUI];
    
    self.newsNumArr = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0"]];
    self.newsInfoArr = @[@"佣金消息",@"保单消息",@"互动消息",@"圈子新成员",@"其他消息"];
}

-(void)createUI{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,Height_Statusbar_NavBar , Width_Window, Height_Window-Height_Statusbar_NavBar) style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.backgroundColor = [UIColor customBackgroundColor];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    tableview.showsVerticalScrollIndicator = NO;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    adjustsScrollViewInsets_NO(tableview, self);
    tableview.estimatedRowHeight = 0;
    tableview.estimatedSectionHeaderHeight = 0;
    tableview.estimatedSectionFooterHeight = 0;
    _tableView = tableview;
}

#pragma mark --消息
-(void)PostMessageUnreadCountWithUserId:(NSString *)userId{
    WeakSelf
    [[RequestManager sharedInstance]postMessageUnreadCountWithUserId:userId Success:^(id responseData) {
        StrongSelf
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *TipDic = dict[@"data"];
            NSString *commissionNum, *insuranceNum, *interactiveNum ,*groupNum ,*othermessageNum;
            commissionNum = TipDic[@"commission"];
            insuranceNum = TipDic[@"insurance"];
            interactiveNum = TipDic[@"comment"];
            groupNum = TipDic[@"circle"];
            othermessageNum = TipDic[@"otherMessage"];
            [strongSelf.newsNumArr replaceObjectAtIndex:0 withObject:commissionNum];
            [strongSelf.newsNumArr replaceObjectAtIndex:1 withObject:insuranceNum];
            [strongSelf.newsNumArr replaceObjectAtIndex:2 withObject:interactiveNum];
            [strongSelf.newsNumArr replaceObjectAtIndex:3 withObject:groupNum];
            [strongSelf.newsNumArr replaceObjectAtIndex:4 withObject:othermessageNum];
            [strongSelf.tableView reloadData];
        }else{
             [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
         [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark --tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCellIden];
    if (!cell) {
        cell = [[NewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellIden];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setNewsCellInfo:self.newsInfoArr[indexPath.row]];
    [cell setNewsInfoNum:self.newsNumArr[indexPath.row]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            NewsTypeViewController *newsTypeVC = [[NewsTypeViewController alloc]init];
            newsTypeVC.titleStr = @"佣金消息";
            newsTypeVC.newsType = NewsTypeCommission;
            [self.navigationController pushViewController:newsTypeVC animated:YES];
        }
            break;
        case 1:{
            NewsTypeViewController *newsTypeVC = [[NewsTypeViewController alloc]init];
            newsTypeVC.titleStr = @"保单消息";
            newsTypeVC.newsType = NewsTypePolicy;
            [self.navigationController pushViewController:newsTypeVC animated:YES];
        }
            break;
        case 2:{
            NewsInterViewController *newsTypeVC = [[NewsInterViewController alloc]init];
            [self.navigationController pushViewController:newsTypeVC animated:YES];
        }
            break;
        case 3:{
            NewsGroupViewController *newsTypeVC = [[NewsGroupViewController alloc]init];
            [self.navigationController pushViewController:newsTypeVC animated:YES];
        }
            break;
        case 4:{
            NewsTypeViewController *newsTypeVC = [[NewsTypeViewController alloc]init];
            newsTypeVC.titleStr = @"其他消息";
            newsTypeVC.newsType = NewsTypeOther;
            [self.navigationController pushViewController:newsTypeVC animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
