//
//  DetailAnswerTopView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "DetailAnswerTopView.h"
#import "Configure.h"
#import "DetailQuestionModel.h"

@interface DetailAnswerTopView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIImageView *headImageV;
@property (nonatomic, weak) UILabel *authorLabel;
@property (nonatomic, weak) UILabel *detailLabel;
@property (nonatomic, weak) UIButton *likeBtn;
@property (nonatomic, weak) UILabel *noteLabel;

@property (nonatomic, weak) UILabel *answerNumLabel;

@property (nonatomic, assign) NSInteger likeCount;
@end

@implementation DetailAnswerTopView

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
-(void)setDetailTopModel:(DetailQuestionModel *)detailTopModel{
    _detailTopModel = detailTopModel;
    
    self.titleLabel.text = [[NSString stringWithFormat:@"%@",detailTopModel.title]isEqualToString:@"(null)"] ? @"" : [NSString stringWithFormat:@"%@",detailTopModel.title];
    self.authorLabel.text = [[NSString stringWithFormat:@"%@",detailTopModel.answerName]isEqualToString:@"(null)"] ? @"" : [NSString stringWithFormat:@"%@",detailTopModel.answerName];
    self.detailLabel.text = [[NSString stringWithFormat:@"%@",detailTopModel.answerContent]isEqualToString:@"(null)"] ? @"" : [NSString stringWithFormat:@"%@",detailTopModel.answerContent];
    
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload;
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:detailTopModel.answerPhoto] placeholderImage:[UIImage imageNamed:@"information_header"] options:options];
    
//    self.answerNumLabel.text = [NSString stringWithFormat:@"    %@评论",detailTopModel.commentCount == nil ? @"0": detailTopModel.commentCount];
    
    if ([[NSString stringWithFormat:@"%@",detailTopModel.likeStatus] isEqualToString:@"yes"]) {
        self.likeBtn.selected = YES;
        self.likeBtn.userInteractionEnabled = NO;
    }else{
        self.likeBtn.selected = NO;
        self.likeBtn.userInteractionEnabled = YES;
    }
}

-(void)setIsLikeSelect:(NSString *)isLikeSelect{
    _isLikeSelect = isLikeSelect;
    if ([isLikeSelect isEqualToString:@"yes"]) {
        //变化图标和数字
        self.likeBtn.selected = YES;
        self.likeBtn.userInteractionEnabled = NO;
    }else{
        self.likeBtn.selected = NO;
        self.likeBtn.userInteractionEnabled = YES;
    }
}

-(void)createUI{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textColor = [UIColor customNavBarColor];
    titleLabel.preferredMaxLayoutWidth = self.width-20;
    [self addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor customBackgroundColor];
    [self addSubview:lineView];
    
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
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:16.0];
    detailLabel.textColor = [UIColor customTitleColor];
    detailLabel.preferredMaxLayoutWidth = self.width-20;
    [self addSubview:detailLabel];
    
    UIButton *likeBtn = [[UIButton alloc]init];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"YX_Zan"] forState:UIControlStateNormal];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"YX_Zan_Select"] forState:UIControlStateSelected];
    [likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:likeBtn];
    
    UILabel *noteLabel = [[UILabel alloc]init];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.font = [UIFont systemFontOfSize:14.0];
    noteLabel.textColor = [UIColor customDetailColor];
    noteLabel.text = @"觉得写的好就给个赞吧";
    [self addSubview:noteLabel];
    
    UILabel *answerNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 44)];
    answerNumLabel.backgroundColor = [UIColor customBackgroundColor];
    answerNumLabel.textColor = [UIColor customTitleColor];
    answerNumLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:answerNumLabel];
    
    _titleLabel = titleLabel;
    _lineView = lineView;
    _headImageV = headImageV;
    _authorLabel = authorLabel;
    _detailLabel = detailLabel;
    _likeBtn = likeBtn;
    _noteLabel = noteLabel;
    _answerNumLabel = answerNumLabel;
}
//点赞按钮
-(void)likeBtnClick:(UIButton *)sender{
    if (sender.selected == YES) {
        return;
    }
    if (self.likeBtnClickBlock != nil) {
        self.likeBtnClickBlock();
    }
}

-(void)addUILayout{
    WeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.mas_top).offset(10);
        make.left.mas_equalTo(strongSelf.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(strongSelf.mas_left).offset(0);
        make.right.mas_equalTo(strongSelf.mas_right).offset(0);
        make.height.mas_equalTo(10);
    }];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.lineView.mas_bottom).offset(10);
        make.left.mas_equalTo(strongSelf.mas_left).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.lineView.mas_bottom).offset(15);
        make.left.mas_equalTo(strongSelf.headImageV.mas_right).offset(10);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.headImageV.mas_bottom).offset(10);
        make.left.mas_equalTo(strongSelf.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
    }];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.detailLabel.mas_bottom).offset(20);
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
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(strongSelf.mas_bottom).offset(0).priority(500);
    }];
}

@end
