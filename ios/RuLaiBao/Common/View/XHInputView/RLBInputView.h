//
//  RLBInputView.h
//  RuLaiBao
//
//  Created by qiu on 2018/11/13.
//  Copyright © 2018 junde. All rights reserved.
//

/*!
 带有图片和链接的评论view
 */
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RLBInputViewStyle) {
    RLBInputViewStyleDefault,//底部，有链接按钮
    RLBInputViewStyleReply,//回复，无链接按钮
};

@class RLBInputView;
@protocol RLBInputViewDelagete <NSObject>
@optional

/**
 RLBInputView 将要显示
 
 @param inputView inputView
 */
-(void)rlbInputViewWillShow:(RLBInputView *)inputView;

/**
 RLBInputView 将要影藏
 
 @param inputView inputView
 */
-(void)rlbInputViewWillHide:(RLBInputView *)inputView;

/**
 RLBInputView 将要显示
 
 @param inputOriginY das
 */
-(void)rlbInputViewKeyboardWillShow:(CGFloat)inputOriginY;

/**
 RLBInputView 将要影藏
 
 @param inputOriginY das
 */
-(void)rlbInputViewKeyboardWillHide:(CGFloat)inputOriginY;

@end

@interface RLBInputView : UIView

@property (nonatomic, assign) id<RLBInputViewDelagete> delegate;

/** 最大输入字数 */
@property (nonatomic, assign) NSInteger maxCount;
/** 内容 */
@property (nonatomic, copy) NSString *defaultText;
/** 字体 */
@property (nonatomic, strong) UIFont * font;
/** 占位符 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位符颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 输入框背景颜色 */
@property (nonatomic, strong) UIColor* textViewBackgroundColor;
/** 发送按钮背景色 */
@property (nonatomic, strong) UIColor *sendButtonBackgroundColor;
/** 发送按钮Title */
@property (nonatomic, copy) NSString *sendButtonTitle;
/** 发送按钮圆角大小 */
@property (nonatomic, assign) CGFloat sendButtonCornerRadius;
/** 发送按钮字体 */
@property (nonatomic, strong) UIFont * sendButtonFont;
/** 在dismiss时，回调此text */
@property (nonatomic, strong, readonly) UITextView *textView;

/** 如果有图片的情况 */
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
/** 如果有url链接的情况 */
@property (nonatomic, copy) NSString *urlLinkStr;

/**
 显示输入框
 
 @param style 类型
 @param configurationBlock 请在此block中设置RLBInputView属性
 @param sendBlock 发送按钮点击回调
 @param selectImageBlock 点击选择图片回调
 */
+(void)showWithStyle:(RLBInputViewStyle)style configurationBlock:(void(^)(RLBInputView *inputView))configurationBlock sendBlock:(BOOL(^)(NSString *text,NSString *linkUrlText,NSMutableArray *photos))sendBlock selectImageBlock:(void(^)(void))selectImageBlock previewImageBlock:(void(^)(NSMutableArray *photos,NSMutableArray *assets))previewImageBlock;

@end
