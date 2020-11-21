//
//  ChooseAddressViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/16.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "ChooseAddressViewController.h"
#import "Configure.h"

@interface ChooseAddressViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) UIPickerView *pickerView;

/** 全部数据 */
@property (strong,nonatomic) NSArray *pickerArray;
/** 省 */
@property (strong,nonatomic) NSArray *provinceArray;
/** 中间dict，用于切换第三极地址 */
@property (nonatomic, strong) NSDictionary *selectDict;
/** 城市 */
@property (strong,nonatomic) NSArray *cityArray;
/** 乡 */
@property (strong,nonatomic) NSArray *townArray;

@end

@implementation ChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createBaseView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerArray = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *contentDict in self.pickerArray) {
        NSString *province = contentDict[@"province"];
        [arrayM addObject:province];
    }
    // 所有省份数据
    self.provinceArray = arrayM;
    
    self.selectDict = [self.pickerArray.firstObject objectForKey:@"city"];
    if (self.provinceArray.count > 0) {
        self.cityArray = [self.selectDict allKeys];
    }
//    if (self.cityArray.count > 0) {
//        self.townArray = [self.selectDict objectForKey:[self.cityArray objectAtIndex:0]];
//    }
}

#pragma mark - 创建view
- (void)createBaseView {
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
        NSString *strProvince = [self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        NSString *strCity = [self.cityArray objectAtIndex:[self.pickerView selectedRowInComponent:1]];
//        NSString *strTown = [self.townArray objectAtIndex:[self.pickerView selectedRowInComponent:2]];
        NSArray *Arr = [NSArray array];
//        Arr = @[strProvince,strCity,strTown,[NSString stringWithFormat:@"%@-%@-%@",strProvince,strCity,strTown]];
        Arr = @[strProvince,strCity,[NSString stringWithFormat:@"%@-%@",strProvince,strCity]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:didPassingAddWithStr:)]) {
            [self.delegate viewController:self didPassingAddWithStr:Arr];
    
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - 重写方法
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
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else  {
        return self.cityArray.count;
    }
//    else {
//        return self.townArray.count;
//    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    }else  {
        return [self.cityArray objectAtIndex:row];
    }
//    else {
//        return [self.townArray objectAtIndex:row];
//    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return Width_Window/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 33;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectDict = [[self.pickerArray objectAtIndex:row] objectForKey:@"city"];
        if (self.provinceArray.count > 0) {
            self.cityArray = [self.selectDict allKeys];
        }else {
            self.cityArray = nil;
        }
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
//        if (self.cityArray.count > 0) {
//            self.townArray = [self.selectDict objectForKey:[self.cityArray objectAtIndex:[pickerView selectedRowInComponent:1]]];
//        }else {
//            self.townArray = nil;
//        }
//        [pickerView reloadComponent:2];
//        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }
//    else if (component == 1){
//        if (self.cityArray.count > 0) {
//            self.townArray = [self.selectDict objectForKey:[self.cityArray objectAtIndex:row]];
//        } else {
//            self.townArray = nil;
//        }
//        [pickerView reloadComponent:2];
//        [pickerView selectRow:0 inComponent:2 animated:YES];
//    }
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
