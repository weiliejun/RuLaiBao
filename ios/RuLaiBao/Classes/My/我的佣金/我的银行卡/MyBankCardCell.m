//
//  MyBankCardCell.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/14.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyBankCardCell.h"
#import "Configure.h"
#import "MyBankCardModel.h"
#import "NSString+Custom.h"


@interface MyBankCardCell ()
//圆角View
@property (nonatomic, weak) UIView *cornerView;
//图标
@property (nonatomic, weak) UIImageView *bankImageView;
//银行名称
@property (nonatomic, weak) UILabel *bankName;
//卡号
@property (nonatomic, weak) UILabel *bankCardLabel;
//设为工资卡
@property (nonatomic, weak) UIButton *remarkBtn;

@end

@implementation MyBankCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

#pragma mark - 创建cell
- (void)createCell {
    //背景View
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo(Width_Window-30);
        make.height.mas_equalTo(150);
    }];
    
    //圆角View
    UIView *cornerView = [[UIView alloc]init];
    cornerView.backgroundColor = [UIColor whiteColor];
    cornerView.layer.masksToBounds = YES;
    cornerView.layer.cornerRadius = 5;
    [self.contentView addSubview:cornerView];
    self.cornerView = cornerView;
    [cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo(Width_Window-20);
        make.height.mas_equalTo(110);
    }];
    
    cornerView.clipsToBounds = NO;
    //加阴影
    cornerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:105/255.0 blue:179/255.0 alpha:1.0].CGColor;
    cornerView.layer.shadowOffset = CGSizeMake(0,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    cornerView.layer.shadowOpacity = 0.6;//阴影透明度，默认0
    cornerView.layer.shadowRadius = 4;//阴影半径，默认3
    
    //图标
    UIImageView *bankImageView = [[UIImageView alloc]init];
    bankImageView.image = [UIImage imageNamed:@"Bank_Default"];
    [cornerView addSubview:bankImageView];
    self.bankImageView = bankImageView;
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cornerView.mas_left).offset(20);
        make.top.equalTo(cornerView.mas_top).offset(20);
        make.width.height.mas_equalTo(30);
    }];
    
    //银行名称
    UILabel *bankName = [[UILabel alloc]init];
    bankName.text = @"---";
    bankName.textColor = [UIColor customTitleColor];
    bankName.font = [UIFont systemFontOfSize:16];
    bankName.textAlignment = NSTextAlignmentLeft;
    [cornerView addSubview:bankName];
    self.bankName = bankName;
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankImageView.mas_right).offset(5);
        make.top.equalTo(cornerView.mas_top).offset(25);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
    }];
    
    //卡号
    UILabel *bankCardLabel = [[UILabel alloc]init];
    bankCardLabel.text = [NSString changeIDBankCard:@"6227000000000000001"];
    bankCardLabel.textColor = [UIColor customTitleColor];
    bankCardLabel.font = [UIFont systemFontOfSize:18];
    bankCardLabel.textAlignment = NSTextAlignmentLeft;
    [cornerView addSubview:bankCardLabel];
    self.bankCardLabel = bankCardLabel;
    [bankCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cornerView.mas_left).offset(20);
        make.top.equalTo(bankImageView.mas_bottom).offset(20);
        make.width.mas_equalTo(Width_Window-60);
        make.height.mas_equalTo(20);
    }];
    
    //删除按钮
    UIButton *deleteBtn = [[UIButton alloc]init];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor customTitleColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [deleteBtn setImage:[UIImage imageNamed:@"bank_delete"] forState:UIControlStateNormal];
    
    deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 32);
    //deleteBtn标题的偏移量，这个偏移量是相对于图片的
    deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    [deleteBtn addTarget:self action:@selector(deleteCard:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(0);
        make.top.equalTo(cornerView.mas_bottom).offset(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    //是否设为工资卡
    UIButton *remarkBtn = [[UIButton alloc]init];
    [remarkBtn setTitle:@"设为工资卡" forState:UIControlStateNormal];
    [remarkBtn setTitleColor:[UIColor customTitleColor] forState:UIControlStateNormal];
    remarkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [remarkBtn setImage:[UIImage imageNamed:@"normal_Remark"] forState:UIControlStateNormal];
    remarkBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 55);
    //remarkBtn标题的偏移量，这个偏移量是相对于图片的
    remarkBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    remarkBtn.selected = NO;
    [remarkBtn addTarget:self action:@selector(remarkCard:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:remarkBtn];
    self.remarkBtn = remarkBtn;
    
    [remarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_right).offset(-110);
        make.top.equalTo(cornerView.mas_bottom).offset(5);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(30);
    }];
    
}

#pragma mark - 删除按钮点击事件
- (void)deleteCard:(UIButton *)btn {
    if (self.deleteBlock != nil) {
        self.deleteBlock();
    }
}

#pragma mark - 设为工资卡
- (void)remarkCard:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    if (self.salaryBlock != nil) {
        self.salaryBlock();
    }
}

#pragma mark - 设置数据
- (void)setMyBankCardModelWithDictionary:(MyBankCardModel *)model {
    //银行卡图标
    if ([model.bank isEqualToString:@"中国银行"]) {
        self.bankImageView.image = [UIImage imageNamed:@"zhongyin"];
        //设置cornerView阴影颜色
        self.cornerView.layer.shadowColor = [UIColor colorWithRed:181/255.0 green:0/255.0 blue:41/255.0 alpha:1.0].CGColor;
        
    }else if ([model.bank isEqualToString:@"农业银行"]) {
        self.bankImageView.image = [UIImage imageNamed:@"nongye"];
        //设置cornerView阴影颜色
        self.cornerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:145/255.0 blue:116/255.0 alpha:1.0].CGColor;
        
    }else if ([model.bank isEqualToString:@"工商银行"]) {
        self.bankImageView.image = [UIImage imageNamed:@"gongshang"];
        //设置cornerView阴影颜色
        self.cornerView.layer.shadowColor = [UIColor colorWithRed:229/255.0 green:0/255.0 blue:18/255.0 alpha:1.0].CGColor;
        
    }else if ([model.bank isEqualToString:@"建设银行"]) {
        self.bankImageView.image = [UIImage imageNamed:@"jianshe"];
        //设置cornerView阴影颜色
        self.cornerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:59/255.0 blue:143/255.0 alpha:1.0].CGColor;
        
    }else if ([model.bank isEqualToString:@"交通银行"]) {
        self.bankImageView.image = [UIImage imageNamed:@"jiaotong"];
        //设置cornerView阴影颜色
        self.cornerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:105/255.0 blue:179/255.0 alpha:1.0].CGColor;
        
    }else if ([model.bank isEqualToString:@"招商银行"]) {
        self.bankImageView.image = [UIImage imageNamed:@"zhaoshang"];
        //设置cornerView阴影颜色
        self.cornerView.layer.shadowColor = [UIColor colorWithRed:195/255.0 green:33/255.0 blue:38/255.0 alpha:1.0].CGColor;
        
    }else if ([model.bank isEqualToString:@"广发银行"]) {
        self.bankImageView.image = [UIImage imageNamed:@"guangfa"];
        //设置cornerView阴影颜色
        self.cornerView.layer.shadowColor = [UIColor colorWithRed:191/255.0 green:0/255.0 blue:22/255.0 alpha:1.0].CGColor;
        
    }else if ([model.bank isEqualToString:@"华夏银行"]) {
        self.bankImageView.image = [UIImage imageNamed:@"huaxia"];
        //设置cornerView阴影颜色
        self.cornerView.layer.shadowColor = [UIColor colorWithRed:228/255.0 green:33/255.0 blue:34/255.0 alpha:1.0].CGColor;
        
    }else if ([model.bank isEqualToString:@"浦发银行"]) {
        self.bankImageView.image = [UIImage imageNamed:@"pufa"];
        //设置cornerView阴影颜色
        self.cornerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:106/255.0 blue:176/255.0 alpha:1.0].CGColor;
        
    }else  {
        //默认图标
        self.bankImageView.image = [UIImage imageNamed:@"Bank_Default"];
        //设置cornerView阴影颜色
        self.cornerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:105/255.0 blue:179/255.0 alpha:1.0].CGColor;
        
    }
    
    //银行名称
    self.bankName.text = [NSString stringWithFormat:@"%@",model.bank];
    //卡号
    NSString *bankNum = [NSString stringWithFormat:@"%@",model.bankcardNo];
    self.bankCardLabel.text = [bankNum stringByReplacingCharactersInRange:NSMakeRange(0, bankNum.length-4) withString:@"****  ****  ****  "];
    
    //是否是工资卡
    if ([model.isWageCard isEqualToString:@"1"]) {
        [self.remarkBtn setTitleColor:[UIColor customBlueColor] forState:UIControlStateNormal];
        [self.remarkBtn setImage:[UIImage imageNamed:@"select_Remark"] forState:UIControlStateNormal];
        self.remarkBtn.userInteractionEnabled = NO;
    }else {
        [self.remarkBtn setTitleColor:[UIColor customTitleColor] forState:UIControlStateNormal];
        [self.remarkBtn setImage:[UIImage imageNamed:@"normal_Remark"] forState:UIControlStateNormal];
        self.remarkBtn.userInteractionEnabled = YES;
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
