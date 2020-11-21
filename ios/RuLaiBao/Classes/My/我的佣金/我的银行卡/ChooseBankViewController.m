//
//  ChooseBankViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/15.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "ChooseBankViewController.h"
#import "Configure.h"


@interface ChooseBankViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) UIButton *cancelBtn;
@property (nonatomic, weak) UIButton *certainBtn;
@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSString *selectValue;

@end

@implementation ChooseBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleArr = @[@"中国银行",@"农业银行",@"工商银行",@"建设银行",@"交通银行",@"招商银行",@"广发银行",@"华夏银行",@"浦发银行"];
    self.selectValue = self.titleArr[0];
    
    [self createUI];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Window-Height_View_HomeBar-Height_Statusbar-244, Width_Window, 244+Height_View_HomeBar+Height_Statusbar)];
    bgView.backgroundColor = [UIColor customBackgroundColor];
    [self.view addSubview:bgView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 44)];
    topView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:topView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 1000;
    [topView addSubview:cancelBtn];
    
    UIButton *certainBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window-50, 0, 50, 44)];
    certainBtn.backgroundColor = [UIColor whiteColor];
    [certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [certainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [certainBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    certainBtn.tag = 2000;
    [topView addSubview:certainBtn];
    
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, topView.bottom, Width_Window, 200)];
    pickerView.backgroundColor = [UIColor customBackgroundColor];
    pickerView.showsSelectionIndicator = YES;
    //设置UIPickerView的代理
    pickerView.delegate =self;
    pickerView.dataSource =self;
    [bgView addSubview:pickerView];
    self.pickerView = pickerView;

}

#pragma mark - 取消、确定按钮点击事件
- (void)pressBtn:(UIButton *)btn{
    if (btn.tag == 1000) {//取消
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{//确定
        if (self.delegate && [self.delegate respondsToSelector:@selector(ChooseBankViewController:didPassValueWithStr:)]) {
            [self.delegate ChooseBankViewController:self didPassValueWithStr:self.selectValue];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIPickerView
//返回多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 9;
}

//每一行的数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.titleArr[row];
}

//选中时的效果
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.selectValue = self.titleArr[row];
}

//返回高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 35.0f;
}

//返回宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return Width_Window;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
