//
//  RLBAlertView.h
//  RuLaiBao
//
//  Created by qiu on 2020/12/1.
//  Copyright © 2020 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickButton)(NSInteger index,NSString*urlStr,NSString*titleStr);

@interface RLBAlertView : UIView<UITextViewDelegate,UITextFieldDelegate>
{
    UILabel     * lab_title;
    
    UITextView  * textview;
    
    UIButton    * btn_confirm;
    UIButton    * btn_cancel;
    UIView      * contentview;
    UIView      * view_mask;              //遮罩层
}

@property(nonatomic,copy)NSString * str_title;
@property(nonatomic,copy)NSString * str_msg;
@property(nonatomic,copy)NSString * str_btn1title;  //取消按钮标题
@property(nonatomic,copy)NSString * str_btn2title;  //确定按钮标题
@property(nonatomic,copy)NSString * TextAlignment;
@property(nonatomic,copy)ClickButton ClickBtnBlock;

+(RLBAlertView *)AlertWith:(NSString *)title ConfirmBtn:(NSString *)str1 CancelBtn:(NSString *)str2 Msg:(NSString *)content ResultBolck:(ClickButton)clickBlock;

-(void)show;
-(void)hide;

-(void)show:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
