//
//  RegisterChooseCityController.m
//  RuLaiBao
//
//  Created by qiu on 2018/11/13.
//  Copyright © 2018 junde. All rights reserved.
//

#import "RegisterChooseCityController.h"
#import "Configure.h"

@interface RegisterChooseCityController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, weak) UIPickerView *pickerView;

/** 全部数据 */
@property (nonatomic, strong) NSArray *pickerArray;
@property (nonatomic, strong) NSArray *areaStrArray;

@end

@implementation RegisterChooseCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** height设置区间在0～179时，UIPickerView的height为162
     height设置区间在180～215时，UIPickerView的height为180
     height设置区间在216～∞时，UIPickerView的height为216 */
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, Height_Window-216, Width_Window, 216)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.view addSubview:pickerView];
    
    _pickerView = pickerView;
    
    [self createBtnView];
}

-(void)createBtnView{
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, self.pickerView.top-45, Width_Window, 45)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, btnView.height-1, btnView.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.894 green:0.893 blue:0.913 alpha:1.000];
    [btnView addSubview:lineView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, btnView.height-1)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor customBlueColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(quxiao) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:cancelBtn];
    
    UIButton *selectOKBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnView.width-60, 0, 60, btnView.height-1)];
    [selectOKBtn setTitle:@"完成" forState:UIControlStateNormal];
    [selectOKBtn setTitleColor:[UIColor customBlueColor] forState:UIControlStateNormal];
    [selectOKBtn addTarget:self action:@selector(wancheng) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:selectOKBtn];
}

- (void)quxiao{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)wancheng{
    /** 汉字 */
    NSString *strCity = [self.pickerArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    /** 英文 */
    NSString *areaStr = [self.areaStrArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    NSArray *Arr = @[strCity,areaStr,[NSString stringWithFormat:@"%@",strCity]];
    
    if (self.chooseDelegate && [self.chooseDelegate respondsToSelector:@selector(viewController:didChooseCityWithStr:)]) {
        [self.chooseDelegate viewController:self didChooseCityWithStr:Arr];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return Width_Window;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 33;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

- (NSArray *)pickerArray{
    if (_pickerArray == nil) {
        NSArray *arr = @[@"北京",@"河北",@"内蒙",@"贵州"];
        _pickerArray = arr;
    }
    return _pickerArray;
}

- (NSArray *)areaStrArray{
    if (_areaStrArray == nil) {
        NSArray *arr = @[@"beijing",@"hebei",@"neimeng",@"guizhou"];
        _areaStrArray = arr;
    }
    return _areaStrArray;
}
@end
