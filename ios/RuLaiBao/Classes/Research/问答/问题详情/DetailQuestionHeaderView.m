//
//  DetailQuestionHeaderView.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "DetailQuestionHeaderView.h"
#import "Configure.h"
#import "QAListModel.h"

@interface DetailQuestionHeaderView ()

@property (nonatomic, weak) UIButton *sortBtn;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *answerNumLabel;

@end

@implementation DetailQuestionHeaderView
- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor customBackgroundColor];
        [self createHeaderUI];
    }
    return self;
}
-(void)setCommentCount:(NSString *)commentCount{
    self.answerNumLabel.text = [NSString stringWithFormat:@"%@回答",commentCount];
}

-(void)setBtnTitleStr:(NSString *)btnTitleStr{
    [self.sortBtn setTitle:btnTitleStr forState:UIControlStateNormal];
}
-(void)createHeaderUI{
    UILabel *answerNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 44)];
    answerNumLabel.textColor = [UIColor customTitleColor];
    answerNumLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:answerNumLabel];
    
    UIButton *sortBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window-100, 10, 80, 24)];
    [sortBtn setTitle:@"默认排序" forState:UIControlStateNormal];
    sortBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [sortBtn setTitleColor:[UIColor customTitleColor] forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(sortBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sortBtn];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(sortBtn.right, 15, 14, 14)];
    imageView.image = [UIImage imageNamed:@"icon_down"];
    [self.contentView addSubview:imageView];
    
    _imageView = imageView;
    _sortBtn = sortBtn;
    _answerNumLabel = answerNumLabel;
}
-(void)sortBtnClick{
    if (self.sortBtnClickBlock != nil) {
        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.transform = CGAffineTransformMakeRotation (M_PI);
        } completion:nil];
        
        self.sortBtnClickBlock(self);
    }
}
@end
