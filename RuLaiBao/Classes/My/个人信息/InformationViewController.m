//
//  InformationViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "InformationViewController.h"
#import "Configure.h"
#import "ChangeNumber.h"
//权限
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
//销售认证
#import "SellCertifyViewController.h"
#import "InformationModel.h"


@interface InformationViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, weak) UIImageView *photoImage;
@property (nonatomic, strong) InformationModel *informationModel;

@end

@implementation InformationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestInformationData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人信息";
    self.view.backgroundColor = [UIColor customBackgroundColor];

}

#pragma mark - 请求个人信息销售认证数据
- (void)requestInformationData{
    WeakSelf
    [[RequestManager sharedInstance]postInformationWithUserId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *infoDict = TipDic[@"data"];
            //存储认证状态
            [StoreTool storeCheckStatus:infoDict[@"checkStatus"]];
            
            strongSelf.informationModel = [InformationModel informationModelWithDictionary:infoDict];
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
    //背景view
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar+10, Width_Window, 250)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    //头像
    UIControl *photoCtl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 100)];
    photoCtl.backgroundColor = [UIColor whiteColor];
    [photoCtl addTarget:self action:@selector(upLoadPhoto) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:photoCtl];
    
    UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 60, 20)];
    photoLabel.text = @"头像";
    photoLabel.textColor = [UIColor customTitleColor];
    photoLabel.font = [UIFont systemFontOfSize:16];
    photoLabel.textAlignment = NSTextAlignmentLeft;
    [photoCtl addSubview:photoLabel];
    
    UIImageView *photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(Width_Window-88, 20, 60, 60)];
    photoImage.layer.masksToBounds = YES;
    photoImage.layer.cornerRadius = 30;    
    [photoImage sd_setImageWithURL:[NSURL URLWithString:self.informationModel.headPhoto] placeholderImage:[UIImage imageNamed:@"information_header"]];
    
    [photoCtl addSubview:photoImage];
    self.photoImage = photoImage;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Width_Window-18, 43, 8, 14)];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    arrowImageView.image = [UIImage imageNamed:@"arrow_r"];
    [photoCtl addSubview:arrowImageView];
    
    //横线1
    UILabel *horizontalLine1 = [[UILabel alloc]initWithFrame:CGRectMake(0, photoCtl.bottom, Width_Window, 10)];
    horizontalLine1.backgroundColor = [UIColor customBackgroundColor];
    [bgView addSubview:horizontalLine1];
    
    //电话
    UILabel *phoneLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, horizontalLine1.bottom+10, 70, 20)];
    phoneLeftLabel.text = @"手机号码";
    phoneLeftLabel.textColor = [UIColor customTitleColor];
    phoneLeftLabel.textAlignment = NSTextAlignmentLeft;
    phoneLeftLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:phoneLeftLabel];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width_Window-160, horizontalLine1.bottom+10, 150, 20)];
    NSString *phoneStr = [NSString stringWithFormat:@"%@",self.informationModel.mobile];
    phoneLabel.text = [NSString changePhoneNum:phoneStr];
    phoneLabel.textColor = [UIColor customDetailColor];
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:phoneLabel];
    
    //横线2
    UILabel *horizontalLine2 = [[UILabel alloc]initWithFrame:CGRectMake(0, phoneLabel.bottom+10, Width_Window, 10)];
    horizontalLine2.backgroundColor = [UIColor customBackgroundColor];
    [bgView addSubview:horizontalLine2];
    
    //新增所在省市
    UILabel *addressLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, horizontalLine2.bottom+10, 80, 20)];
    addressLeftLabel.text = @"所在省市";
    addressLeftLabel.textColor = [UIColor customTitleColor];
    addressLeftLabel.textAlignment = NSTextAlignmentLeft;
    addressLeftLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:addressLeftLabel];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width_Window-160, horizontalLine2.bottom+10, 150, 20)];
    NSString *str = [self changeAreaString:self.informationModel.area];
    addressLabel.text = [NSString stringWithFormat:@"%@",str];
    addressLabel.textColor = [UIColor customDetailColor];
    addressLabel.textAlignment = NSTextAlignmentRight;
    addressLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:addressLabel];
    
    //横线3
    UILabel *horizontalLine3 = [[UILabel alloc]initWithFrame:CGRectMake(0, addressLabel.bottom+10, Width_Window, 10)];
    horizontalLine3.backgroundColor = [UIColor customBackgroundColor];
    [bgView addSubview:horizontalLine3];
    
    //销售认证
    UIControl *sellCtl = [[UIControl alloc]initWithFrame:CGRectMake(0, horizontalLine3.bottom, Width_Window, 40)];
    sellCtl.backgroundColor = [UIColor whiteColor];
    [sellCtl addTarget:self action:@selector(goSellVC) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sellCtl];
    
    UILabel *sellLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
    sellLeftLabel.text = @"销售认证";
    sellLeftLabel.textColor = [UIColor customTitleColor];
    sellLeftLabel.textAlignment = NSTextAlignmentLeft;
    sellLeftLabel.font = [UIFont systemFontOfSize:16];
    [sellCtl addSubview:sellLeftLabel];
    
    UIImageView *sellImage = [[UIImageView alloc]initWithFrame:CGRectMake(sellLeftLabel.right, 12, 16, 16)];
    sellImage.image = [UIImage imageNamed:@"uncertify"];
    [sellCtl addSubview:sellImage];
    
    UILabel *sellrightLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width_Window-108, 10, 80, 20)];
    sellrightLabel.text = @"未认证";
    sellrightLabel.textColor = [UIColor customTitleColor];
    sellrightLabel.textAlignment = NSTextAlignmentRight;
    sellrightLabel.font = [UIFont systemFontOfSize:16];
    [sellCtl addSubview:sellrightLabel];
    
    UIImageView *arrowImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(Width_Window-18, 13, 8, 14)];
    arrowImage2.contentMode = UIViewContentModeScaleAspectFill;
    arrowImage2.image = [UIImage imageNamed:@"arrow_r"];
    [sellCtl addSubview:arrowImage2];
    
    //判断认证状态
    if ([self.informationModel.checkStatus isEqualToString:@"success"]) {
        //success - 认证成功
        sellImage.image = [UIImage imageNamed:@"certify"];
        sellrightLabel.text = @"已认证";
    }else{
        //未认证
        sellImage.image = [UIImage imageNamed:@"uncertify"];
        if ([self.informationModel.checkStatus isEqualToString:@"init"]) {
            //init未认证（未填写认证信息）
            sellrightLabel.text = @"未认证";
        }else if ([self.informationModel.checkStatus isEqualToString:@"submit"]){
            //submit待认证(提交认证信息待审核)
            sellrightLabel.text = @"待认证";
        }else{
            //fail - 认证失败
            sellrightLabel.text = @"认证失败";
        }
    }
}

#pragma mark - 所在城市转码
- (NSString *)changeAreaString:(NSString *)areaStr {
    NSString *newStr;
    if ([areaStr isEqualToString:@"beijing"]) {
        newStr = @"北京";
        
    }else if ([areaStr isEqualToString:@"hebei"]){
        newStr = @"河北";
        
    }else if ([areaStr isEqualToString:@"neimeng"]){
        newStr = @"内蒙";
        
    }else if ([areaStr isEqualToString:@"guizhou"]){
        newStr = @"贵州";
        
    }else {
        newStr = @"--";
    }
    
    return newStr;
}

#pragma mark - 销售认证
- (void)goSellVC{
    SellCertifyViewController *sellVC = [[SellCertifyViewController alloc]init];
    sellVC.informationModel = self.informationModel;
    [self.navigationController pushViewController:sellVC animated:YES];
}

#pragma mark - 上传头像
- (void)upLoadPhoto{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *paizhaoACtion = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //判定相机权限授权
        [self deviceUserVideoAuthorityStatus];
    }];
    UIAlertAction *xiangjiACtion = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //判定相册权限授权
        [self deviceUserPhotoAuthorityStatus];
    }];
    //    [cancelction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    [alertVC addAction:cancelction];
    [alertVC addAction:paizhaoACtion];
    [alertVC addAction:xiangjiACtion];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 权限
//相册权限
-(void)deviceUserPhotoAuthorityStatus{
    //让用户给权限,没有的话会被拒的各位
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusNotDetermined) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                //用户同意授权相册
                [self presentImagePickerVC:0];
            }else {
                [self ShowAlertView:@"您未开启相册权限,请前往设置中心开启"];
            }
        }];
    }else if (photoAuthorStatus == PHAuthorizationStatusAuthorized) {//有权限时
        [self presentImagePickerVC:0];
    }else{
        [self ShowAlertView:@"您未开启相册权限,请前往设置中心开启"];
    }
}

//相机权限
-(void)deviceUserVideoAuthorityStatus{
    //让用户给权限,没有的话会被拒的各位
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {
        //
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted){
                [self presentImagePickerVC:1];
            }else {
                [self ShowAlertView:@"您未授权开启相机权限,请前往设置中心开启"];
            }
        }];
    }else if (videoAuthStatus == AVAuthorizationStatusAuthorized) {//有权限时
        [self presentImagePickerVC:1];
    }else{
        [self ShowAlertView:@"您未授权开启相机权限,请前往设置中心开启"];
    }
}

-(void)presentImagePickerVC:(NSInteger)selectNum{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (selectNum == 0) {
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    if(sourceType == UIImagePickerControllerSourceTypeCamera){
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //获取图片裁剪的图
    UIImage *edit = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //获取图片裁剪后，剩下的图
    UIImage *lowImg = [self imageWithImageSimple:edit scaledToSize:CGSizeMake(120.0, 120.0)];
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"保存路径:%@",documentsDirectoryPath);
    
    [self saveImage:lowImg withFileName:@"MyHeaderImage" ofType:@"png" inDirectory:documentsDirectoryPath];
    
    NSString *imgFile = [NSString stringWithFormat:@"%@/%@.%@", documentsDirectoryPath,@"MyHeaderImage",@"png"];
    [self uploadHeaderImg:imgFile];
}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen] scale]);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//保存图片
-(void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"文件后缀不认识");
    }
}

#pragma mark - 上传头像接口
-(void)uploadHeaderImg:(NSString *)file{
    WeakSelf
    [[RequestManager sharedInstance]postSubmitWithPhoto:file photoType:@"headPhoto" userId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"flag"] isEqualToString:@"true"]) {
            StrongSelf
            UIImage *resultImage = [UIImage imageWithContentsOfFile:file];
            strongSelf.photoImage.image = resultImage;
            [QLMBProgressHUD showPromptViewInView:strongSelf.view WithTitle:@"头像上传成功"];
        }else{
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"头像上传失败"];
        }
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

-(void)ShowAlertView:(NSString *)ShowStr{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:ShowStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelction];
    [self presentViewController:alertVC animated:YES completion:nil];
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
