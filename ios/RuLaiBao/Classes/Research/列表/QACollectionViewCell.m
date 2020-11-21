//
//  QACollectionViewCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "QACollectionViewCell.h"
#import "Configure.h"
#import "ResearchHotListModel.h"
#import "QLColorLabel.h"

@interface QACollectionViewCell ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *detailLabel;

@property (nonatomic, weak) UILabel *authorLabel;

@property (nonatomic, weak) UILabel *msgNumLabel;
@end

@implementation QACollectionViewCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createUI];
        [self addUILayout];
    }
    return self;
}

-(void)setCellInfoModel:(ResearchHotListModel *)cellInfoModel{
    _cellInfoModel = cellInfoModel;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.title];
    self.detailLabel.attributedText = cellInfoModel.mutablAttrStr;
    self.authorLabel.text = [NSString stringWithFormat:@"提问者：<%@>",cellInfoModel.userName];
    self.msgNumLabel.text = [NSString stringWithFormat:@"<%@> 条留言",cellInfoModel.answerCount];
}

#pragma mark - 创建UI
-(void)createUI{
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textColor = [UIColor customNavBarColor];
    [self.contentView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.textColor = [UIColor customTitleColor];
    detailLabel.numberOfLines = 3;
    detailLabel.font = [UIFont systemFontOfSize:16.0];
    [detailLabel sizeToFit];
    [self.contentView addSubview:detailLabel];
    
    QLColorLabel *authorLabel = [[QLColorLabel alloc]init];
    authorLabel.textColor = [UIColor customDetailColor];
    [authorLabel setAnotherColor: [UIColor customNavBarColor]];
    authorLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:authorLabel];
    
    QLColorLabel *msgNumLabel = [[QLColorLabel alloc]init];
    msgNumLabel.textColor = [UIColor customDetailColor];
    [msgNumLabel setAnotherColor: [UIColor customNavBarColor]];
    msgNumLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:msgNumLabel];
    
    _titleLabel = titleLabel;
    _detailLabel = detailLabel;
    _authorLabel = authorLabel;
    _msgNumLabel = msgNumLabel;
}
- (void)addUILayout {
    /*!
     若修改此处布局，请修改model中的size
     */
    WeakSelf
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(strongSelf.contentView.mas_top).offset(10);
        make.left.equalTo(strongSelf.contentView.mas_left).offset(10);
        make.right.equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@35);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(strongSelf.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(strongSelf.contentView.mas_left).offset(10);
        make.right.equalTo(strongSelf.contentView.mas_right).offset(-10);
//        make.height.equalTo(@70);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(strongSelf.detailLabel.mas_bottom).offset(5);
        make.left.equalTo(strongSelf.contentView.mas_left).offset(10);
        make.height.mas_equalTo(@35);
    }];
    [self.msgNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(strongSelf.detailLabel.mas_bottom).offset(5);
        make.left.equalTo(strongSelf.authorLabel.mas_right).offset(10);
        make.right.equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@35);
    }];
    /** 此处可以自适应宽度，title不可以被压缩，所以最小也得全部显示 */
    [self.msgNumLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];//不可以被压缩，尽量显示完整
    [self.authorLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];//宽度不够时，可以被压缩
    [self.msgNumLabel setContentHuggingPriority:UILayoutPriorityRequired/*抱紧*/
                                        forAxis:UILayoutConstraintAxisHorizontal];
}
@end
