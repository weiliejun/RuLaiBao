//
//  PPTViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "PPTViewController.h"
#import "Configure.h"
#import "HDPhotoBrowserView.h"
//model
#import "PPTDataModel.h"
//无数据
#import "QLScrollViewExtension.h"
//cell
#import "PPTTableViewCell.h"
//底部的pdfview
#import "PPTTableFooterView.h"
#import "QLWKWebViewController.h"

@interface PPTViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) PPTDataModel *pptModel;
@property (nonatomic, strong) PPTTableFooterView *footerView;
@end

@implementation PPTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createUI];
    
    [self requestDetailCoursePPT];
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
-(void)requestDetailCoursePPT{
    WeakSelf
    self.tableView.loading = YES;
    [[RequestManager sharedInstance]postCourseDetailPPTWithCourseId:self.courseDetailId Success:^(id responseData) {
        self.tableView.loading = NO;
        
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            //赋值
            PPTDataModel *pptModel = [PPTDataModel yy_modelWithDictionary:TipDic];
            strongSelf.pptModel = pptModel;
            [strongSelf.tableView reloadData];
            //修改title
            _footerView.titleText = pptModel.courseFileName;
            
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        self.tableView.loading = NO;
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
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
    
    PPTTableFooterView *footerView = [[PPTTableFooterView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 180) backgroundColor:[UIColor customBackgroundColor] titleFrame:CGRectMake(15, 80, Width_Window-30, 30) titleLabelBGColor:[UIColor whiteColor] titleText:@"QL.pdf" titleClickBlock:^{
        //点击事件
        QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
        webVC.titleStr = [NSString stringWithFormat:@"%@",self.pptModel.courseFileName];
        webVC.urlStr = [NSString stringWithFormat:@"%@",self.pptModel.courseFilePath];
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    tableView.tableFooterView = footerView;
    _footerView = footerView;
    
    //空数据方法
    [tableView addNoDataDelegateAndDataSource];
    tableView.emptyDataSetType = EmptyDataSetTypeOrder;
    tableView.dataVerticalOffset = -CGRectGetHeight(self.view.frame)/10;
    // 点击响应
    [tableView QLExtensionLoading:^{
        //进行请求数据
        [self requestDetailCoursePPT];
    }];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.pptModel.pptImgs.count;
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
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    PPTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[PPTTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.imageUrlStr = [NSString stringWithFormat:@"%@",self.pptModel.pptImgs[indexPath.section]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //放大
    HDPhotoBrowserView *browser = [[HDPhotoBrowserView alloc] initWithCurrentIndex:indexPath.section imageURLArray:self.pptModel.pptImgs placeholderImage:nil sourceView:nil];
    [browser show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
