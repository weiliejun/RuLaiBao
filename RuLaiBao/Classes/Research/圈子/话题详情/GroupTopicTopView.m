//
//  GroupTopicTopView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/12.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "GroupTopicTopView.h"
#import "Configure.h"
#import "GroupDetailTopicModel.h"

@interface GroupTopicTopView ()
//头像
@property (nonatomic, weak) UIImageView *headImageV;
//作者
@property (nonatomic, weak) UILabel *authorLabel;
//置顶
@property (nonatomic, weak) UIButton *topBtn;
//内容
@property (nonatomic, weak) UILabel *detailLabel;
//来自圈子
@property (nonatomic, weak) UILabel *groupLabel;
//圈子name
@property (nonatomic, weak) UILabel *groupNameLabel;
//时间
@property (nonatomic, weak) UILabel *timeLabel;
//线
@property (nonatomic, weak) UIView *lineView;
//点赞按钮
@property (nonatomic, weak) UIButton *likeBtn;
//赞20
@property (nonatomic, weak) UILabel *noteLabel;
//评论
@property (nonatomic, weak) UILabel *answerNumLabel;

@property (nonatomic, assign) NSInteger likeCount;
@end

@implementation GroupTopicTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        //此处若变换label的字间距或者行间距，请重写布局，不可使用layout
        [self addUILayout];
    }
    return self;
}
-(void)setDetailTopModel:(GroupDetailTopicModel *)detailTopModel{
    _detailTopModel = detailTopModel;
    
    self.authorLabel.text = [[NSString stringWithFormat:@"%@",detailTopModel.creatorName]isEqualToString:@"(null)"] ? @"--" : [NSString stringWithFormat:@"%@",detailTopModel.creatorName];
    
    self.detailLabel.text = [[NSString stringWithFormat:@"%@",detailTopModel.topicContent]isEqualToString:@"(null)"] ? @"--" : [NSString stringWithFormat:@"%@",detailTopModel.topicContent];
    
    self.groupNameLabel.text = [[NSString stringWithFormat:@"%@",detailTopModel.circleName] isEqualToString:@"(null)"] ? @"--" : [NSString stringWithFormat:@"%@",detailTopModel.circleName];
    self.timeLabel.text =[[NSString stringWithFormat:@"%@",detailTopModel.createTime]isEqualToString:@"(null)"] ? @"0000:00:00" : [NSString stringWithFormat:@"%@",detailTopModel.createTime];
    
    self.noteLabel.text = [[NSString stringWithFormat:@"%@",detailTopModel.likeCount]isEqualToString:@"(null)"] ? @"--" : [NSString stringWithFormat:@"给TA一个赞(%@)",detailTopModel.likeCount];
    self.likeCount = [detailTopModel.likeCount integerValue];
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload;
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:detailTopModel.creatorPhoto] placeholderImage:[UIImage imageNamed:@"information_header"] options:options];
    
    self.answerNumLabel.text = [[NSString stringWithFormat:@"%@",detailTopModel.commentCount]isEqualToString:@"(null)"] ? @"    0评论" : [NSString stringWithFormat:@"    %@评论",detailTopModel.commentCount];
    
    if ([[NSString stringWithFormat:@"%@",detailTopModel.likeStatus] isEqualToString:@"yes"]) {
        self.likeBtn.selected = YES;
        self.likeBtn.userInteractionEnabled = NO;
    }else{
        self.likeBtn.selected = NO;
        self.likeBtn.userInteractionEnabled = YES;
    }
    
    if ([[NSString stringWithFormat:@"%@",detailTopModel.isManager] isEqualToString:@"yes"]) {
        self.topBtn.hidden = NO;
        if ([[NSString stringWithFormat:@"%@",detailTopModel.isTop] isEqualToString:@"yes"]) {
            [self.topBtn setTitle:@"取消置顶" forState:UIControlStateNormal];
        }else{
            [self.topBtn setTitle:@"设为置顶" forState:UIControlStateNormal];
        }
    }else{
        self.topBtn.hidden = YES;
    }
    
    self.authorLabel.backgroundColor = [UIColor clearColor];
    self.detailLabel.backgroundColor = [UIColor clearColor];
    self.groupNameLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.noteLabel.backgroundColor = [UIColor clearColor];
}
-(void)setIsLikeSelect:(NSString *)isLikeSelect{
    _isLikeSelect = isLikeSelect;
    if ([isLikeSelect isEqualToString:@"yes"]) {
        //变化图标和数字
        self.likeBtn.selected = YES;
        self.likeBtn.userInteractionEnabled = NO;
        self.likeCount ++;
        self.noteLabel.text = [NSString stringWithFormat:@"给TA一个赞(%ld)",self.likeCount];
    }else{
        self.likeBtn.selected = NO;
        self.likeBtn.userInteractionEnabled = YES;
        self.likeCount --;
        self.noteLabel.text = [NSString stringWithFormat:@"给TA一个赞(%ld)",self.likeCount];
    }
}
/** yes:置顶；no:取消置顶； */
-(void)setIsTopStatus:(NSString *)isTopStatus{
    _isTopStatus = isTopStatus;
    if ([isTopStatus isEqualToString:@"no"]) {
        [self.topBtn setTitle:@"取消置顶" forState:UIControlStateNormal];
    }else{
        [self.topBtn setTitle:@"设为置顶" forState:UIControlStateNormal];
    }
}

-(void)createUI{
    
    UIImageView *headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    headImageV.image = [UIImage imageNamed:@"information_header"];
    headImageV.layer.cornerRadius = 20.f;
    headImageV.layer.masksToBounds = YES;
    //优化
    headImageV.layer.shouldRasterize = YES;
    headImageV.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:headImageV];
    
    UILabel *authorLabel = [[UILabel alloc]init];
    authorLabel.font = [UIFont systemFontOfSize:16.0];
    authorLabel.textColor = [UIColor customTitleColor];
    [self addSubview:authorLabel];
    
    UIButton *topBtn = [[UIButton alloc]init];
    topBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [topBtn setTitleColor:[UIColor customNavBarColor] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    topBtn.tag = TopBtnTypeTop;
    [self addSubview:topBtn];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:18.0];
    detailLabel.textColor = [UIColor customTitleColor];
    detailLabel.preferredMaxLayoutWidth = self.width-16;
    [self addSubview:detailLabel];
    
    UILabel *groupLabel = [[UILabel alloc]init];
    groupLabel.text = @"来自圈子：";
    groupLabel.textColor = [UIColor customDetailColor];
    groupLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:groupLabel];
    
    UILabel *groupNameLabel = [[UILabel alloc]init];
    groupNameLabel.font = [UIFont systemFontOfSize:16.0];
    groupNameLabel.textColor = [UIColor customNavBarColor];
    [self addSubview:groupNameLabel];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = [UIFont systemFontOfSize:16.0];
    timeLabel.textColor = [UIColor customDetailColor];
    [self addSubview:timeLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor customLineColor];
    [self addSubview:lineView];
    
    UIButton *likeBtn = [[UIButton alloc]init];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"YX_Zan"] forState:UIControlStateNormal];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"YX_Zan_Select"] forState:UIControlStateSelected];
    [likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    likeBtn.tag = TopBtnTypeLike;
    [self addSubview:likeBtn];
    
    UILabel *noteLabel = [[UILabel alloc]init];
    noteLabel.font = [UIFont systemFontOfSize:16.0];
    noteLabel.textColor = [UIColor customDetailColor];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:noteLabel];
    
    UILabel *answerNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 44)];
    answerNumLabel.textColor = [UIColor customTitleColor];
    answerNumLabel.backgroundColor = [UIColor customBackgroundColor];
    answerNumLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:answerNumLabel];

    authorLabel.backgroundColor = [UIColor customBackgroundColor];
    detailLabel.backgroundColor = [UIColor customBackgroundColor];
    groupNameLabel.backgroundColor = [UIColor customBackgroundColor];
    timeLabel.backgroundColor = [UIColor customBackgroundColor];
    noteLabel.backgroundColor = [UIColor customBackgroundColor];
    
    _headImageV = headImageV;
    _authorLabel = authorLabel;
    _topBtn = topBtn;
    _detailLabel = detailLabel;
    _groupLabel = groupLabel;
    _groupNameLabel = groupNameLabel;
    _timeLabel = timeLabel;
    _lineView = lineView;
    _likeBtn = likeBtn;
    _noteLabel = noteLabel;
    _answerNumLabel = answerNumLabel;
}
//点赞按钮
-(void)likeBtnClick:(UIButton *)sender{
    if (sender.tag == TopBtnTypeLike) {
        if (sender.selected == YES) {
//            return;
        }
    }
    if (self.likeBtnClickBlock != nil) {
        self.likeBtnClickBlock(sender.tag);
    }
}

-(void)addUILayout{
    WeakSelf
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.mas_top).offset(10);
        make.left.mas_equalTo(strongSelf.mas_left).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.headImageV.mas_top).offset(5);
        make.left.mas_equalTo(strongSelf.headImageV.mas_right).offset(10);
        make.height.mas_equalTo(30);
    }];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.headImageV.mas_top);
        make.left.mas_equalTo(strongSelf.authorLabel.mas_right).offset(10);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.headImageV.mas_bottom).offset(10);
        make.left.mas_equalTo(strongSelf.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
    }];
    [self.groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.detailLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(strongSelf.mas_left).offset(10);
//        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    [self.groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.groupLabel.mas_top);
        make.left.mas_equalTo(strongSelf.groupLabel.mas_right);
        make.height.mas_equalTo(30);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.groupLabel.mas_top);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(strongSelf.groupNameLabel.mas_right).offset(10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.groupLabel.mas_bottom).offset(16);
        make.left.right.equalTo(strongSelf);
        make.height.mas_equalTo(2);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.lineView.mas_bottom).offset(20);
        make.centerX.equalTo(strongSelf);
        make.height.width.mas_equalTo(50);
    }];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.likeBtn.mas_bottom).offset(5);
        make.left.mas_equalTo(strongSelf.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    [self.answerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.noteLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(strongSelf.mas_left).offset(0);
        make.right.mas_equalTo(strongSelf.mas_right).offset(0);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(strongSelf.mas_bottom).offset(0).priority(500);
    }];
    /** 此处可以自适应宽度，title不可以被压缩，所以最小也得全部显示 */
    [self.groupLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];//不可以被压缩，尽量显示完整
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];//不可以被压缩，尽量显示完整
    [self.groupNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];//宽度不够时，可以被压缩
    [self.timeLabel setContentHuggingPriority:UILayoutPriorityRequired/*抱紧*/
                                      forAxis:UILayoutConstraintAxisHorizontal];
    [self.groupLabel setContentHuggingPriority:UILayoutPriorityRequired/*抱紧*/
                                      forAxis:UILayoutConstraintAxisHorizontal];
}
@end
