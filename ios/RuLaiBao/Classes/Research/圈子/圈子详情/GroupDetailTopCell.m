//
//  GroupDetailTopCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/12.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "GroupDetailTopCell.h"
#import "Configure.h"

@interface GroupDetailTopCell ()
@property (nonatomic, weak) UIImageView *topImageV;
@property (nonatomic, weak) UILabel *msgLabel;
@property (nonatomic, weak) UIView *lineView;
@end

@implementation GroupDetailTopCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCellUI];
        [self createUILayout];
    }
    return self;
}

-(void)setTitleStr:(NSString *)titleStr{
    self.msgLabel.text = titleStr;
}
#pragma mark - UI
-(void)createCellUI{
    UIImageView *topImageV = [[UIImageView alloc]init];
    topImageV.image = [UIImage imageNamed:@"YX_top"];
    [self.contentView addSubview:topImageV];
    
    UILabel *msgLabel = [[UILabel alloc]init];
    msgLabel.font = [UIFont systemFontOfSize:18.0];
    msgLabel.textColor = [UIColor customNavBarColor];
    [self.contentView addSubview:msgLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor customLineColor];
    [self.contentView addSubview:lineView];
    
    _topImageV = topImageV;
    _msgLabel = msgLabel;
    _lineView = lineView;
}
-(void)createUILayout{
    WeakSelf
    [self.topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.contentView.mas_top).offset(16);
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.contentView.mas_top).offset(10);
        make.left.mas_equalTo(strongSelf.topImageV.mas_right).offset(10);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(strongSelf.lineView.mas_top).offset(-10).priority(500);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(strongSelf.contentView.mas_bottom).offset(0);
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
