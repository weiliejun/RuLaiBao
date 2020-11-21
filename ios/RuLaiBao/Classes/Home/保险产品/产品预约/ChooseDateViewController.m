//
//  ChooseDateViewController.m
//  HaiDeHui
//
//  Created by kingstartimes on 2018/1/8.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "ChooseDateViewController.h"
#import "Configure.h"

@interface ChooseDateViewController ()

@property (nonatomic, weak) UIButton *cancelBtn;
@property (nonatomic, weak) UIButton *certainBtn;
@property (nonatomic, weak) UIDatePicker *datePicker;



@end

@implementation ChooseDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Window-Height_View_HomeBar-Height_Statusbar-244, Width_Window, 244+Height_View_HomeBar+Height_Statusbar)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 1000;
    [bgView addSubview:cancelBtn];
    
    UIButton *certainBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window-50, 0, 50, 44)];
    certainBtn.backgroundColor = [UIColor whiteColor];
    [certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [certainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [certainBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    certainBtn.tag = 2000;
    [bgView addSubview:certainBtn];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, certainBtn.bottom, Width_Window, 200)];
    datePicker.backgroundColor = [UIColor customBackgroundColor];
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setMinimumDate:[NSDate date]];
    self.datePicker = datePicker;
    [bgView addSubview:datePicker];
}

#pragma mark - 取消、确定按钮点击事件
- (void)pressBtn:(UIButton *)btn{
    if (btn.tag == 1000) {//取消
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{//确定
        NSDate *pickerDate = [self.datePicker date];
        NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc]init];
        [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [pickerFormatter stringFromDate:pickerDate];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ChooseDateViewController:didPassingValueWithStr:)]) {
            [self.delegate ChooseDateViewController:self didPassingValueWithStr:dateStr];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
