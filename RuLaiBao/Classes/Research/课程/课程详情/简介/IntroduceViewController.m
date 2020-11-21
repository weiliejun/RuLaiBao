//
//  IntroduceViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "IntroduceViewController.h"
#import "Configure.h"
#import "QLScrollViewExtension.h"

#import "IntroduceTopView.h"
#import "IntroduceBottomView.h"

#import "IntroduceModel.h"

@interface IntroduceViewController ()
@property (nonatomic, weak) UIScrollView *vScrollView;
/** topView */
@property (nonatomic, weak) IntroduceTopView *topView;
/** bottomView */
@property (nonatomic, weak) IntroduceBottomView *bottomView;

@end

@implementation IntroduceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createUI];
    [self requestDetailCourseContent];
}
//解决视频播放旋转的问题
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.vScrollView.frame = CGRectMake(0, 0, Width_Window, self.viewHeight);
}
-(void)requestDetailCourseContent{
    WeakSelf
    [[RequestManager sharedInstance]postCourseDetailContentWithID:self.courseDetailId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                //赋值
                IntroduceModel *introduceModel = [IntroduceModel yy_modelWithDictionary:TipDic[@"course"]];
                strongSelf.topView.introduceInfoModel = introduceModel;
                strongSelf.bottomView.introduceInfoModel = introduceModel;
                if (strongSelf.courseVideoBlock) {
                    strongSelf.courseVideoBlock(introduceModel, YES);
                }
            } else {
                if (strongSelf.courseVideoBlock) {
                    strongSelf.courseVideoBlock(nil, NO);
                }
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
    //将Height_View_HomeBar展示
    UIScrollView *vScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, self.viewHeight)];
    vScrollView.backgroundColor = [UIColor customBackgroundColor];
//    vScrollView.bounces = NO;
    [self.view addSubview:vScrollView];
    /** 去掉错乱情况 */
    adjustsScrollViewInsets_NO(vScrollView, self);
    
    IntroduceTopView *topView = [[IntroduceTopView alloc]initWithFrame:CGRectMake(0, 10, Width_Window, 100)];
    [vScrollView addSubview:topView];
    
    IntroduceBottomView *bottomView = [[IntroduceBottomView alloc]initWithFrame:CGRectMake(0, topView.bottom+10, Width_Window, 120)];
    [vScrollView addSubview:bottomView];
    
    _vScrollView = vScrollView;
    _topView = topView;
    _bottomView = bottomView;
}

#pragma mark - 接入热点
- (void)adjustStatusBar{
    CGFloat height = Height_View_SafeArea -44- Width_Window * 9/16 - 51;
    CGRect frame = self.vScrollView.frame;
    frame.size.height = height;
    self.vScrollView.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
