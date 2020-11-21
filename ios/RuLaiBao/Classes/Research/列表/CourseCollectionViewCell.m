//
//  CourseCollectionViewCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "CourseCollectionViewCell.h"
#import "Configure.h"
#import "CourseListModel.h"

@interface CourseCollectionViewCell()

@property (nonatomic, weak) UIImageView *imageView;

//标签
@property (nonatomic, weak) UILabel *tagLabel;
//标题
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation CourseCollectionViewCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        [self addUILayout];
    }
    return self;
}

-(void)setCellInfoModel:(CourseListModel *)cellInfoModel{
    _cellInfoModel = cellInfoModel;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",cellInfoModel.courseName];
    
    NSArray *locationArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"];
    //传过来的是数字，从本地图片库中取
    NSString *imageNum = [NSString stringWithFormat:@"%@",cellInfoModel.courseLogo];
    if (![locationArr containsObject:imageNum]) {
        //默认
        imageNum = @"4";
    }
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"YX_Default_%@",imageNum]];
}
#pragma mark - 创建UI
-(void)createUI{
    
    UIImageView *imageV = [[UIImageView alloc]init];
    [self.contentView addSubview:imageV];
    
//    UILabel *tagLabel = [[UILabel alloc]init];
//    tagLabel.textColor = [UIColor darkGrayColor];
//    tagLabel.textAlignment = NSTextAlignmentCenter;
//    // 重点在此！！设置视图的图层背景色，千万不要直接设置 label.backgroundColor
//    tagLabel.layer.backgroundColor = [UIColor redColor].CGColor;
//    [imageV addSubview:tagLabel];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor customTitleColor];
    titleLabel.font = [UIFont systemFontOfSize:KFontTitleSize];
    [self.contentView addSubview:titleLabel];
    
    _imageView = imageV;
//    _tagLabel = tagLabel;
    _titleLabel = titleLabel;
}
#pragma mark - 调整宽度
-(void)setIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2 == 0) {
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
        }];
    }else{
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(5);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
    }
}
- (void)addUILayout {
    
    WeakSelf
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(strongSelf.contentView.mas_top).offset(10);
        make.left.mas_equalTo(strongSelf.contentView.mas_left).offset(10);
        make.right.mas_equalTo(strongSelf.contentView.mas_right).offset(-10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.top.equalTo(strongSelf.imageView.mas_bottom).offset(5);
        make.left.right.equalTo(strongSelf.imageView);
        make.height.mas_equalTo(@30);
        make.bottom.equalTo(strongSelf.contentView.mas_bottom).offset(-5);
    }];
    
    
//    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        StrongSelf
//        make.top.left.equalTo(strongSelf.imageView).offset(10);
//        make.height.mas_equalTo(@20);
//        make.width.mas_equalTo(@40);
//
//    }];
    
}
//-(void)layoutSublayersOfLayer:(CALayer *)layer{
//    [super layoutSublayersOfLayer:layer];
//    //auto后不会立即改变frame，所以要在重写此方法
//    self.tagLabel.layer.cornerRadius = 2.0f;
//}

@end
