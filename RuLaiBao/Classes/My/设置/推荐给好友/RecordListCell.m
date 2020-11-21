//
//  RecordListCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/20.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "RecordListCell.h"
#import "Configure.h"
#import "RecordListModel.h"

@interface RecordListCell ()
@property (nonatomic, weak) UILabel *nameLabel;//姓名
@property (nonatomic, weak) UILabel *phoneLabel;//手机号
@property (nonatomic, weak) UILabel *statusLabel;//认证状态

@end

@implementation RecordListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

#pragma mark - 创建Cell
- (void)createCell{
    //姓名
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"王某某";
    nameLabel.textColor = [UIColor customDetailColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.greaterThanOrEqualTo(@(Width_Window/3-20));
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    //手机号
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = [NSString changePhoneNum:@"13511115678"];
    phoneLabel.textColor = [UIColor customDetailColor];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Width_Window/3+10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.greaterThanOrEqualTo(@(Width_Window/3-20));
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    //认证状态
    UILabel *statusLabel = [[UILabel alloc]init];
    statusLabel.text = @"已认证";
    statusLabel.textColor = [UIColor customDetailColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:statusLabel];
    self.statusLabel = statusLabel;
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Width_Window*2/3+10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.greaterThanOrEqualTo(@(Width_Window/3-20));
        make.height.greaterThanOrEqualTo(@20);
    }];
}

- (void)setRecoreListLabelValue:(RecordListModel *)model{
    //姓名
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.realName];
    //电话
    self.phoneLabel.text = [NSString changePhoneNum:model.mobile];
    //认证状态
    if ([model.checkStatus isEqualToString:@"init"]) {
        //    init未认证（未填写认证信息）
        self.statusLabel.text = @"未认证";
    }else if ([model.checkStatus isEqualToString:@"success"]){
        //    success - 认证成功
        self.statusLabel.text = @"认证成功";
    }else if ([model.checkStatus isEqualToString:@"submit"]){
        //    submit待认证(提交认证信息待审核)
        self.statusLabel.text = @"待认证";
    }else{//    fail - 认证失败
        self.statusLabel.text = @"认证失败";
    }
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
