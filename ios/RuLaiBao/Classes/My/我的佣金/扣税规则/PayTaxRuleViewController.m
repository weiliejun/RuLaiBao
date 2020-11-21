//
//  PayTaxRuleViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "PayTaxRuleViewController.h"
#import "Configure.h"


@interface PayTaxRuleViewController ()

@property (nonatomic, strong) UIScrollView *bgscrollView;
/** 增值税、附加税*/
@property (nonatomic, strong) UILabel *surchargeLabel;
/** 提示信息*/
@property (nonatomic, strong) UILabel *warnLabel;
/** 个人所得税 */
@property (nonatomic, strong) UILabel *personalTaxlabel;
/** 表格 */
@property (nonatomic, strong) UIView *formView;
/** 税金合计 */
@property (nonatomic, strong) UILabel *totalTaxLabel;


@end

@implementation PayTaxRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"扣税规则";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self createUI];
    
}

#pragma mark - 设置界面元素
- (void)createUI {
    //背景view
    UIScrollView *bgscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar+10, Width_Window, Height_Window-Height_Statusbar_NavBar-10)];
    bgscrollView.backgroundColor = [UIColor whiteColor];
    bgscrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgscrollView];
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(bgscrollView, self);

    /** 1、增值税*/
    UILabel *addedTaxTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, Width_Window-20, 20)];
    addedTaxTitleLab.text = @"1、增值税计算：";
    addedTaxTitleLab.textColor = [UIColor customTitleColor];
    addedTaxTitleLab.textAlignment = NSTextAlignmentLeft;
    addedTaxTitleLab.font = [UIFont systemFontOfSize:16];
    [bgscrollView addSubview:addedTaxTitleLab];
    
    NSString *addedTaxStr = @"增值税=含增值税佣金收入/1.03*3%\n\n起征点：3万（不含增值税），即不含税佣金收入≤3万，则不征收增值税；\n\n税率固定：3%";
    CGFloat addedTaxHeight = [NSString sizeWithFont:[UIFont systemFontOfSize:16] Size:CGSizeMake(Width_Window-40, MAXFLOAT) Str:addedTaxStr].height;
    
    UILabel *addedTaxLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, addedTaxTitleLab.bottom+20, Width_Window-40, addedTaxHeight)];
    addedTaxLabel.text = addedTaxStr;
    addedTaxLabel.textColor = [UIColor customTitleColor];
    addedTaxLabel.textAlignment = NSTextAlignmentLeft;
    addedTaxLabel.font = [UIFont systemFontOfSize:16];
    addedTaxLabel.numberOfLines = 0;
    [bgscrollView addSubview:addedTaxLabel];
    
    /**2、附加税 */
    UILabel *surchargeTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, addedTaxLabel.bottom+20, Width_Window-20, 20)];
    surchargeTitleLab.text = @"2、附加税计算：";
    surchargeTitleLab.textColor = [UIColor customTitleColor];
    surchargeTitleLab.textAlignment = NSTextAlignmentLeft;
    surchargeTitleLab.font = [UIFont systemFontOfSize:16];
    [bgscrollView addSubview:surchargeTitleLab];
    
    NSString *surchargeStr = @"城建税：增值税\n\n教育费附加：增值税\n\n地方教育费附加：增值税";
    CGFloat surchargeHeight = [NSString sizeWithFont:[UIFont systemFontOfSize:16] Size:CGSizeMake(Width_Window-40, MAXFLOAT) Str:surchargeStr].height;
    
    UILabel *surchargeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, surchargeTitleLab.bottom+20, Width_Window-40, surchargeHeight)];
    surchargeLabel.text = surchargeStr;
    surchargeLabel.textColor = [UIColor customTitleColor];
    surchargeLabel.textAlignment = NSTextAlignmentLeft;
    surchargeLabel.font = [UIFont systemFontOfSize:16];
    surchargeLabel.numberOfLines = 0;
    [bgscrollView addSubview:surchargeLabel];
    
    /** 提示信息*/
    NSString *warnStr = @"注：《财政部、国家税务总局关于扩大有关政府性基金免征范围的通知》（财税〔2016〕12号）：销售额或营业额不超过10万元/月或30万/季度，免征教育费附加、地方教育费附加、水利建设基金；各省市附加税率并非一致。";
    CGFloat warnHeight = [NSString sizeWithFont:[UIFont systemFontOfSize:15] Size:CGSizeMake(Width_Window-40, MAXFLOAT) Str:warnStr].height;
    
    UILabel *warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, surchargeLabel.bottom+20, Width_Window-40, warnHeight)];
    warnLabel.text = warnStr;
    warnLabel.textColor = [UIColor customDetailColor];
    warnLabel.textAlignment = NSTextAlignmentLeft;
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.numberOfLines = 0;
    [bgscrollView addSubview:warnLabel];
    
    /** 3、个人所得税 */
    UILabel *personalTaxTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, warnLabel.bottom+20, Width_Window-20, 20)];
    personalTaxTitleLab.text = @"3、个人所得税计算：";
    personalTaxTitleLab.textColor = [UIColor customTitleColor];
    personalTaxTitleLab.textAlignment = NSTextAlignmentLeft;
    personalTaxTitleLab.font = [UIFont systemFontOfSize:16];
    [bgscrollView addSubview:personalTaxTitleLab];
    
    NSString *personalTaxStr = @"应纳税所得额：（不含税佣金收入-附加税）*（1-40%），40%为展业成本，不计算个税；\n\n当应纳税所得额≤4000，个人所得税 =（应纳税所得额-800）*20%\n\n当应纳税所得额≥4000，个人所得税=应纳税所得额*（1-20%）*适用税率-速算扣除数";
    CGFloat personalTaxHeight = [NSString sizeWithFont:[UIFont systemFontOfSize:16] Size:CGSizeMake(Width_Window-40, MAXFLOAT) Str:personalTaxStr].height;
    UILabel *personalTaxlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, personalTaxTitleLab.bottom+20, Width_Window-40, personalTaxHeight)];
    personalTaxlabel.text = personalTaxStr;
    personalTaxlabel.textColor = [UIColor customTitleColor];
    personalTaxlabel.textAlignment = NSTextAlignmentLeft;
    personalTaxlabel.font = [UIFont systemFontOfSize:16];
    personalTaxlabel.numberOfLines = 0;
    [bgscrollView addSubview:personalTaxlabel];
    
    /** 表格 */
    UIView *formView = [[UIView alloc]initWithFrame:CGRectMake(10, personalTaxlabel.bottom+20, Width_Window-20, 165)];
    formView.backgroundColor = [UIColor customBackgroundColor];
    [bgscrollView addSubview:formView];
    
    NSArray *formArr = @[@[@"级数",@"每次应纳税所得额",@"税率(%)",@"速算扣除数"],@[@"1",@"X≤20000元",@"20",@"0"],@[@"2",@"20000<X≤50000元",@"30",@"2000"],@[@"3",@"X>50000元",@"40",@"7000"]];

    // 每个label的宽度
    for (NSInteger i = 0; i < formArr.count; i++) {
        for (NSInteger j = 0; j < 4; j++) {
            UILabel *label = [[UILabel alloc] init];
            if (j == 0) {
                label.frame = CGRectMake(1, i*(40+1)+1, 45, 40);
                
            }else if (j == 2){
                label.frame = CGRectMake(48+Width_Window-20-190, i*(40+1)+1, 60, 40);
                
            }else if (j == 3){
                label.frame = CGRectMake(49+Width_Window-20-190+60, i*(40+1)+1, 80, 40);
                
            }else {
                label.frame = CGRectMake(1+45+1, i*(40+1)+1, Width_Window-20-190, 40);
                
            }
            label.backgroundColor = [UIColor whiteColor];
            label.text = [NSString stringWithFormat:@"%@",formArr[i][j]];
            label.textColor = [UIColor customTitleColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            [formView addSubview:label];
        }
    }
    
    /** 4、税金合计 */
    UILabel *totalTaxTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, formView.bottom+20, Width_Window-20, 20)];
    totalTaxTitleLab.text = @"4、税金合计：";
    totalTaxTitleLab.textColor = [UIColor customTitleColor];
    totalTaxTitleLab.textAlignment = NSTextAlignmentLeft;
    totalTaxTitleLab.font = [UIFont systemFontOfSize:16];
    [bgscrollView addSubview:totalTaxTitleLab];
    
    NSString *totalTaxStr = @"应交税金=增值税+附加税+个人所得税";
    CGFloat totalTaxHeight = [NSString sizeWithFont:[UIFont systemFontOfSize:16] Size:CGSizeMake(Width_Window-40, MAXFLOAT) Str:totalTaxStr].height;
    
    UILabel *totalTaxLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, totalTaxTitleLab.bottom+10, Width_Window-40, totalTaxHeight)];
    totalTaxLabel.text = totalTaxStr;
    totalTaxLabel.textColor = [UIColor customTitleColor];
    totalTaxLabel.textAlignment = NSTextAlignmentLeft;
    totalTaxLabel.font = [UIFont systemFontOfSize:16];
    totalTaxLabel.numberOfLines = 0;
    [bgscrollView addSubview:totalTaxLabel];
    
    /**5、代理人佣金收入*/
    UILabel *commissionTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, totalTaxLabel.bottom+20, Width_Window-20, 20)];
    commissionTitleLab.text = @"5、代理人佣金收入：";
    commissionTitleLab.textColor = [UIColor customTitleColor];
    commissionTitleLab.textAlignment = NSTextAlignmentLeft;
    commissionTitleLab.font = [UIFont systemFontOfSize:16];
    [bgscrollView addSubview:commissionTitleLab];
    
    NSString *commissionStr = @"税后收入=税前收入-应交税金";
    CGFloat commissionHeight = [NSString sizeWithFont:[UIFont systemFontOfSize:16] Size:CGSizeMake(Width_Window-40, MAXFLOAT) Str:commissionStr].height;
    
    UILabel *commissionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, commissionTitleLab.bottom+10, Width_Window-40, commissionHeight)];
    commissionLabel.text = commissionStr;
    commissionLabel.textColor = [UIColor customTitleColor];
    commissionLabel.textAlignment = NSTextAlignmentLeft;
    commissionLabel.font = [UIFont systemFontOfSize:16];
    commissionLabel.numberOfLines = 0;
    [bgscrollView addSubview:commissionLabel];
    
    bgscrollView.contentSize = CGSizeMake(Width_Window, commissionLabel.bottom + 100);
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
