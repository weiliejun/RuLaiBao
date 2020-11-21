//
//  GroupDetailTopView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/12.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "GroupDetailTopView.h"
#import "Configure.h"
#import "UIImage+extend.h"

#import "GroupListModel.h"

@interface GroupDetailTopView ()
@property (nonatomic, weak) UIImageView *bgImageV;
@property (nonatomic, weak) UIImageView *headImageV;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *peopleImageV;
@property (nonatomic, weak) UILabel *peopleNumLabel;
@property (nonatomic, weak) UIImageView *topicImageV;
@property (nonatomic, weak) UILabel *topicLabel;
@property (nonatomic, weak) UIButton *setBtn;
@property (nonatomic, weak) UILabel *detailLabel;

@property (nonatomic, assign) TopSetBtnType btnType;
@end

@implementation GroupDetailTopView

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
-(void)setDetailTopModel:(GroupListModel *)detailTopModel{
    _detailTopModel = detailTopModel;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",detailTopModel.circleName];
    self.peopleNumLabel.text =[[NSString stringWithFormat:@"%@",detailTopModel.memberCount]isEqualToString:@"(null)"] ? @"0" : [NSString stringWithFormat:@"%@",detailTopModel.memberCount];
    self.topicLabel.text =[[NSString stringWithFormat:@"%@",detailTopModel.topicCount] isEqualToString:@"(null)"] ? @"0" : [NSString stringWithFormat:@"%@",detailTopModel.topicCount];
    self.detailLabel.text = [NSString stringWithFormat:@"%@",detailTopModel.circleDesc];
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload;
    [self.headImageV sd_setImageWithURL:[NSURL URLWithString:detailTopModel.circlePhoto] placeholderImage:[UIImage imageNamed:@"YX_QZ_G"] options:options];
    
    if ([detailTopModel.isManager isEqualToString:@"yes"]) {
        //是圈子管理者
        [self.setBtn setTitle:@"设置权限" forState:UIControlStateNormal];
        self.btnType = TopSetBtnTypeSet;
    }else{
        if ([detailTopModel.isJoin isEqualToString:@"yes"]) {
            //已经加入该圈子
            [self.setBtn setTitle:@"退出圈子" forState:UIControlStateNormal];
            self.btnType = TopSetBtnTypeOut;
        }else{
            [self.setBtn setTitle:@"+ 加入" forState:UIControlStateNormal];
            self.btnType = TopSetBtnTypeJoin;
        }
    }
    [self.setBtn setBackgroundImage:[UIImage pureColorImageWithSize:self.setBtn.frame.size color:[UIColor whiteColor] cornRadius:15] forState:UIControlStateNormal];
}
-(void)ClickSetBtn:(UIButton *)sender{
    if (self.topSetBtnClickBlock != nil) {
        self.topSetBtnClickBlock(self.btnType);
    }
}

-(void)createUI{
    UIImageView *bgImageV = [[UIImageView alloc]init];
    bgImageV.image = [UIImage imageNamed:@"YX_QZ_BG"];
    [self addSubview:bgImageV];
    
    UIImageView *headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    headImageV.image = [UIImage imageNamed:@"YX_QZ_G"];
    headImageV.layer.cornerRadius = 30.f;
    headImageV.layer.masksToBounds = YES;
    //优化
    headImageV.layer.shouldRasterize = YES;
    headImageV.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:headImageV];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = [UIFont systemFontOfSize:18.0];
    nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:nameLabel];
    
    UIImageView *peopleImageV = [[UIImageView alloc]init];
    peopleImageV.image = [UIImage imageNamed:@"YX_QZ_Zu"];
    [self addSubview:peopleImageV];
    UILabel *peopleNumLabel = [[UILabel alloc]init];
    peopleNumLabel.font = [UIFont systemFontOfSize:18.0];
    peopleNumLabel.textColor = [UIColor whiteColor];
    [self addSubview:peopleNumLabel];
    
    UIImageView *topicImageV = [[UIImageView alloc]init];
    topicImageV.image = [UIImage imageNamed:@"YX_QZ_HuaTi"];
    [self addSubview:topicImageV];
    UILabel *topicLabel = [[UILabel alloc]init];
    topicLabel.font = [UIFont systemFontOfSize:18.0];
    topicLabel.textColor = [UIColor whiteColor];
    [self addSubview:topicLabel];
    
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    setBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [setBtn setTitleColor:[UIColor customBlueColor] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(ClickSetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:setBtn];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:16.0];
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.preferredMaxLayoutWidth = Width_Window-110;
    [self addSubview:detailLabel];
    
    _bgImageV = bgImageV;
    _headImageV = headImageV;
    _nameLabel = nameLabel;
    _peopleImageV = peopleImageV;
    _peopleNumLabel = peopleNumLabel;
    _topicImageV = topicImageV;
    _topicLabel = topicLabel;
    _setBtn = setBtn;
    _detailLabel = detailLabel;
}

-(void)addUILayout{
    WeakSelf
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.left.right.bottom.equalTo(strongSelf);
    }];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.mas_top).offset(Height_Statusbar+44+10);
        make.left.mas_equalTo(strongSelf.mas_left).offset(30);
        make.width.height.mas_equalTo(60);
    }];
    [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.centerY.mas_equalTo(strongSelf.headImageV.mas_centerY);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.headImageV.mas_top).offset(0);
        make.left.mas_equalTo(strongSelf.headImageV.mas_right).offset(10);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(strongSelf.setBtn.mas_left).offset(-10);
    }];
    [self.peopleImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.nameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(strongSelf.headImageV.mas_right).offset(10);
        make.width.height.mas_equalTo(20);
    }];
    [self.peopleNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.nameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(strongSelf.peopleImageV.mas_right).offset(5);
        make.height.mas_equalTo(20);
    }];
    [self.topicImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.nameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(strongSelf.peopleNumLabel.mas_right).offset(10);
        make.width.height.mas_equalTo(20);
    }];
    [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.nameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(strongSelf.topicImageV.mas_right).offset(5);
        make.height.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(strongSelf.setBtn.mas_left).offset(-10);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.mas_equalTo(strongSelf.headImageV.mas_right).offset(10);
        make.top.mas_equalTo(strongSelf.headImageV.mas_bottom).offset(15);
        make.right.mas_equalTo(strongSelf.mas_right).offset(-10);
        make.bottom.mas_equalTo(strongSelf.mas_bottom).offset(-20).priority(500);
    }];
}

@end
