//
//  CourseTableViewCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "CourseTableViewCell.h"
#import "Configure.h"

#import "CourseListModel.h"

@interface CourseTableViewCell ()

@property (nonatomic, weak) UIImageView *bgImageV;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *typeLabel;

@property (nonatomic, weak) UIImageView *grayView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *jobLabel;
@property (nonatomic, weak) UILabel *courseLabel;
@end

@implementation CourseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCellUI];
        [self addUILayout];
    }
    return self;
}
-(void)setCellInfoModel:(CourseListModel *)cellInfoModel{
    _cellInfoModel = cellInfoModel;
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.courseTime];
    _typeLabel.text = cellInfoModel.typeName.length == 0 ? @"全部课程":[NSString stringWithFormat:@"%@",cellInfoModel.typeName];
    _nameLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.speechmakeName];
    _jobLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.position];
    _courseLabel.text = [NSString stringWithFormat:@"【%@】",cellInfoModel.courseName];
    
    NSArray *locationArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"];
    //传过来的是数字，从本地图片库中取
    NSString *imageNum = [NSString stringWithFormat:@"%@",cellInfoModel.courseLogo];
    if (![locationArr containsObject:imageNum]) {
        //默认
        imageNum = @"4";
    }
    _bgImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"YX_Default_%@",imageNum]];
}

#pragma mark - createUI
-(void)createCellUI{
    UILabel *typeLabel = [[UILabel alloc]init];
    typeLabel.textColor = [UIColor customTitleColor];
    typeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:typeLabel];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor customDetailColor];
    [self.contentView addSubview:timeLabel];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:imageV];
    
    //遮罩层
    UIImageView *grayView = [[UIImageView alloc]init];
    grayView.image = [UIImage imageNamed:@"YX_Gradient"];
    [imageV addSubview:grayView];
    
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    nameLabel.textColor = [UIColor whiteColor];
    [grayView addSubview:nameLabel];
    
    UILabel *jobLabel = [[UILabel alloc]init];
    jobLabel.textColor = [UIColor whiteColor];
    jobLabel.font = [UIFont systemFontOfSize:14.0];
    [grayView addSubview:jobLabel];
    
    UILabel *courseLabel = [[UILabel alloc]init];
    courseLabel.font = [UIFont systemFontOfSize:20.0];
    courseLabel.textColor = [UIColor whiteColor];
    [grayView addSubview:courseLabel];
    
    _bgImageV = imageV;
    _timeLabel = timeLabel;
    _typeLabel = typeLabel;
    
    _grayView = grayView;
    _nameLabel = nameLabel;
    _jobLabel = jobLabel;
    _courseLabel = courseLabel;
}

-(void)addUILayout{
    WeakSelf
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.contentView.mas_top).offset(10);
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
//        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(@30);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.mas_equalTo(strongSelf.contentView.mas_top).offset(10);
        make.left.greaterThanOrEqualTo(strongSelf.typeLabel.mas_right).offset(-20);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@30);
    }];
    
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
        make.top.mas_equalTo(strongSelf.typeLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
        make.bottom.mas_equalTo(strongSelf.contentView.mas_bottom).offset(-10);
    }];
    
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.right.bottom.equalTo(strongSelf.bgImageV);
        make.height.mas_equalTo(80);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(strongSelf.grayView.mas_left).offset(10);
        make.bottom.equalTo(strongSelf.grayView.mas_bottom).offset(-10);
        make.width.mas_lessThanOrEqualTo(@160);
        make.height.mas_equalTo(@20);
    }];
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(strongSelf.nameLabel.mas_right).offset(10);
        make.bottom.equalTo(strongSelf.grayView.mas_bottom).offset(-10);
        make.right.mas_lessThanOrEqualTo(strongSelf.grayView.mas_right).offset(-10);
        make.height.mas_equalTo(@20);
    }];
    [self.courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(strongSelf.grayView.mas_left).offset(0);
        make.bottom.equalTo(strongSelf.nameLabel.mas_top).offset(0);
        make.right.equalTo(strongSelf.grayView.mas_right).offset(-10);
        make.height.mas_equalTo(@30);
    }];
    /** 此处可以自适应宽度，title不可以被压缩，所以最小也得全部显示 */
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];//不可以被压缩，尽量显示完整
    [self.jobLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];//宽度不够时，可以被压缩
    [self.nameLabel setContentHuggingPriority:UILayoutPriorityRequired/*抱紧*/
                                      forAxis:UILayoutConstraintAxisHorizontal];
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
