//
//  GroupTopicViewController.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/12.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "GroupTopicViewController.h"
#import "configure.h"

/** 自定义分享 */
#import "CustomShareUI.h"
/** 预览 */
#import "HDPhotoBrowserView.h"
/** webview */
#import "QLWKWebViewController.h"

//无数据
#import "QLScrollViewExtension.h"
//输入框
#import "RLBInputView.h"
#import "RLBSelectImagePickerTool.h"
/** 自定义字符串 */
#import "TYAttributedLabel.h"
//无数据
#import "RLBListNoDataTipView.h"
#import "RLBDetailNoDataTipView.h"

#import "GroupTopicTopView.h"
#import "DetailAnswerHeaderView.h"
#import "DetailAnswerCell.h"

#import "GroupTopicCommentModel.h"
#import "GroupDetailTopicModel.h"
#import "ReplyModel.h"

#define HeaderFooterHeight 40

typedef NS_ENUM(NSInteger, CommentType) {
    CommentTypeReply = 100010, //回复
    CommentTypePublish,        //发表
};

@interface GroupTopicViewController ()<UITableViewDelegate,UITableViewDataSource,RLBInputViewDelagete,TYAttributedLabelDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, strong) GroupTopicTopView *topView;
//错误数据view
@property (nonatomic, weak) RLBDetailNoDataTipView *noDetailTipView;
@property (nonatomic, strong) RLBListNoDataTipView *noDataFooterView;

@property(nonatomic,strong) NSMutableArray *commentDataArr;

/** 保存状态(展开/折叠) */
@property (nonatomic, strong) NSMutableArray *switchArr;

/** 顶部view + section 0 的数据 */
@property (nonatomic, strong) GroupDetailTopicModel *detailModel;
@property (nonatomic, assign) NSInteger commentListPage;

/** 回复时使用 */
@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, copy) NSString *toUserName;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *linkId;
/*!
 是发表（Publish）还是回复Reply
 发表刷新整个数据、回复值刷新某个section
 */
@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, assign) NSInteger replaceSection;

/** 滑动 */
@property (nonatomic, strong) NSIndexPath *currentIndex;//当前的cell所在的indexPath
@property (nonatomic, assign) BOOL isNeedToScrollOffset;//是否需要滑动
@property (nonatomic, assign) CGFloat currentOffsetY;//滑动前的offset

//当前输入的文字
@property (nonatomic, copy) NSString *currentCommentStr;
//选择图片的数据
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
//输入的url链接
@property (nonatomic, copy) NSString *selectUrlLinkStr;

//用来取数据
@property (nonatomic, strong) GroupTopicCommentModel *currentModel;
@end

@implementation GroupTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"话题详情";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain  target:self action:@selector(ShareQuestionItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self createUI];
    [self addInputControl];
    if(self.topicDetailModel != nil){
        self.appTopicId = [NSString stringWithFormat:@"%@",self.topicDetailModel.topicId];
    }
    [self requestGroupDetailTopicDetailData];
    self.commentListPage = 1;
    [self requestGroupDetailCommentListDataWith:self.commentListPage];
    //loading页
    [self createNoDataTipView];
}
#pragma mark - 接入热点
- (void)adjustStatusBar{
    CGFloat height = Height_View_SafeArea-44-50;
    CGRect frame = self.tableView.frame;
    frame.size.height = height;
    self.tableView.frame = frame;
    
    self.bottomView.frame = CGRectMake(0, self.tableView.bottom, Width_Window, 50+Height_View_HomeBar);
}
#pragma mark - 无数据view
-(void)createNoDataTipView{
    RLBDetailNoDataTipView *noDetailTipView = [[RLBDetailNoDataTipView alloc]initWithFrame:self.view.frame imageName:@"NoData" tipText:KDetailPostDataRequestIng];
    noDetailTipView.tipType = NoDataTipTypeRequestLoading;
    noDetailTipView.tapClick = ^(NoDataTipType tipType) {
        if (tipType == NoDataTipTypeNoData) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self requestGroupDetailTopicDetailData];
        }
    };
    [self.view addSubview:noDetailTipView];
    [self.view bringSubviewToFront:noDetailTipView];
    _noDetailTipView = noDetailTipView;
}
#pragma mark - share
-(void)ShareQuestionItem{
    //判断appTopicId是否有值
    if (self.detailModel == nil) {
        return;
    }
    NSString *shareUrl = [NSString stringWithFormat:@"http://%@/appTopic/share/%@",RequestHeader,self.appTopicId];
    NSString *shareTitle = [NSString stringWithFormat:@"%@",self.detailModel.circleName];
    NSString *shareDes = [NSString stringWithFormat:@"%@",self.detailModel.topicContent];
    [CustomShareUI shareWithUrl:shareUrl Title:shareTitle DesStr:shareDes];
}

#pragma mark - 请求数据
-(void)requestGroupDetailTopicDetailData{
    WeakSelf
    [[RequestManager sharedInstance]postGroupTopicDetailWithUserID:[StoreTool getUserID] TopicId:self.appTopicId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                [strongSelf.noDetailTipView removeFromSuperview];
                
                GroupDetailTopicModel *detailAllModel = [GroupDetailTopicModel yy_modelWithDictionary:TipDic[@"appTopic"]];
                strongSelf.detailModel = detailAllModel;
                
                [strongSelf reloadTableHeaderViewData:detailAllModel];
            } else {
                if ([TipDic[@"code"] isEqualToString:@"1001"] || [TipDic[@"code"] isEqualToString:@"1002"]) {
                    [strongSelf createAlertVCWithNoData];
                }else{
                    self.noDetailTipView.tipType = NoDataTipTypeRequestError;
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
-(void)createAlertVCWithNoData{
    [self reloadTableHeaderViewData: nil];
    self.navigationItem.rightBarButtonItem = nil;
    self.noDetailTipView.tipType = NoDataTipTypeNoData;
    [self.noDetailTipView changeTipLabel:KGroupTopicDetailDataRemoved];
}

#pragma mark - 请求评论列表
-(void)requestGroupDetailCommentListDataWith:(NSInteger)page{
    WeakSelf
    [[RequestManager sharedInstance]postGroupTopicDetailCommentListWithUserID:[StoreTool getUserID] TopicId:self.appTopicId ListPage:page Success:^(id responseData) {
        [self.tableView.mj_footer endRefreshing];
        
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                strongSelf.topView.answerNumLabel.text = [NSString stringWithFormat:@"    %@ 评论",TipDic[@"total"]];
                if (strongSelf.commentListPage == 1) {
                    [strongSelf.commentDataArr removeAllObjects];
                    [strongSelf.switchArr removeAllObjects];
                }
                if ([TipDic[@"list"] count] == 0) {
                    [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    strongSelf.commentListPage ++;
                    
                    for (NSDictionary *dict1 in TipDic[@"list"]) {
                        GroupTopicCommentModel *infoModel = [[GroupTopicCommentModel alloc]initWithDic:dict1];
                        [strongSelf.switchArr addObject:@NO];
                        [strongSelf.commentDataArr addObject:infoModel];
                    }
                    [strongSelf.tableView reloadData];
                }
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

#pragma mark - 根据情况划分i请求的接口与数据
- (void)postRequestDataWithCommentType:(CommentType)commentType Comment:(NSString *)commentStr commentId:(NSString *)commentId linkId:(NSString *)linkId toUserId:(NSString *)toUserId LinkCommentUrl:(NSString *)linkCommentUrl imgCommentArr:(NSMutableArray *)imgCommentArr{
    if (commentType == CommentTypeReply) {
        [self postAddComment:commentStr commentId:self.commentId linkId:self.linkId toUserId:self.toUserId LinkCommentUrl:@"" ImgCommentUrl:@"" commentType:commentType];
    }else{
        if (imgCommentArr.count != 0) {
            //有图片
            [self hasPhotoToPostImageComment:commentStr commentId:commentId linkId:linkId toUserId:toUserId LinkCommentUrl:linkCommentUrl];
        }else{
            //无图片
            [self postAddComment:commentStr commentId:self.commentId linkId:self.linkId toUserId:self.toUserId LinkCommentUrl:linkCommentUrl ImgCommentUrl:@"" commentType:commentType];
        }
    }
}
- (void)hasPhotoToPostImageComment:(NSString *)commentStr commentId:(NSString *)commentId linkId:(NSString *)linkId toUserId:(NSString *)toUserId LinkCommentUrl:(NSString *)linkCommentUrl{
    __block NSString *uploadPohtoStr = @"";
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t searialQueue = dispatch_queue_create("com.topic.imageuploader.responsequeue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_group_enter(group);
    dispatch_group_async(group, searialQueue, ^{
        // 网络请求一
        UIImage *tmpImage = self.selectedPhotos[0];
        //上传图片
        [[QLMBProgressHUD sharedInstance] showLoadWithTitle:@"数据正在上传，请等待..."];
        [[RequestManager sharedInstance]postGroupTopicDetailUploadPhoto:tmpImage TopicId:self.appTopicId Success:^(id responseData) {
            NSDictionary *TipDic = responseData;
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                uploadPohtoStr = [NSString stringWithFormat:@"%@",TipDic[@"imgCommentUrl"]];
                dispatch_group_leave(group);
            }else{
                dispatch_group_leave(group);
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
            }
        } Error:^(NSError *error) {
            dispatch_group_leave(group);
            [[QLMBProgressHUD sharedInstance] hideLoad];
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }];
    });
    
    //N个网络请求结束后，会进入这个方法，在这个方法中进行下一步请求
    dispatch_group_notify(group, searialQueue, ^{
        if (uploadPohtoStr.length > 0) {
            //在请求数据
            [self postAddComment:commentStr commentId:self.commentId linkId:self.linkId toUserId:self.toUserId LinkCommentUrl:linkCommentUrl ImgCommentUrl:uploadPohtoStr commentType:CommentTypePublish];
        }
    });
}

#pragma mark - 回复 & 发表post
- (void)postAddComment:(NSString *)commentStr commentId:(NSString *)commentId linkId:(NSString *)linkId toUserId:(NSString *)toUserId LinkCommentUrl:linkCommentUrl ImgCommentUrl:imgCommentUrl commentType:(CommentType)commentType{
    WeakSelf
    [[RequestManager sharedInstance]postGroupTopicDetailCommentAddWithAppTopicId:self.appTopicId CommentId:commentId LinkId:linkId CommentContent:commentStr UserId:[StoreTool getUserID] ToUserId:toUserId LinkCommentUrl:linkCommentUrl ImgCommentUrl:imgCommentUrl Success:^(id responseData) {
        [[QLMBProgressHUD sharedInstance] hideLoad];
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                strongSelf.currentCommentStr = @"";
                strongSelf.selectUrlLinkStr = @"";
                [strongSelf.selectedPhotos removeAllObjects];
                [strongSelf.selectedAssets removeAllObjects];
                
                if (commentType == CommentTypePublish) {
                    //发表
                    [QLMBProgressHUD showPromptViewInView:strongSelf.view WithTitle:TipDic[@"message"]];
                    strongSelf.commentListPage = 1;
                    [strongSelf requestGroupDetailCommentListDataWith:self.commentListPage];
                }else{
                    //本地构造model,替换出本section的model，在替换总的model处理数据进行刷新
                    NSString *rid = [NSString stringWithFormat:@"%@",TipDic[@"replyId"]];
                    [self handleFatherWithCommentStr:commentStr replyId:rid];
                    
                    [strongSelf.switchArr replaceObjectAtIndex:strongSelf.replaceSection withObject:@YES];
                    [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:strongSelf.replaceSection] withRowAnimation:UITableViewRowAnimationFade];
                }
            } else {
                [QLMBProgressHUD showPromptViewInView:self.view WithTitle:TipDic[@"message"]];
            }
        } else {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
        }
    } Error:^(NSError *error) {
        [[QLMBProgressHUD sharedInstance] hideLoad];
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}
#pragma mark - 点赞
-(void)requestGroupDetailLikeData{
    WeakSelf
    [[RequestManager sharedInstance]postGroupTopicDetailLikeWithUserID:[StoreTool getUserID] TopicId:self.appTopicId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                //                TipDic[@"likeStatus"]
                strongSelf.topView.isLikeSelect = @"yes";
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
#pragma mark - 本地添加回复model
-(void)handleFatherWithCommentStr:(NSString *)commentStr replyId:(NSString *)rid{
    NSDictionary *replyDict = @{@"replyContent":commentStr,@"replyId":[StoreTool getUserID],@"replyName":[StoreTool getRealname],@"replyTime":[self locationDateToString],@"replyToId":self.toUserId,@"replyToName":self.toUserName,@"rid":rid};
    ReplyModel *infoModel = [[ReplyModel alloc]initReplyModelWithDic:replyDict];
    GroupTopicCommentModel *replaceModel = [[GroupTopicCommentModel alloc] handleModelWith:infoModel fatherModel:self.currentModel];
    [self.commentDataArr replaceObjectAtIndex:self.replaceSection withObject:replaceModel];
}

#pragma mark - 置顶
-(void)requestGroupDetailSetTopData{
    WeakSelf
    [[RequestManager sharedInstance]postGroupTopicDetailSetTopWithUserID:[StoreTool getUserID] CircleId:self.detailModel.circleId TopicId:self.appTopicId Success:^(id responseData) {
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *TipDic = dict[@"data"];
            if ([TipDic[@"flag"] isEqualToString:@"true"]) {
                strongSelf.topView.isTopStatus = TipDic[@"topStatus"];
                [QLMBProgressHUD showPromptViewInView:strongSelf.view WithTitle:TipDic[@"message"]];
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
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_View_SafeArea-44-50) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    [tableView registerClass:NSClassFromString(@"DetailAnswerHeaderView") forHeaderFooterViewReuseIdentifier:@"detailAnswerHeaderView"];
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
                                              tipText:@"暂无评论"];
    tableView.tableFooterView = noDataFooterView;
    _noDataFooterView = noDataFooterView;
    
    //顶部view
    GroupTopicTopView *topView = [[GroupTopicTopView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 300)];
    topView.likeBtnClickBlock = ^(TopBtnType topBtnType) {
        [self handleSetTopAndLike:topBtnType];
    };
    tableView.tableHeaderView = topView;
    _topView = topView;
    
    /** 进行tableHeaderView 的自适应高度变换 */
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.equalTo(tableView);
    }];
    
    [self reloadTableHeaderViewData:self.topicDetailModel];
}
-(void)reloadTableHeaderViewData:(GroupDetailTopicModel *)model{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topView.detailTopModel = model;
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
    [self requestGroupDetailCommentListDataWith:self.commentListPage];
}
#pragma mark - 置顶 & 点赞 处理
-(void)handleSetTopAndLike:(TopBtnType)btnType{
    if (![StoreTool getLoginStates]) {
        //未登录时候跳转至登录页面
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
        return;
    }
    
    if (btnType == TopBtnTypeTop) {
        //置顶
        [self requestGroupDetailSetTopData];
    }else{
        //点赞
        if (![self.detailModel.isJoin isEqualToString:@"yes"]) {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请您加入该圈子后再进行相关操作..."];
            return;
        }
        [self requestGroupDetailLikeData];
    }
}
#pragma mark - 底部输入框
-(void)addInputControl{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.bottom, Width_Window, 50+Height_View_HomeBar)];
    bgView.backgroundColor = [UIColor customBackgroundColor];
    [self.view addSubview:bgView];
    
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(10, 5, bgView.width-100, 40)];
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
    
    _bottomView = bgView;
}

-(void)showTextField:(UIControl *)sender{
    if (![StoreTool getLoginStates]) {
        //未登录时候跳转至登录页面
        [JumpToLoginVCTool jumpToLoginVCWithFatherViewController:self methodType:LogInAppearTypePresent];
        return;
    }
    if (![self.detailModel.isJoin isEqualToString:@"yes"]) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请您加入该圈子后再进行相关操作..."];
        return;
    }
    /*!
     1.底部发表按钮
     2.点击head回复按钮 nil
     */
    NSString *inputPlaceholder = @"";
    if (sender != nil) {
        //发表
        self.toUserId = @"";
        self.toUserName = @"";
        self.commentId = @"";
        self.linkId = @"";
        self.commentType =CommentTypePublish;
        inputPlaceholder = @"我也来说几句...(最多500字)";
    }else{
        self.commentType = CommentTypeReply;
        inputPlaceholder = [NSString stringWithFormat:@"回复 %@：",self.toUserName];
    }
    RLBInputViewStyle rlbInputViewStyle;
    if (self.commentType == CommentTypePublish) {
        rlbInputViewStyle = RLBInputViewStyleDefault;
    }else{
        rlbInputViewStyle = RLBInputViewStyleReply;
    }
    WeakSelf
    [RLBInputView showWithStyle:rlbInputViewStyle configurationBlock:^(RLBInputView *inputView) {
        StrongSelf
        /** 请在此block中设置inputView属性 */
        /** 代理 */
        inputView.delegate = strongSelf;
        /** 带进去的内容 */
        inputView.defaultText = strongSelf.currentCommentStr;
        /** 占位符文字 */
        inputView.placeholder = inputPlaceholder;
        /** 设置最大输入字数 */
        inputView.maxCount = 500;
        /** 选择的图片 */
        inputView.selectedPhotos = strongSelf.selectedPhotos;
        inputView.selectedAssets = strongSelf.selectedAssets;
        inputView.urlLinkStr = strongSelf.selectUrlLinkStr;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        /** 更多属性设置,详见XHInputView.h文件 */
    } sendBlock:^BOOL(NSString *text,NSString *linkUrlText,NSMutableArray *photos) {
        if(text.length){
            NSLog(@"输入的信息为:%@",text);
            /*!
             点击发表按钮的返回事件
             此处划分是底部发表新评论 CommentTypePublish ,在此时，应该若有图片则会有图片的上传，采用GCD的先后顺序上传
             还是header的回复功能 RLBInputViewStyleReply
             */
            [self postRequestDataWithCommentType:self.commentType Comment:text commentId:self.commentId linkId:self.linkId toUserId:self.toUserId LinkCommentUrl:linkUrlText imgCommentArr:photos];
            return YES;//return YES,收起键盘
        }else{
            NSLog(@"显示提示框-请输入要评论的的内容");
            [QLMBProgressHUD showPromptViewInView:nil WithTitle:@"内容不得为空~"];
            return NO;//return NO,不收键盘
        }
    } selectImageBlock:^{
        //选择
        StrongSelf
        [[RLBSelectImagePickerTool sharedInstance] selectImagePickerWithCurrentVC:self selectAssetsArr:nil selectAssetBlock:^(NSArray<UIImage *> *photos, NSArray *assets) {
            NSLog(@"xuanle");
            strongSelf->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
            strongSelf->_selectedAssets = [NSMutableArray arrayWithArray:assets];
            [strongSelf showTextField:sender];
        } selectCancleBlock:^{
            NSLog(@"quxiao");
            [strongSelf showTextField:sender];
        }];
    } previewImageBlock:^(NSMutableArray *photos, NSMutableArray *assets) {
        //预览
        StrongSelf
        [[RLBSelectImagePickerTool sharedInstance] selectImagePickerToPreviewWithCurrentVC:strongSelf selectAssetArr:assets selectedPhotoArr:photos selectAssetBlock:^(NSArray<UIImage *> *photos, NSArray *assets) {
            [strongSelf showTextField:sender];
        } selectCancleBlock:^{
            [strongSelf showTextField:sender];
        }];
    }];
}
#pragma mark - XHInputViewDelagete
-(void)rlbInputViewWillHide:(RLBInputView *)inputView{
    self.selectedPhotos = inputView.selectedPhotos;
    self.selectedAssets = inputView.selectedAssets;
    self.selectUrlLinkStr = [NSString stringWithFormat:@"%@",inputView.urlLinkStr];
    self.currentCommentStr = [NSString stringWithFormat:@"%@",inputView.textView.text];
}

-(void)rlbInputViewKeyboardWillShow:(CGFloat)inputOriginY{
    if (self.commentType == CommentTypeReply) {
        [self scrollViewDropDown:inputOriginY];
    }
}

-(void)rlbInputViewKeyboardWillHide:(CGFloat)inputOriginY{
    if (self.commentType == CommentTypeReply) {
        if (self.isNeedToScrollOffset) {
            [self.tableView setContentOffset:CGPointMake(0, self.currentOffsetY) animated:YES];
        }
    }
}
#pragma mark - 滑动
-(void)scrollViewDropDown:(CGFloat)originY{
    CGRect rectInTableView;
    if (self.currentIndex == nil) {
        rectInTableView = [self.tableView rectForHeaderInSection:self.replaceSection];
    }else{
        rectInTableView = [self.tableView rectForRowAtIndexPath:self.currentIndex];
    }
    
    CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    CGFloat heightToBottom = Height_Window + 50 - rect.origin.y - rectInTableView.size.height;
    
    if(heightToBottom > originY){
        self.isNeedToScrollOffset = NO;
        return;
    }else{
        self.isNeedToScrollOffset = YES;
        self.currentOffsetY = self.tableView.contentOffset.y;
        [self.tableView setContentOffset:CGPointMake(0, self.currentOffsetY + originY-heightToBottom) animated:YES];
    }
}


#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //第一次进来或者每次reloadData否会调一次该方法，在此控制footer是否隐藏
    self.tableView.mj_footer.hidden = (self.commentDataArr.count == 0);
    self.tableView.tableFooterView.hidden = (self.commentDataArr.count != 0);
    if (self.commentDataArr.count == 0) {
        [self reloadTableFooterViewData:self.noDataFooterView];
    }else{
        [self reloadTableFooterViewData:nil];
    }
    
    
    return self.commentDataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GroupTopicCommentModel *infoModel = self.commentDataArr[section];
    NSInteger rowsNum = infoModel.textContainers.count;
    
    if ([self.switchArr[section] boolValue] == YES) {
        return rowsNum;
    } else {
        if (rowsNum > 3) {
            return 3;
        }else{
            return rowsNum;
        }
    }
}
#pragma mark -- header In Section
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    GroupTopicCommentModel *eachModel = self.commentDataArr[section];
    return eachModel.headerHeight;
}
//1-回复
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DetailAnswerHeaderView *headerView = (DetailAnswerHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"detailAnswerHeaderView"];
    headerView.detailHeaderLabel.delegate = self;
    GroupTopicCommentModel *eachModel = self.commentDataArr[section];
    headerView.model = eachModel;
    
    [headerView setReplyBtnClickBlock:^(DetailAnswerHeaderView *headView) {
        //弹出视图
        self.currentModel = eachModel;
        self.toUserId = [NSString stringWithFormat:@"%@",eachModel.commentId];
        self.toUserName = [NSString stringWithFormat:@"%@",eachModel.commentName];
        self.commentId = [NSString stringWithFormat:@"%@",eachModel.cid];
        self.linkId = [NSString stringWithFormat:@"%@",eachModel.cid];
        self.commentType = CommentTypeReply;
        self.replaceSection = section;
        self.currentIndex = nil;
        [self showTextField:nil];
    }];
    [headerView setCommentImageClickBlock:^(NSString *imageUrl) {
        NSArray *arr = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@",imageUrl]];
        HDPhotoBrowserView *browser = [[HDPhotoBrowserView alloc] initWithCurrentIndex:0 imageURLArray:arr placeholderImage:nil sourceView:nil];
        [browser show];
    }];
    return headerView;
}
#pragma mark -- footer In Section
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    GroupTopicCommentModel *infoModel = self.commentDataArr[section];
    NSInteger rowsNum = infoModel.textContainers.count;
    if (rowsNum > 3) {
        return HeaderFooterHeight;
    }
    return 5.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    GroupTopicCommentModel *infoModel = self.commentDataArr[section];
    NSInteger rowsNum = infoModel.textContainers.count;
    if (rowsNum > 3) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, HeaderFooterHeight)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, Width_Window-20, HeaderFooterHeight-5)];
        btn.backgroundColor = [UIColor customLineColor];
        [btn setTitleColor:[UIColor customBlueColor] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if ([self.switchArr[section] boolValue] == YES) {
            [btn setTitle:@"   收起" forState:UIControlStateNormal];
        } else {
            [btn setTitle:@"  显示全部" forState:UIControlStateNormal];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [btn addTarget:self action:@selector(popAndPushIndex:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = section;
        [view addSubview:btn];
        return view;
    }
    return  nil;
}
#pragma mark - Row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupTopicCommentModel *eachModel = self.commentDataArr[indexPath.section];
    TYTextContainer *textContaner = eachModel.textContainers[indexPath.row];
    return textContaner.textHeight+10;// after createTextContainer, have value
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"identifer";
    DetailAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[DetailAnswerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.label.delegate = self;
    GroupTopicCommentModel *eachModel = self.commentDataArr[indexPath.section];
    cell.container = eachModel.textContainers[indexPath.row];
    return cell;
}
//2-cell点击回复
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //弹出视图
    GroupTopicCommentModel *eachModel = self.commentDataArr[indexPath.section];
    ReplyModel *replyModel = eachModel.replys[indexPath.row];
    self.currentModel = eachModel;
    self.toUserId = [NSString stringWithFormat:@"%@",replyModel.replyId];
    self.toUserName = [NSString stringWithFormat:@"%@",replyModel.replyName];
    self.commentId = [NSString stringWithFormat:@"%@",eachModel.cid];
    self.linkId = [NSString stringWithFormat:@"%@",replyModel.rid];
    self.commentType = CommentTypeReply;
    self.replaceSection = indexPath.section;
    self.currentIndex = indexPath;
    [self showTextField:nil];
}

#pragma mark - TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point{
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        if(attributedLabel.tag == 10087){
            //cell上的
            UIView *contentView = [attributedLabel superview];//获取button所在的父类视图UITableViewCellContentView
            DetailAnswerCell *cell = (DetailAnswerCell *)[contentView superview];//获取cell
            NSIndexPath *indexPathAll = [self.tableView indexPathForCell:cell];//获取cell对应的section
            
            id linkData = ((TYLinkTextStorage*)TextRun).linkData;
            if ([linkData isKindOfClass:[NSDictionary class]]) {
                self.currentIndex = indexPathAll;
                
                NSDictionary *linkDict = (NSDictionary *)linkData;
                GroupTopicCommentModel *eachModel = self.commentDataArr[indexPathAll.section];
                ReplyModel *replyModel = eachModel.replys[indexPathAll.row];
                self.currentModel = eachModel;
                self.toUserId = [NSString stringWithFormat:@"%@",linkDict[@"toUserId"]];
                self.toUserName = [NSString stringWithFormat:@"%@",linkDict[@"toUserName"]];
                self.commentId = [NSString stringWithFormat:@"%@",eachModel.cid];
                self.linkId = [NSString stringWithFormat:@"%@",replyModel.rid];
                self.commentType = CommentTypeReply;
                self.replaceSection = indexPathAll.section;
                [self showTextField:nil];
            }
        }else if(attributedLabel.tag == 10086){
            //headerview上的
            id linkData = ((TYLinkTextStorage*)TextRun).linkData;
            if ([linkData isKindOfClass:[NSString class]]) {
                NSLog(@">>>%@",linkData);
                QLWKWebViewController *webVC = [[QLWKWebViewController alloc]init];
                webVC.urlStr =linkData;
                webVC.titleStr = @"详情";
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
    }
}

#pragma mark - 展开/收起
-(void)popAndPushIndex:(UIButton *)sender{
    NSInteger section = sender.tag;
    [self changeItemSwitch: section];
}
-(void)changeItemSwitch:(NSInteger)section{
    if ([self.switchArr[section] boolValue] == NO) {
        [self.switchArr replaceObjectAtIndex:section withObject:@YES];
    } else {
        [self.switchArr replaceObjectAtIndex:section withObject:@NO];
    }
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    CGPoint offsetSwitch = self.tableView.contentOffset;
    if (offsetSwitch.y < 0) {
        [self.tableView setContentOffset:CGPointZero];
    }
}


#pragma mark - 懒加载
- (NSMutableArray *)commentDataArr{
    if (_commentDataArr==nil) {
        NSMutableArray *arr = [NSMutableArray array];
        _commentDataArr = arr;
    }
    return _commentDataArr;
}
- (NSMutableArray *)switchArr {
    if (!_switchArr) {
        _switchArr = [[NSMutableArray alloc]init];
    }
    return _switchArr;
}
- (NSMutableArray *)selectedAssets{
    if (_selectedAssets==nil) {
        NSMutableArray *arr = [NSMutableArray array];
        _selectedAssets = arr;
    }
    return _selectedAssets;
}
- (NSMutableArray *)selectedPhotos{
    if (_selectedPhotos==nil) {
        NSMutableArray *arr = [NSMutableArray array];
        _selectedPhotos = arr;
    }
    return _selectedPhotos;
}

#pragma mark - 本地时间
- (NSString *)locationDateToString{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //设置为系统时区
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
