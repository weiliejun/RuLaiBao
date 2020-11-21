//
//  MyTalkCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/18.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyTalkCell.h"
#import "Configure.h"
#import "MyTalkModel.h"

@interface MyTalkCell ()
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *praiseLabel;
@property (nonatomic, weak) UILabel *answerLabel;
//点赞
@property (nonatomic, weak) UIImageView *praiseImage;
//回复
@property (nonatomic, weak) UIImageView *answerImage;


@end

@implementation MyTalkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

#pragma mark - 设置Cell
- (void)createCell{
    //圈子名称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"圈子/小组名称";
    nameLabel.textColor = [UIColor customNavBarColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@20);
    }];
    
    //横线
    UILabel *horizontal = [[UILabel alloc]init];
    horizontal.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:horizontal];
    [horizontal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@(Width_Window));
        make.height.mas_equalTo(@1);
    }];
    
    //话题名称
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"中纪委发话谈落马：十九大后”首虎“";
    titleLabel.textColor = [UIColor customNavBarColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(horizontal.mas_bottom).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.height.mas_equalTo(@20);
    }];
    
    //点赞数量
    UILabel *praiseLabel = [[UILabel alloc]init];
    praiseLabel.textColor = [UIColor customDetailColor];
    praiseLabel.textAlignment = NSTextAlignmentLeft;
    praiseLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:praiseLabel];
    self.praiseLabel = praiseLabel;
    [praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@(20));
        make.height.mas_equalTo(@20);
    }];
    
    //点赞
    UIImageView *praiseImage = [[UIImageView alloc]init];
    praiseImage.image = [UIImage imageNamed:@"YX_Like_Select"];
    [self.contentView addSubview:praiseImage];
    self.praiseImage = praiseImage;
    [praiseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(praiseLabel.mas_right).offset(5);
        make.top.equalTo(titleLabel.mas_bottom).offset(11);
        make.width.mas_equalTo(@14);
        make.height.mas_equalTo(@14);
    }];
    
    //回复数量
    UILabel *answerLabel = [[UILabel alloc]init];
    answerLabel.textColor = [UIColor customDetailColor];
    answerLabel.textAlignment = NSTextAlignmentLeft;
    answerLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:answerLabel];
    self.answerLabel = answerLabel;
    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.praiseImage.mas_right).offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(@(20));
        make.height.mas_equalTo(@20);
    }];
    
    
    //回复
    UIImageView *answerImage = [[UIImageView alloc]init];
    answerImage.image = [UIImage imageNamed:@"news_gray"];
    [self.contentView addSubview:answerImage];
    self.answerImage = answerImage;
    [answerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(answerLabel.mas_right).offset(5);
        make.top.equalTo(titleLabel.mas_bottom).offset(12);
        make.width.mas_equalTo(@14);
        make.height.mas_equalTo(@14);
    }];
    
    //箭头
    UIImageView *rightArrow = [[UIImageView alloc]init];
    rightArrow.image = [UIImage imageNamed:@"arrow_r"];
    [self.contentView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_right).offset(-18);
        make.top.equalTo(self.contentView.mas_top).offset(70);
        make.width.mas_equalTo(@8);
        make.height.mas_equalTo(@14);
    }];
}

- (void)setMyTalkListModelWithDictionary:(MyTalkModel *)model{
    //话题所属圈子名称
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.circleName];
    //话题内容
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.topicContent];
    //点赞总数
    NSString *praiseStr = [NSString stringWithFormat:@"%@",model.likeCount];
    CGFloat praiseWidth = [NSString sizeWithFont:[UIFont systemFontOfSize:16] Size:CGSizeMake(MAXFLOAT, 20) Str:praiseStr].width;
    [self.praiseLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        //自适应宽度
        make.width.mas_equalTo(@(praiseWidth));
    }];
    self.praiseLabel.text = praiseStr;
    
    [self.praiseImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.praiseLabel.mas_right).offset(5);
    }];
    
    //评论总数 
    NSString *answerStr = [NSString stringWithFormat:@"%@",model.commentCount];
    CGFloat answerWidth = [NSString sizeWithFont:[UIFont systemFontOfSize:16] Size:CGSizeMake(MAXFLOAT, 20) Str:answerStr].width;
    [self.answerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        //自适应宽度
        make.width.mas_equalTo(@(answerWidth));
    }];
    self.answerLabel.text = answerStr;
    
    [self.answerImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.answerLabel.mas_right).offset(5);

    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
