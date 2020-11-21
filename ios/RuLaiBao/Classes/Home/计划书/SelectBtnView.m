//
//  SelectBtnView.m
//  SelectBtnView
//
//  Created by kingstartimes on 2018/3/8.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "SelectBtnView.h"
#import "Configure.h"
#import "GBTagListView.h"

@interface SelectBtnView ()<UIGestureRecognizerDelegate>
/** typeBtn: 保险公司按钮 */
@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) UIImageView *typeImage;

/** backView: 点击按钮时灰色半透明背景view */
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) NSInteger btnTag;

/** 保险公司的重置和确定按钮 */
@property (nonatomic, strong) UIButton *typeReduceBtn;
@property (nonatomic, strong) UIButton *typeCertainBtn;

/** 按钮选中的参数 */
@property (nonatomic, strong) NSMutableArray *typeArr;
//标题按钮
@property (nonatomic, strong) NSString *btnStr;

@property (nonatomic, assign) CGFloat selectViewHeight;

//按钮
@property (nonatomic, strong) GBTagListView *tagList;
//选中按钮数组
@property (nonatomic, strong) NSMutableArray *tagMuArr;
//选中按钮坐标数组
@property (nonatomic, strong) NSMutableArray *tagNumMuArr;
//临时数组
@property (nonatomic, strong) NSMutableArray *tempArr;

@end

@implementation SelectBtnView
- (instancetype)initWithBtnStr:(NSString *)btnStr{
    if (self = [super init]) {
        [self setFrame:CGRectMake(0, Height_Statusbar_NavBar+10, Width_Window, 44)];
        self.btnStr = btnStr;
        [self createUI];
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;

}

#pragma mark - 设置界面元素
- (void)createUI{
    //保险公司按钮和图片
    UIButton *typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window/2-60, 0, 120, 44)];
    typeBtn.backgroundColor = [UIColor customBackgroundColor];
    [typeBtn setTitle:self.btnStr forState:UIControlStateNormal];
    [typeBtn setTitleColor:[UIColor customTitleColor] forState:UIControlStateNormal];
    typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [typeBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    typeBtn.selected = YES;
    [self addSubview:typeBtn];
    self.typeBtn = typeBtn;
    
    UIImageView *typeImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 17, 15, 10)];
    typeImage.image = [UIImage imageNamed:@"home_plan_up"];
    [typeBtn addSubview:typeImage];
    self.typeImage = typeImage;
    //设置文字和图片位置
    [typeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, typeImage.bounds.size.width)];

    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, Width_Window, 1)];
    line.backgroundColor = [UIColor customLineColor];
    [self addSubview:line];
    
    self.typeArr = [NSMutableArray arrayWithObjects:@"", nil];
}

#pragma mark - 保险公司按钮点击事件
- (void)pressBtn:(UIButton *)btn{
    [self.backView removeFromSuperview];
    self.typeBtn.selected = !self.typeBtn.selected;
    if (self.typeBtn.selected) {
        self.typeImage.image = [UIImage imageNamed:@"home_plan_up"];
        [self.backView removeFromSuperview];
        //改变selectBtnView的大小
        self.frame = CGRectMake(0, Height_Statusbar_NavBar+10, Width_Window, 44);
        
    }else{
        self.typeImage.image = [UIImage imageNamed:@"home_plan_down"];
        //改变selectBtnView的大小
        self.frame = CGRectMake(0, Height_Statusbar_NavBar+10, Width_Window, Height_Window-44);
        
        [self createTypeView];
        [self addSubview:self.backView];
    }
}

/** 点击保险公司按钮创建新的view */
-(void)createTypeView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.typeBtn.bottom+1, Width_Window, Height_Window-44-self.typeBtn.bottom-1)];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.backView = backView;
    // 添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    tapGesture.delegate = self;
    [backView addGestureRecognizer:tapGesture];
    
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 210)];
    upView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:upView];
    
    UIScrollView *tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, upView.width, 140)];
    tagScrollView.backgroundColor = [UIColor clearColor];
    [upView addSubview:tagScrollView];
    
    GBTagListView *tagList=[[GBTagListView alloc]initWithFrame:CGRectMake(0, 10, Width_Window, 0)];
    /**允许点击 */
    tagList.canTouch = YES;
    tagList.signalTagColor=[UIColor whiteColor];
    tagList.titleNormalColor = [UIColor customNavBarColor];
    tagList.titleSelectColor = [UIColor customDeepYellowColor];
    [tagList setTagWithTagArray:self.titleArray];
    [tagList setTagWithSelectTagArr:self.tagNumMuArr];
    [tagList setDidselectItemBlock:^(NSArray *arr) {
       //选中的结果
        self.tempArr = [NSMutableArray arrayWithArray:arr];
//        self.tagNumMuArr = [NSMutableArray arrayWithArray:arr];
    }];
    
    [tagScrollView addSubview:tagList];
    _tagList = tagList;
    tagScrollView.contentSize = CGSizeMake(upView.width, tagList.bottom);
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, tagScrollView.bottom+10, Width_Window-20, 1)];
    line.backgroundColor = [UIColor customLineColor];
    [upView addSubview:line];
    
    UIButton *reduceBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, line.bottom + 10, 120, 40)];
    reduceBtn.backgroundColor = [UIColor whiteColor];
    [reduceBtn setTitle:@"重置" forState:UIControlStateNormal];
    [reduceBtn setTitleColor:[UIColor customLightYellowColor] forState:UIControlStateNormal];
    reduceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    reduceBtn.layer.masksToBounds = YES;
    reduceBtn.layer.cornerRadius = 20;
    reduceBtn.layer.borderWidth = 1;
    reduceBtn.layer.borderColor = [UIColor customDeepYellowColor].CGColor;
    reduceBtn.tag  = 10000;
    [reduceBtn addTarget:self action:@selector(pressTypeReduceBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.typeReduceBtn = reduceBtn;
    [upView addSubview:reduceBtn];
    
    UIButton *certainBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window-150, line.bottom + 10, 120, 40)];
    certainBtn.backgroundColor = [UIColor customLightYellowColor];
    [certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    certainBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    certainBtn.layer.masksToBounds = YES;
    certainBtn.layer.cornerRadius = 20;
    certainBtn.layer.borderWidth = 1;
    certainBtn.layer.borderColor = [UIColor customDeepYellowColor].CGColor;
    certainBtn.tag  = 20000;
    [certainBtn addTarget:self action:@selector(pressTypeReduceBtn:) forControlEvents:UIControlEventTouchUpInside];
    certainBtn.selected = YES;
    self.typeCertainBtn = certainBtn;
    [upView addSubview:certainBtn];
}

/** back的手势 */
- (void)tapGestureClick{
    
    [self backViewDisappear];
}
/** 灰色背景view取消事件 */
- (void)backViewDisappear{
    self.typeImage.image = [UIImage imageNamed:@"home_plan_up"];
    self.typeBtn.selected = YES;
    [self.backView removeFromSuperview];
    [self.tagMuArr removeAllObjects];
//    [self.tempArr removeAllObjects];
    self.frame = CGRectMake(0, Height_Statusbar_NavBar+10, Width_Window, 44);
}

/** 重置，确定按钮的点击事件 */
- (void)pressTypeReduceBtn:(UIButton *)btn{
    if (btn.tag == 10000) {//重置
        self.typeReduceBtn.selected = YES;
        self.typeCertainBtn.selected = NO;
        
        [self.tagList clearTheAllSelectItem];
        [self.tempArr removeAllObjects];
        [self.tagMuArr removeAllObjects];
        [self.tagNumMuArr removeAllObjects];
    }else {//确定
        self.typeReduceBtn.selected = NO;
        self.typeCertainBtn.selected = YES;
        self.tagNumMuArr = [NSMutableArray arrayWithArray:self.tempArr];
//        [self.tempArr removeAllObjects];
        for (int i=0 ; i < self.tagNumMuArr.count; i++) {
            [self.tagMuArr addObject:[self.titleArray objectAtIndex:[self.tagNumMuArr[i] integerValue]]];
        }
        
        if (self.tagMuArr.count == 0){
            [self.typeBtn setTitle:@"保险公司" forState:UIControlStateNormal];
            [self.typeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
        }else if (self.tagMuArr.count == 1) {
            [self.typeBtn setTitle:[NSString stringWithFormat:@"%@",self.tagMuArr[0]] forState:UIControlStateNormal];
            [self.typeBtn setTitleColor:[UIColor customDeepYellowColor] forState:UIControlStateNormal];
            
        }else{
            [self.typeBtn setTitle:@"多选" forState:UIControlStateNormal];
            [self.typeBtn setTitleColor:[UIColor customDeepYellowColor] forState:UIControlStateNormal];
        }
        [self changeArrToStr:self.tagMuArr];
        [self backViewDisappear];
    }
}

/** 将数组转化成字符串 */
- (void)changeArrToStr:(NSArray *)arr{
    //字符串
    NSMutableString *catagoryStr =[NSMutableString string];
    for (int i=0; i<arr.count; i++) {
        NSString *typeStr = arr[i];
        if (i == arr.count-1) {
            [catagoryStr appendFormat:@"'%@'", [NSString stringWithFormat:@"%@",typeStr]];
        }else{
            [catagoryStr appendFormat:@"'%@',", [NSString stringWithFormat:@"%@",typeStr]];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectViewBtnClick:)]) {
        [self.delegate selectViewBtnClick:catagoryStr];
    }
}

-(NSMutableArray *)tagMuArr{
    if (_tagMuArr == nil) {
        _tagMuArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _tagMuArr;
}

-(NSMutableArray *)tagNumMuArr{
    if (_tagNumMuArr == nil) {
        _tagNumMuArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _tagNumMuArr;
}

-(NSMutableArray *)tempArr{
    if (_tempArr == nil) {
        _tempArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _tempArr;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchPoint = [touch locationInView:self];
    return !CGRectContainsPoint(self.tagList.frame, touchPoint);
}

@end
