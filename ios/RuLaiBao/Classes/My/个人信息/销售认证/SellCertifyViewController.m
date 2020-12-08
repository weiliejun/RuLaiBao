//
//  SellCertifyViewController.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/13.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "SellCertifyViewController.h"
#import "Configure.h"
//scrollView
#import "TPKeyboardAvoidingScrollView.h"
//权限
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
//校验身份证号
#import "PersonCardChecking.h"
#import "InformationModel.h"


@interface SellCertifyViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, weak) TPKeyboardAvoidingScrollView *bgScrollView;
@property (nonatomic, weak) UIView *bgView;//背景view
@property (nonatomic, weak) UILabel *nameLabel;//真实姓名
@property (nonatomic, strong) UITextField *IdText;//身份证号
@property (nonatomic, strong) UITextField *jobText;//从业岗位
@property (nonatomic, strong) UITextField *cardText;//名片
@property (nonatomic, strong) UIControl *cardCtl;//名片背景ctl
@property (nonatomic, strong) UIImageView *cardImage;
@property (nonatomic, weak) UIView *warningView;//提示信息
@property (nonatomic, weak) UILabel *warningLabel;
@property (nonatomic, weak)UIButton *submitBtn;//提交按钮

@end

@implementation SellCertifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"销售认证";
    self.view.backgroundColor = [UIColor customBackgroundColor];
    [self createUI];
    self.isHaveImage = NO;
    [self requestInformationData];
}

#pragma mark - 设置界面元素
- (void)createUI{
    TPKeyboardAvoidingScrollView *bgScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, Height_Window-Height_Statusbar_NavBar)];
    bgScrollView.backgroundColor = [UIColor customBackgroundColor];
    bgScrollView.delegate = self;
    bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView = bgScrollView;
    [self.view addSubview:bgScrollView];
    
#pragma mark -- 适配iOS 11
    adjustsScrollViewInsets_NO(bgScrollView, self);
    
    //背景view
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width_Window, 220)];
    bgView.backgroundColor = [UIColor customBackgroundColor];
    [bgScrollView addSubview:bgView];
    self.bgView = bgView;
    
    //真实姓名
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Width_Window, 50)];
    nameView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:nameView];
    
    UILabel *nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 20)];
    nameLabel1.text = @"真实姓名";
    nameLabel1.textColor = [UIColor customTitleColor];
    nameLabel1.textAlignment = NSTextAlignmentLeft;
    nameLabel1.font = [UIFont systemFontOfSize:16];
    [nameView addSubview:nameLabel1];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width_Window/2, 15, Width_Window/2-10, 20)];
    nameLabel.text = [NSString stringWithFormat:@"%@",self.informationModel.realName];
    nameLabel.textColor = [UIColor customTitleColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [nameView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //身份证号
    self.IdText = [self createTextFWithRect:CGRectMake(0, nameView.bottom+1, Width_Window, 50) TextTag:101 TextLeftLabelStr:@"身份证号" LeftLabelWidth:100 TextPlaceholderStr:@"请输入您的身份证号" BGScrollView:bgView];
    self.IdText.enabled = YES;
    
    //从业岗位
    self.jobText = [self createTextFWithRect:CGRectMake(0, self.IdText.bottom+1, Width_Window, 50) TextTag:102 TextLeftLabelStr:@"从业岗位" LeftLabelWidth:100 TextPlaceholderStr:@"请输入您的从业岗位" BGScrollView:bgView];
    self.jobText.enabled = YES;

    //名片
    UIControl *cardCtl = [[UIControl alloc]initWithFrame:CGRectMake(0, self.jobText.bottom+1, Width_Window, 50)];
    cardCtl.backgroundColor = [UIColor whiteColor];
    [cardCtl addTarget:self action:@selector(upLoadCard) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cardCtl];
    self.cardCtl = cardCtl;
    
    self.cardText = [self createTextFWithRect:CGRectMake(0, 0, Width_Window, 50) TextTag:103 TextLeftLabelStr:@"名片" LeftLabelWidth:100 TextPlaceholderStr:@"" BGScrollView:cardCtl];
    self.cardText.enabled = NO;
   
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, bgView.bottom+50, Width_Window-40, 40)];
    submitBtn.backgroundColor = [UIColor customLightYellowColor];
    [submitBtn setTitle:@"提交认证" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 20;
    submitBtn.userInteractionEnabled = YES;
    [submitBtn addTarget:self action:@selector(goSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    
    bgScrollView.contentSize = CGSizeMake(Width_Window, submitBtn.bottom+Height_View_HomeBar+44+Height_Statusbar);
    
    //提示信息
    UIView *warningView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Statusbar_NavBar, Width_Window, 50)];
    warningView.backgroundColor = [UIColor customRedColor];
    [self.view addSubview:warningView];
    self.warningView = warningView;
    self.warningView.hidden = YES;
    
    UILabel *warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, Width_Window-40, 20)];
    warningLabel.text = @"";
    warningLabel.textColor = [UIColor whiteColor];
    warningLabel.font = [UIFont systemFontOfSize:16];
    warningLabel.numberOfLines = 0;
    [warningView addSubview:warningLabel];
    self.warningLabel = warningLabel;
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(Width_Window-30, 15, 20, 20)];
    [cancleBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [warningView addSubview:cancleBtn];
}

//判断按钮是否可点击
- (void)judgeSubmitBtnEnabled{
    //已认证，认证中不能提交按钮置灰
    if ([self.informationModel.checkStatus isEqualToString:@"success"]){
        //    success - 认证成功
        self.warningView.hidden = YES;
        self.IdText.enabled = NO;
        self.jobText.enabled = NO;
        self.cardCtl.enabled = NO;
        self.bgView.frame = CGRectMake(0, Height_Statusbar_NavBar, Width_Window, 220);
        self.submitBtn.frame = CGRectMake(20, self.bgView.bottom+50, Width_Window-40, 40);
        self.submitBtn.userInteractionEnabled = NO;
        self.submitBtn.backgroundColor = [UIColor lightGrayColor];
        [self.submitBtn setTitle:@"已认证" forState:UIControlStateNormal];
        
    }else if ([self.informationModel.checkStatus isEqualToString:@"submit"]){
        //   submit - 认证中
        self.warningView.hidden = NO;
        self.IdText.enabled = NO;
        self.jobText.enabled = NO;
        self.cardCtl.enabled = NO;
        self.bgView.frame = CGRectMake(0, self.warningView.bottom, Width_Window, 220);
        self.submitBtn.frame = CGRectMake(20, self.bgView.bottom+50, Width_Window-40, 40);
        self.submitBtn.userInteractionEnabled = NO;
        self.submitBtn.backgroundColor = [UIColor lightGrayColor];
        [self.submitBtn setTitle:@"认证中" forState:UIControlStateNormal];
        self.warningLabel.text = @"认证审核中，请耐心等待我们的反馈！";
        
    }else if ([self.informationModel.checkStatus isEqualToString:@"init"]){
        //    init - 未认证
        self.warningView.hidden = YES;
        self.IdText.enabled = YES;
        self.jobText.enabled = YES;
        self.cardCtl.enabled = YES;
        self.bgView.frame = CGRectMake(0, Height_Statusbar_NavBar, Width_Window, 220);
        self.submitBtn.frame = CGRectMake(20, self.bgView.bottom+50, Width_Window-40, 40);
        self.submitBtn.userInteractionEnabled = YES;
        self.submitBtn.backgroundColor = [UIColor customLightYellowColor];
        [self.submitBtn setTitle:@"提交认证" forState:UIControlStateNormal];
        
    }else {
        //    fail - 认证失败
        self.warningView.hidden = NO;
        self.IdText.enabled = YES;
        self.jobText.enabled = YES;
        self.cardCtl.enabled = YES;
        self.bgView.frame = CGRectMake(0, self.warningView.bottom, Width_Window, 220);
        self.submitBtn.frame = CGRectMake(20, self.bgView.bottom+50, Width_Window-40, 40);
        self.submitBtn.userInteractionEnabled = YES;
        self.submitBtn.backgroundColor = [UIColor customLightYellowColor];
        [self.submitBtn setTitle:@"提交认证" forState:UIControlStateNormal];
        self.warningLabel.text = @"认证失败，请提交您的真实信息！";
    }
}

#pragma mark - 取消提示框
- (void)cancelBtn:(UIButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
//        self.warningView.alpha = 0.0;
        self.warningView.hidden = YES;
        self.bgView.frame =  CGRectMake(0, Height_Statusbar_NavBar, Width_Window, 220);
        self.submitBtn.frame = CGRectMake(20, self.bgView.bottom+50, Width_Window-40, 40);
        
    } completion:^(BOOL finished) {
//        [self.warningView removeFromSuperview];
    }];
}

#pragma mark - 提交认证
- (void)goSubmitBtn:(UIButton *)btn{
    if (!self.IdText.text.length){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入您的身份证号"];
        return;
    }else if (![PersonCardChecking verifyIDCardNumber:self.IdText.text]){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入正确的身份证号!"];
        return;
    }else if (!self.jobText.text.length){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请输入您的从业岗位"];
        return;
    }else if (!self.isHaveImage){
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"请上传您的名片"];
        return;
    }else{
        //提交的时候加个提醒：确认提交认证信息？  取消/确定
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认提交认证信息？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *certifyAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //提交
            [self requestSubmitData];
            
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:certifyAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

#pragma mark - 请求提交认证
- (void)requestSubmitData{
    [[RequestManager sharedInstance]postSubmitWithIdNo:self.IdText.text position:self.jobText.text realName:self.nameLabel.text userId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"data"][@"message"]]];
        }else{
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
        }
        //提交后刷新页面（请求个人信息销售认证数据）
        [self requestInformationData];
        
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 请求个人信息销售认证数据
- (void)requestInformationData{
    WeakSelf
    [[RequestManager sharedInstance]postInformationWithUserId:[StoreTool getUserID] Success:^(id responseData) {
        NSDictionary *TipDic = responseData;
        if ([TipDic[@"code"] isEqualToString:@"0000"]) {
            StrongSelf
            NSDictionary *infoDict = TipDic[@"data"];
            strongSelf.informationModel = [InformationModel informationModelWithDictionary:infoDict];
            //真实姓名
            strongSelf.nameLabel.text = [NSString stringWithFormat:@"%@",strongSelf.informationModel.realName];
            //身份证号
            if (![strongSelf.informationModel.idNo isEqualToString:@""]) {
                strongSelf.IdText.text = [NSString stringWithFormat:@"%@",strongSelf.informationModel.idNo];
            }
            //从业岗位
            if (![strongSelf.informationModel.position isEqualToString:@""]) {
                strongSelf.jobText.text = [NSString stringWithFormat:@"%@",strongSelf.informationModel.position];
            }
            //名片
            if (![self.informationModel.busiCardPhoto isEqualToString:@""]) {
                self.isHaveImage = YES;
                [strongSelf.cardImage sd_setImageWithURL:[NSURL URLWithString:self.informationModel.busiCardPhoto] placeholderImage:[UIImage imageNamed:@"card"]];
                
            }else{
                self.isHaveImage = NO;
            }
            
            //存储认证状态
            [StoreTool storeCheckStatus:infoDict[@"checkStatus"]];
            //存储身份证号
            [StoreTool storePresonCardID:infoDict[@"idNo"]];
            
            
            //判断按钮状态
            [self judgeSubmitBtnEnabled];
            
        }else{
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:[NSString stringWithFormat:@"%@",TipDic[@"msg"]]];
        }
    } Error:^(NSError *error) {
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

#pragma mark - 创建textfield
-(UITextField *)createTextFWithRect:(CGRect)textRect TextTag:(NSInteger)textTag TextLeftLabelStr:(NSString *)textLeftLabelStr LeftLabelWidth:(CGFloat)leftLabelWidth TextPlaceholderStr:(NSString *)textPlaceholderStr BGScrollView:(UIView *)bgScrollView{
    UITextField *textF = [[UITextField alloc]initWithFrame:textRect];
    textF.backgroundColor = [UIColor whiteColor];
    textF.textColor = [UIColor customTitleColor];
    textF.textAlignment = NSTextAlignmentRight;
    textF.font = [UIFont systemFontOfSize:16];
    textF.delegate = self;
    textF.tag = textTag;
    textF.placeholder = textPlaceholderStr;
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UILabel *leftLabel= [[UILabel alloc]init];
    leftLabel.frame = CGRectMake(10, 0, leftLabelWidth, textRect.size.height);
    leftLabel.font = [UIFont systemFontOfSize:16];
    leftLabel.textColor = [UIColor customTitleColor];
    leftLabel.text = [NSString stringWithFormat:@"  %@",textLeftLabelStr];
    textF.leftView = leftLabel;
    textF.leftViewMode = UITextFieldViewModeAlways;
    
    if (textTag == 103) {
        //名片
        UIImageView *cardImage = [[UIImageView alloc]initWithFrame:CGRectMake(textF.right-60, (textF.height-30)/2, 30, 30)];
        [cardImage sd_setImageWithURL:[NSURL URLWithString:self.informationModel.busiCardPhoto] placeholderImage:[UIImage imageNamed:@"card"]];
        [textF addSubview:cardImage];
        self.cardImage = cardImage;
        cardImage.userInteractionEnabled = YES;
        
        //添加右箭头
        UIImageView *arrowImage =[[UIImageView alloc]initWithFrame:CGRectMake(textF.right-20, (textF.height-15)/2, 10, 15)];
        arrowImage.image = [UIImage imageNamed:@"arrow_r"];
        [textF addSubview:arrowImage];
        
    }else{
        UILabel *rightLabel= [[UILabel alloc]initWithFrame:CGRectMake(textRect.size.width-10, 0, 10, textRect.size.height)];
        textF.rightView = rightLabel;
        textF.rightViewMode = UITextFieldViewModeUnlessEditing;
    }
    
    //事件监听
    [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [bgScrollView addSubview:textF];
    return textF;
}

#pragma mark - 上传名片
- (void)upLoadCard{
    [self.view endEditing:YES];
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
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
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
    
    [self saveImage:lowImg withFileName:@"MyCardImage" ofType:@"png" inDirectory:documentsDirectoryPath];
    
    NSString *imgFile = [NSString stringWithFormat:@"%@/%@.%@", documentsDirectoryPath,@"MyCardImage",@"png"];
    [self uploadCardImg:imgFile];
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

#pragma mark - 上传名片接口
-(void)uploadCardImg:(NSString *)file{
    WeakSelf
    [[RequestManager sharedInstance]postSubmitWithPhoto:file photoType:@"cardPhoto" userId:[StoreTool getUserID] Success:^(id responseData) {
         NSDictionary *TipDic = responseData;
        StrongSelf
        if ([TipDic[@"flag"] isEqualToString:@"true"]) {
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"名片上传成功"];
            UIImage *resultImage = [UIImage imageWithContentsOfFile:file];
            strongSelf.cardImage.image = resultImage;
            strongSelf.isHaveImage = YES;
        }else{
            strongSelf.isHaveImage = NO;
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"名片上传失败"];
        }
    } Error:^(NSError *error) {
        self.isHaveImage = NO;
        [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"加载失败,请确认网络通畅"];
    }];
}

-(void)ShowAlertView:(NSString *)ShowStr{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:ShowStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UITextField 限制15个字符
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.tag == 102) {
        //从业岗位字数限制
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
            [QLMBProgressHUD showPromptViewInView:self.view WithTitle:@"最大允许输入15个字符!"];
        }
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
