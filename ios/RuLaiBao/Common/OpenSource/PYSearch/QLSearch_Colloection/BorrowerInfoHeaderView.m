//
//  BorrowerInfoHeaderView.m
//  WeiJinKe
//
//  Created by qiu on 2018/1/26.
//  Copyright © 2018年 yuanyuan. All rights reserved.
//

#import "BorrowerInfoHeaderView.h"
#import "PYSearchConst.h"

@interface BorrowerInfoHeaderView()

@property (nonatomic, weak) UIButton *emptyButton;

@end

@implementation BorrowerInfoHeaderView
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

#pragma mark - 设置界面元素
- (void)setupUI {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.frame.size.width-40, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:16];
    [self addSubview:label];
    _headerLabel = label;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width, 1)];
    line.backgroundColor =  [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    [self addSubview:line];
}

-(void)setIsShowClearBtn:(BOOL)isShowClearBtn{
    _isShowClearBtn = isShowClearBtn;
    if (isShowClearBtn) {
        [self emptyButton];
    }else{
        self.emptyButton.hidden = YES;
        self.emptyButton = nil;
    }
}
- (UIButton *)emptyButton
{
    if (!_emptyButton) {
//        UIButton *emptyButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-100, 0, 100, 30)];
        UIButton *emptyButton = [[UIButton alloc]init];
        emptyButton.titleLabel.font = self.headerLabel.font;
        [emptyButton setTitleColor:self.headerLabel.textColor forState:UIControlStateNormal];
        [emptyButton setTitle:[NSBundle py_localizedStringForKey:PYSearchEmptyButtonText] forState:UIControlStateNormal];
        [emptyButton setImage:[NSBundle py_imageNamed:@"empty"] forState:UIControlStateNormal];
        [emptyButton addTarget:self action:@selector(emptySearchHistoryDidClick) forControlEvents:UIControlEventTouchUpInside];
        [emptyButton sizeToFit];
        emptyButton.py_width += PYSEARCH_MARGIN;
        emptyButton.py_height += PYSEARCH_MARGIN;
        emptyButton.py_centerY = 15;
        emptyButton.py_x = self.py_width - emptyButton.py_width;
        emptyButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:emptyButton];
        _emptyButton = emptyButton;
    }
    return _emptyButton;
}
-(void)emptySearchHistoryDidClick{
    if (self.headerViewClearBlock) {
        self.headerViewClearBlock();
    }
}
@end
