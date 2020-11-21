//
//  RecommendViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "RecommendViewController.h"
#import "Configure.h"
/** Label字体变色 */
#import "QLColorLabel.h"
/** 生成二维码 */
#import <CoreImage/CoreImage.h>
/** 推荐记录 */
#import "RecordListViewController.h"
/** 自定义分享 */
#import "CustomShareUI.h"


@interface RecommendViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) QLColorLabel *numberLabel;
@property (nonatomic, weak) UILabel *codeLabel;//推荐码
@property (nonatomic, weak) UIImageView *codeView;//二维码
@property (nonatomic, strong) NSDictionary *infoDict;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"推荐App给好友";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    [self requestRecommendData];
    
}

#pragma mark - 请求推荐给好友数据
- (void)requestRecommendData{
    WeakSelf
    [[RequestManager sharedInstance]postRecommendWithUserId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            strongSelf.infoDict = TipDic[@"data"];
//            //推荐好友数量
//            strongSelf.numberLabel.text = [NSString stringWithFormat:@"已推荐 <%@> 位好友",self.infoDict[@"total"]];
//            //推荐码
//            strongSelf.codeLabel.text = [NSString stringWithFormat:@"我的推荐码：%@",strongSelf.infoDict[@"recommendCode"]];
            
            [self createUI];
            
        }else{
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
        }
        
    } Error:^(NSError *error) {
       [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 设置界面元素
- (void)createUI{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, Height_Window-Height_Statusbar_NavBar)];
    scrollView.backgroundColor = [UIColor customBackgroundColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //图片背景
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, Height_Window-Height_Statusbar_NavBar)];
    bgView.image = [UIImage imageNamed:@"recommend"];
    bgView.userInteractionEnabled = YES;
    [scrollView addSubview:bgView];
    
    //白色View
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(15, bgView.bottom-358, Width_Window-30, 358)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 10;
    [bgView addSubview:whiteView];
    
    //邀请好友数量
    QLColorLabel *numberLabel = [[QLColorLabel alloc]initWithFrame:CGRectMake(50, 0, whiteView.width-100, 50)];
    numberLabel.backgroundColor = [UIColor customBlueColor];
    numberLabel.textColor = [UIColor whiteColor];
    [numberLabel setAnotherColor: [UIColor customLightYellowColor]];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont systemFontOfSize:16];
    //设置指定字体颜色
    NSString *str = [NSString stringWithFormat:@"%@",self.infoDict[@"total"]];
    numberLabel.text = [NSString stringWithFormat:@"已推荐 <%@> 位好友",str];
    [whiteView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    //设置左下，右下圆角
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:numberLabel.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
    maskLayer.frame = numberLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    numberLabel.layer.mask=maskLayer;
    
    //二维码
    UIImageView *codeView = [[UIImageView alloc]initWithFrame:CGRectMake((whiteView.width-120)/2, numberLabel.bottom+20, 120, 120)];
    codeView.layer.borderColor = [UIColor customBlueColor].CGColor;
    codeView.layer.borderWidth = 1;
    [whiteView addSubview:codeView];
    self.codeView = codeView;
    
    UIImageView *middleImage= [[UIImageView alloc]initWithFrame:CGRectMake(codeView.width/2-10, codeView.height/2-10, 20, 20)];
    middleImage.image = [UIImage imageNamed:@"codeImg"];
    middleImage.backgroundColor = [UIColor orangeColor];
    [codeView addSubview:middleImage];
    
    NSString *string = [NSString stringWithFormat:@"http://%@/register/%@/recommend",RequestHeader,self.infoDict[@"recommendCode"]];
    [self createCode:string];
    
    //推荐码
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, codeView.bottom+10, whiteView.width-20, 20)];
    codeLabel.text = [NSString stringWithFormat:@"我的推荐码：%@",self.infoDict[@"recommendCode"]];
    codeLabel.textColor = [UIColor customTitleColor];
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.font = [UIFont systemFontOfSize:16];
    [whiteView addSubview:codeLabel];
    self.codeLabel = codeLabel;
    
    //推荐给朋友
    UIButton *recommendBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, codeLabel.bottom+20, whiteView.width-20, 44)];
    recommendBtn.backgroundColor = [UIColor customLightYellowColor];
    [recommendBtn setTitle:@"推荐给朋友" forState:UIControlStateNormal];
    [recommendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    recommendBtn.layer.masksToBounds = YES;
    recommendBtn.layer.cornerRadius = 20;
    [recommendBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    recommendBtn.tag = 10000;
    [whiteView addSubview:recommendBtn];
    
    //推荐记录
    UIButton *recordListBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, recommendBtn.bottom+10, whiteView.width-20, 44)];
    [recordListBtn setTitle:@"推荐记录" forState:UIControlStateNormal];
    [recordListBtn setTitleColor:[UIColor customDetailColor] forState:UIControlStateNormal];
    [recordListBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    recordListBtn.tag =  20000;
    [whiteView addSubview:recordListBtn];
    
    bgView.frame = CGRectMake(0, 0, Width_Window, whiteView.bottom+10+Height_View_HomeBar);
    scrollView.contentSize = CGSizeMake(Width_Window, bgView.bottom);
    
    /** 去掉错乱情况 */
    adjustsScrollViewInsets_NO(self.scrollView, self);
}

#pragma mark - 生成二维码
- (void)createCode:(NSString *)string{
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *ciimage = [filter outputImage];
    
    // 4. 显示二维码
    self.codeView.image = [self createNonInterpolatedUIImageFormCIImage:ciimage withSize:120];
}

/**
 *  根据CIImage生成指定大小的UIImage
 *  @param image CIImage
 *  @param size  图片宽度以及高度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

    //1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - 分享/推荐记录
- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 10000) {
        //分享
        [self toShareForFriend];
        
    }else{
        //推荐记录
        RecordListViewController *recordVC = [[RecordListViewController alloc]init];
        [self.navigationController pushViewController:recordVC animated:YES];
    }
}

#pragma mark - 分享
- (void)toShareForFriend{
    //调用自定义分享
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/register/%@/recommend",RequestHeader,self.infoDict[@"recommendCode"]];
    [CustomShareUI shareWithUrl:urlStr Title:@"高效获客，高效成交" DesStr:@"如来保是一款面向广大营销员伙伴们的应用软件，可以提供在线承保；在线计划书生成、分享；在线预约；投保状态实时跟踪；在线保单检视；风险缺口分析等全方位营销工具。"];
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
