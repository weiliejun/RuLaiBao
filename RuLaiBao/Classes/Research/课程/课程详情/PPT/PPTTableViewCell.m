//
//  PPTTableViewCell.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/9.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "PPTTableViewCell.h"
#import "Configure.h"

@interface PPTTableViewCell ()

@property (nonatomic, weak) UIImageView *pptImageV;

@end

@implementation PPTTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCellUI];
    }
    return self;
}
-(void)setImageUrlStr:(NSString *)imageUrlStr{
    _imageUrlStr = imageUrlStr;
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageProgressiveDownload;
    [self.pptImageV sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@""] options:options];
}

-(void)createCellUI{
    UIImageView *imageV = [[UIImageView alloc]init];
    [self.contentView addSubview:imageV];
    _pptImageV = imageV;
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
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
