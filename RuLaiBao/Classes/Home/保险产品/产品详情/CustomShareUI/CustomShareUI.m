//
//  CustomShareUI.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/9.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "CustomShareUI.h"
#import "Configure.h"
//导入ShareSDK分享功能
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"

static NSInteger ViewTag = 5201314;
@interface CustomShareUI ()<UIGestureRecognizerDelegate>
@end

@implementation CustomShareUI

static id _urlStr;//类方法中的全局变量这样用（类型前面加static）
static id _titleStr;//类方法中的全局变量这样用（类型前面加static）
static id _desStr;//类方法中的全局变量这样用（类型前面加static）
static NSMutableArray *itemArr;
static UIView *blackView;
+(void)shareWithUrl:(NSString *)urlStr{
    [self shareWithUrl:urlStr Title:@"" DesStr:@""];
}
/*只需要在分享按钮事件中 构建好分享内容publishContent传过来就好了*/
+(void)shareWithUrl:(NSString *)urlStr Title:(NSString *)titleStr DesStr:(NSString *)desStr{
    _urlStr = urlStr;
    _titleStr = titleStr;
    _desStr = desStr;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    /** 加上一层黑色透明效果 */
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Window, Height_Window)];
    blackView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [window addSubview:blackView];
    
    /** 点击退出手势 */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [blackView addGestureRecognizer:tap];

    itemArr = [NSMutableArray arrayWithCapacity:8];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
        [itemArr addObject:@{@"itemIcon":@"wFriend_icon",@"itemTitle":@"微信朋友圈",@"shareType":@"23"}];
        [itemArr addObject:@{@"itemIcon":@"wchat_icon",@"itemTitle":@"微信好友",@"shareType":@"22"}];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [itemArr addObject:@{@"itemIcon":@"qq_icon",@"itemTitle":@"QQ好友",@"shareType":@"24"}];
        [itemArr addObject:@{@"itemIcon":@"qqZone_icon",@"itemTitle":@"QQ空间",@"shareType":@"6"}];
    }
    [itemArr addObject:@{@"itemIcon":@"message_icon",@"itemTitle":@"私信好友",@"shareType":@"19"}];
    [itemArr addObject:@{@"itemIcon":@"copy_icon",@"itemTitle":@"复制链接",@"shareType":@"21"}];
    
    CGFloat bgHeight = 0 ;
    if (itemArr.count <= 4) {
        bgHeight = Width_Window/4+50;
    }else{
        bgHeight = Width_Window/2+50;
    }
    
    //判断好数组，然后定高度
    /** Share Content */
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0,Height_Window-Height_View_HomeBar-bgHeight,Width_Window,bgHeight+Height_View_HomeBar)];
    shareView.tag = ViewTag;
    shareView.backgroundColor = [UIColor whiteColor];
    [blackView addSubview:shareView];
    
    //按钮
    CGFloat BtnWidth = Width_Window/4;
    CGFloat BtnHeight = Width_Window/4;
    CGFloat imageWidth = Width_Window/8;
    CGFloat spaceW = Width_Window/16;
    for (NSInteger i=0; i<itemArr.count; i++) {
        NSMutableDictionary *dict = itemArr[i];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((i%4)*BtnWidth, (i/4)*BtnHeight, BtnWidth, BtnHeight)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i+100;
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:btn];
        
        UIImageView *btnImage = [[UIImageView alloc]initWithFrame:CGRectMake(spaceW, 10, imageWidth, imageWidth)];
        btnImage.image = [UIImage imageNamed:dict[@"itemIcon"]];
        [btn addSubview:btnImage];
        
        UILabel *btnLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, btnImage.bottom+5, BtnWidth-20, 20)];
        btnLabel.text = dict[@"itemTitle"];
        btnLabel.textColor = [UIColor customTitleColor];
        btnLabel.textAlignment = NSTextAlignmentCenter;
        btnLabel.font = [UIFont systemFontOfSize:12];
        [btn addSubview:btnLabel];
    }
    
    //灰色View
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, shareView.height-Height_View_HomeBar-50, Width_Window, 10)];
    middleView.backgroundColor = [UIColor customBackgroundColor];
    [shareView addSubview:middleView];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, shareView.height-Height_View_HomeBar-40, Width_Window, 40)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor customTitleColor] forState:UIControlStateNormal];
    cancleBtn.tag = 2000;
    [cancleBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancleBtn];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    shareView.frame = CGRectMake(0, Height_Window, Width_Window, 150);
    [UIView animateWithDuration:0.35f animations:^{
        shareView.frame = CGRectMake(0, Height_Window-Height_View_HomeBar-bgHeight, Width_Window, Height_View_HomeBar+bgHeight);
    } completion:^(BOOL finished) {
        
    }];
}

+(void)shareBtnClick:(UIButton *)btn{
    NSInteger shareType = 0;
    id urlStr = _urlStr;
    id titleStr = _titleStr;
    id desStr = _desStr;
    
    if (btn.tag == 2000) {
        [self dismiss];
        return;
    }
    
    NSDictionary *temp = itemArr[btn.tag-100];
    NSString *typeStr = temp[@"shareType"];
    shareType = [typeStr integerValue];
    
    /*  调用shareSDK的无UI分享类型 */
    [ShareSDK share:shareType parameters:[self withShareUrl:urlStr Title:titleStr DesStr:desStr] onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSLog(@"分享成功！");
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (shareType == 21) {
                        [QLMBProgressHUD showPromptViewInView:nil WithTitle:@"复制成功"];
                    }else{
                        [QLMBProgressHUD showPromptViewInView:nil WithTitle:@"分享成功"];
                    }
                    
                });
                
                [self dismiss];
                break;
            }
            case SSDKResponseStateFail:
            {
                NSLog(@"分享失败！");
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (shareType == 22 || shareType == 23) {
                        [QLMBProgressHUD showPromptViewInView:nil WithTitle:@"该分享方式暂未开通，请选择其他分享方式"];
                    }else{
                        [QLMBProgressHUD showPromptViewInView:nil WithTitle:@"分享失败"];
                    }
                });
                
                [self dismiss];
                
                break;
            }
            case SSDKResponseStateCancel:
            {
                NSLog(@"取消分享！");
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [QLMBProgressHUD showPromptViewInView:nil WithTitle:@"您已取消分享操作"];
//                });
                [self dismiss];
                
                break;
            }
                
            default:
                break;
        }
    }];
}

+ (void)dismiss {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *shareView = [window viewWithTag:ViewTag];
    //为了弹窗不那么生硬，这里加了个简单的动画
    [UIView animateWithDuration:0.35f animations:^{
        shareView.frame = CGRectMake(0, Height_Window, Width_Window, 0);
        blackView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
}

#pragma mark - 分享
+ (NSMutableDictionary *)withShareUrl:(NSString *)urlStr Title:(NSString *)titleStr DesStr:(NSString *)desStr{
    NSString *shareUrlStr = urlStr;
    NSString *shareTitleStr = titleStr;
    NSString *shareTextStr = desStr;
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *shareImage = [UIImage imageNamed:@"shareImg"];
    NSArray *imageArray = @[shareImage];
    
    [shareParams SSDKSetupShareParamsByText:shareTextStr
                                     images:imageArray
                                        url:[NSURL URLWithString:shareUrlStr]
                                      title:shareTitleStr
                                       type:SSDKContentTypeImage];
    //微信朋友圈
    [shareParams SSDKSetupWeChatParamsByText:shareTextStr title:shareTitleStr url:[NSURL URLWithString:shareUrlStr] thumbImage:shareImage image:shareImage musicFileURL:nil extInfo:@"" fileData:@"" emoticonData:@"" type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    //微信好友
    [shareParams SSDKSetupWeChatParamsByText:shareTextStr title:shareTitleStr url:[NSURL URLWithString:shareUrlStr] thumbImage:shareImage image:shareImage musicFileURL:nil extInfo:@"" fileData:@"" emoticonData:@"" type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    //QQ好友
    [shareParams SSDKSetupQQParamsByText:shareTextStr title:shareTitleStr url:[NSURL URLWithString:shareUrlStr] thumbImage:shareImage image:shareImage type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    //QQ空间
    [shareParams SSDKSetupQQParamsByText:shareTextStr title:shareTitleStr url:[NSURL URLWithString:shareUrlStr] thumbImage:shareImage image:shareImage type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
    //私信好友
    [shareParams SSDKSetupSMSParamsByText:[NSString stringWithFormat:@"%@\n%@\n%@",shareTitleStr,shareTextStr,shareUrlStr] title:shareTitleStr images:shareImage attachments:@"" recipients:nil type:SSDKContentTypeText];
    //复制链接
    [shareParams SSDKSetupCopyParamsByText:[NSString stringWithFormat:@"%@",shareUrlStr] images:shareImage url:[NSURL URLWithString:shareUrlStr] type:SSDKContentTypeText];
    
    return shareParams;
}

@end
