//
//  RLBInputView.m
//  RuLaiBao
//
//  Created by qiu on 2018/11/13.
//  Copyright © 2018 junde. All rights reserved.
//
/*!
 此页面的布局由纯rect来计算设计
 可以用autolayout来实现
 */
#import "RLBInputView.h"
#import "RLBInputLinkView.h"
#import "Configure.h"

#import "RLBSelectImagePickerTool.h"

#define XHInputView_ScreenW    [UIScreen mainScreen].bounds.size.width
#define XHInputView_ScreenH    [UIScreen mainScreen].bounds.size.height
#define XHInputView_StyleLarge_LRSpace 10
#define XHInputView_StyleLarge_TBSpace 8
#define XHInputView_StyleDefault_LRSpace 5
#define XHInputView_StyleDefault_TBSpace 5
#define XHInputView_CountLabHeight 20
#define XHInputView_BgViewColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]

#define XHInputView_StyleLarge_Height 90
#define XHInputView_StyleDefault_Height 45

static CGFloat keyboardAnimationDuration = 0.5;
static CGFloat krlbInputView_Link_Height = 45;

@interface RLBInputView()<UITextViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView * textBgView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *placeholderLab;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, assign) RLBInputViewStyle style;

/** control的父view */
@property (nonatomic, strong) UIView *controlBGView;
@property (nonatomic, strong) UIControl *urlLinkControl;
@property (nonatomic, strong) UIControl *upImageControl;
/** 显示图片和链接的view */
@property (nonatomic, weak) RLBInputLinkView *linkView;

@property (nonatomic, assign) CGRect showFrameDefault;
@property (nonatomic, assign) CGRect sendButtonFrameDefault;
@property (nonatomic, assign) CGRect textViewFrameDefault;
@property (nonatomic, assign) CGRect controlFrameDefault;

/** 发送按钮点击回调 */
@property (nonatomic, copy) BOOL (^sendBlcok)(NSString *text,NSString *linkUrlText,NSMutableArray *photos);
@property (nonatomic, copy) void (^selectImageBlock)(void);
@property (nonatomic, copy) void (^previewImageBlock)(NSMutableArray *arr1,NSMutableArray *arr2);
@end

@implementation RLBInputView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:_textView];
}
+(void)showWithStyle:(RLBInputViewStyle)style configurationBlock:(void(^)(RLBInputView *inputView))configurationBlock sendBlock:(BOOL(^)(NSString *text,NSString *linkUrlText,NSMutableArray *photos))sendBlock selectImageBlock:(void(^)(void))selectImageBlock  previewImageBlock:(void(^)(NSMutableArray *arr1,NSMutableArray *arr2))previewImageBlock{
    RLBInputView *inputView = [[RLBInputView alloc] initWithStyle:style];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:inputView];
    
    if(configurationBlock) configurationBlock(inputView);
    inputView.sendBlcok = [sendBlock copy];
    inputView.selectImageBlock = [selectImageBlock copy];
    inputView.previewImageBlock = [previewImageBlock copy];
    [inputView show];
}
#pragma mark - private
-(void)show{
    if([self.delegate respondsToSelector:@selector(rlbInputViewWillShow:)]){
        [self.delegate rlbInputViewWillShow:self];
    }
    if(self.defaultText.length != 0){
        _textView.text = self.defaultText;
        _placeholderLab.hidden = YES;
    }else{
        _textView.text = nil;
        _placeholderLab.hidden = NO;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_textView becomeFirstResponder];
        if (self.defaultText.length != 0) {
            [self defaultTextViewContentSize:_textView];
        }
    });
}

#pragma mark - 位置调整1
/** 若有默认值时，自动变化高度 */
-(void)defaultTextViewContentSize:(UITextView *)textView{
    //让textview随行数自动改变自身的高度，超过90+link的高度就不再增加
    CGFloat height = textView.contentSize.height+krlbInputView_Link_Height;
    CGFloat heightDefault = XHInputView_StyleDefault_Height+krlbInputView_Link_Height;
    if (height <= heightDefault) {
        return;
    }else if(height >= XHInputView_StyleLarge_Height+krlbInputView_Link_Height){
        //调整frame
        CGRect frame = _showFrameDefault;
        frame.size.height = XHInputView_StyleLarge_Height+krlbInputView_Link_Height;
        frame.origin.y = _showFrameDefault.origin.y - (XHInputView_StyleLarge_Height+krlbInputView_Link_Height - _showFrameDefault.size.height);
        _inputView.frame = frame;
        //调整sendButton frame
        _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleDefault_LRSpace - _sendButton.frame.size.width, _inputView.bounds.size.height - _sendButton.bounds.size.height - XHInputView_StyleDefault_TBSpace, _sendButton.bounds.size.width, _sendButton.bounds.size.height);
        //调整textView frame
        _textView.frame = CGRectMake(XHInputView_StyleDefault_LRSpace, XHInputView_StyleDefault_TBSpace+krlbInputView_Link_Height, _textView.bounds.size.width, _inputView.bounds.size.height - 2*XHInputView_StyleDefault_TBSpace-krlbInputView_Link_Height);
    }else{
        //调整frame
        CGRect frame = _showFrameDefault;
        frame.size.height = height;
        frame.origin.y = _showFrameDefault.origin.y - (height - _showFrameDefault.size.height);
        _inputView.frame = frame;
        //调整sendButton frame
        _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleDefault_LRSpace - _sendButton.frame.size.width, _inputView.bounds.size.height - _sendButton.bounds.size.height - XHInputView_StyleDefault_TBSpace, _sendButton.bounds.size.width, _sendButton.bounds.size.height);
        //调整textView frame
        _textView.frame = CGRectMake(XHInputView_StyleDefault_LRSpace, XHInputView_StyleDefault_TBSpace+krlbInputView_Link_Height, _textView.bounds.size.width, _inputView.bounds.size.height - 2*XHInputView_StyleDefault_TBSpace-krlbInputView_Link_Height);
    }
    
    [self changeLinkFrameWithOriginY:_inputView.frame.origin.y];
}

-(void)hide{
    if(_style == RLBInputViewStyleDefault){
        if(_linkView != nil){
            self.urlLinkStr = [NSString stringWithFormat:@"%@",[_linkView getTextFieldStr]];
        }else{
            self.urlLinkStr = @"";
        }
    }
    
    if([self.delegate respondsToSelector:@selector(rlbInputViewWillHide:)]){
        [self.delegate rlbInputViewWillHide:self];
    }
    [_linkView.urlTextField resignFirstResponder];
    [_textView resignFirstResponder];
}
#pragma mark - init
- (instancetype)initWithStyle:(RLBInputViewStyle)style
{
    self = [super init];
    if (self) {
        
        _style = style;
        
        if (style == RLBInputViewStyleDefault) {
            krlbInputView_Link_Height = 45;
        }else{
            krlbInputView_Link_Height = 0;
        }
        /** 创建UI */
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    /** 键盘监听 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    _inputView = [[UIView alloc] init];
    _inputView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_inputView];
    
    switch (_style) {
        case RLBInputViewStyleDefault:{
            //上部的点击
            _controlBGView = [[UIView alloc]init];
            _controlBGView.backgroundColor = [UIColor whiteColor];
            [_inputView addSubview:_controlBGView];
            
            _inputView.frame = CGRectMake(0, XHInputView_ScreenH, XHInputView_ScreenW, XHInputView_StyleDefault_Height+krlbInputView_Link_Height);
            
            _controlBGView.frame = CGRectMake(0, 0, XHInputView_ScreenW, krlbInputView_Link_Height);
            [_controlBGView addSubview:self.urlLinkControl];
            [_controlBGView addSubview:self.upImageControl];
            
            /** StyleDefaultUI */
            CGFloat sendButtonWidth = 50;
            CGFloat sendButtonHeight = _inputView.bounds.size.height -2*XHInputView_StyleDefault_TBSpace-krlbInputView_Link_Height;
            _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleDefault_LRSpace - sendButtonWidth, XHInputView_StyleDefault_TBSpace+krlbInputView_Link_Height,sendButtonWidth, sendButtonHeight);
            [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_sendButton setBackgroundColor:[UIColor customDeepYellowColor]];
            [_sendButton setTitle:@"发表" forState:UIControlStateNormal];
            [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_inputView addSubview:_sendButton];
            
            _textView = [[UITextView alloc] initWithFrame:CGRectMake(XHInputView_StyleDefault_LRSpace, XHInputView_StyleDefault_TBSpace+krlbInputView_Link_Height, XHInputView_ScreenW - 3*XHInputView_StyleDefault_LRSpace - sendButtonWidth, self.inputView.bounds.size.height-2*XHInputView_StyleDefault_TBSpace-krlbInputView_Link_Height)];
            _textView.font = [UIFont systemFontOfSize:14];
            _textView.backgroundColor = [UIColor whiteColor];
            _textView.delegate = self;
            [_inputView addSubview:_textView];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:_textView];
            
            _placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _textView.bounds.size.width-14, _textView.bounds.size.height)];
            _placeholderLab.font = _textView.font;
            _placeholderLab.text = @"请输入...";
            _placeholderLab.textColor = [UIColor lightGrayColor];
            [_textView addSubview:_placeholderLab];
            
            _sendButtonFrameDefault = _sendButton.frame;
            _textViewFrameDefault = _textView.frame;
            _controlFrameDefault = _controlBGView.frame;
        }
            break;
        case RLBInputViewStyleReply:{
            
            _inputView.frame = CGRectMake(0, XHInputView_ScreenH, XHInputView_ScreenW, XHInputView_StyleDefault_Height+krlbInputView_Link_Height);
            
            /** StyleDefaultUI */
            CGFloat sendButtonWidth = 50;
            CGFloat sendButtonHeight = _inputView.bounds.size.height -2*XHInputView_StyleDefault_TBSpace-krlbInputView_Link_Height;
            _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleDefault_LRSpace - sendButtonWidth, XHInputView_StyleDefault_TBSpace+krlbInputView_Link_Height,sendButtonWidth, sendButtonHeight);
            [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_sendButton setBackgroundColor:[UIColor customDeepYellowColor]];
            [_sendButton setTitle:@"发表" forState:UIControlStateNormal];
            [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_inputView addSubview:_sendButton];
            
            _textView = [[UITextView alloc] initWithFrame:CGRectMake(XHInputView_StyleDefault_LRSpace, XHInputView_StyleDefault_TBSpace+krlbInputView_Link_Height, XHInputView_ScreenW - 3*XHInputView_StyleDefault_LRSpace - sendButtonWidth, self.inputView.bounds.size.height-2*XHInputView_StyleDefault_TBSpace-krlbInputView_Link_Height)];
            _textView.font = [UIFont systemFontOfSize:14];
            _textView.backgroundColor = [UIColor whiteColor];
            _textView.delegate = self;
            [_inputView addSubview:_textView];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:_textView];
            
            _placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _textView.bounds.size.width-14, _textView.bounds.size.height)];
            _placeholderLab.font = _textView.font;
            _placeholderLab.text = @"请输入...";
            _placeholderLab.textColor = [UIColor lightGrayColor];
            [_textView addSubview:_placeholderLab];
            
            _sendButtonFrameDefault = _sendButton.frame;
            _textViewFrameDefault = _textView.frame;
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_inputView]) {
        return NO;
    }
    if ([touch.view isDescendantOfView:_linkView]) {
        return NO;
    }
    return YES;
}
-(void)resetFrameDefault{
    self.inputView.frame = _showFrameDefault;
    self.sendButton.frame = _sendButtonFrameDefault;
    self.textView.frame =_textViewFrameDefault;
    
    [self changeLinkFrameWithOriginY:_inputView.frame.origin.y];
}
#pragma mark - textView delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    //没有输入时显示placeholder文本
    _placeholderLab.hidden = newString.length > 0;
    return YES;
}
-(void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *textField = (UITextView *)obj.object;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position){
        if (toBeString.length > _maxCount){
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_maxCount];
            if (rangeIndex.length == 1){
                textField.text = [toBeString substringToIndex:_maxCount];
            }
            else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maxCount)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}
#pragma mark - 调整位置2
-(void)textViewDidChange:(UITextView *)textView
{
    //让textview随行数自动改变自身的高度，超过135就不再增加
    CGFloat height = textView.contentSize.height+krlbInputView_Link_Height;
    CGFloat heightDefault = XHInputView_StyleDefault_Height+krlbInputView_Link_Height;
    if (height >= XHInputView_StyleLarge_Height+krlbInputView_Link_Height) {
        return;
    }
    if(height >= heightDefault){
        [UIView animateWithDuration:0.3 animations:^{
            //调整frame
            CGRect frame = _showFrameDefault;
            frame.size.height = height;
            frame.origin.y = _showFrameDefault.origin.y - (height - _showFrameDefault.size.height);
            _inputView.frame = frame;
            //调整sendButton frame
            _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleDefault_LRSpace - _sendButton.frame.size.width, _inputView.bounds.size.height - _sendButton.bounds.size.height - XHInputView_StyleDefault_TBSpace, _sendButton.bounds.size.width, _sendButton.bounds.size.height);
            //调整textView frame
            _textView.frame = CGRectMake(XHInputView_StyleDefault_LRSpace, XHInputView_StyleDefault_TBSpace+krlbInputView_Link_Height, _textView.bounds.size.width, _inputView.bounds.size.height - 2*XHInputView_StyleDefault_TBSpace-krlbInputView_Link_Height);
            
            [self changeLinkFrameWithOriginY:_inputView.frame.origin.y];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self resetFrameDefault];//恢复到,键盘弹出时,视图初始位置
        }];
    }
}

#pragma mark - Action
-(void)bgViewClick{
    [self hide];
}
-(void)sendButtonClick:(UIButton *)button{
    if(self.sendBlcok){
        if(_linkView != nil){
            self.urlLinkStr = [NSString stringWithFormat:@"%@",[_linkView getTextFieldStr]];
        }else{
            self.urlLinkStr = @"";
        }
        
        BOOL hideKeyBoard = self.sendBlcok(self.textView.text,self.urlLinkStr,self.selectedPhotos);
//        self.textView.text = @"";
        if(hideKeyBoard){
            [self hide];
        }
    }
}
#pragma mark - 监听键盘
- (void)keyboardWillAppear:(NSNotification *)noti{
    if(_textView.isFirstResponder || _linkView.urlTextField.isFirstResponder){
        
        NSDictionary *info = [noti userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect begin = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect end = [value CGRectValue];
        
        /*! 第三方键盘回调三次问题，监听仅执行最后一次 */
        if(begin.size.height > 0 && (begin.origin.y - end.origin.y != 0))
        {
            CGSize keyboardSize = [value CGRectValue].size;
            
            if([self.delegate respondsToSelector:@selector(rlbInputViewKeyboardWillShow:)]){
                [self.delegate rlbInputViewKeyboardWillShow:XHInputView_ScreenH - keyboardSize.height - self.inputView.frame.size.height];
            }
            
            //NSLog(@"keyboardSize.height = %f",keyboardSize.height);
            [UIView animateWithDuration:keyboardAnimationDuration animations:^{
                CGRect frame = self.inputView.frame;
                frame.origin.y = XHInputView_ScreenH - keyboardSize.height - frame.size.height;
                self.inputView.frame = frame;
                self.backgroundColor = XHInputView_BgViewColor;
                self.showFrameDefault = self.inputView.frame;
                [self changeLinkFrameWithOriginY:_inputView.frame.origin.y];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}
- (void)keyboardWillDisappear:(NSNotification *)noti{
    if(_textView.isFirstResponder || _linkView.urlTextField.isFirstResponder){
        
        if([self.delegate respondsToSelector:@selector(rlbInputViewKeyboardWillHide:)]){
            [self.delegate rlbInputViewKeyboardWillHide:self.inputView.frame.origin.y];
        }
        
        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
            CGRect frame = self.inputView.frame;
            frame.origin.y = XHInputView_ScreenH;
            self.inputView.frame = frame;
            self.backgroundColor = [UIColor clearColor];
            if (_linkView != nil) {
                CGRect frame = self.linkView.frame;
                frame.origin.y = XHInputView_ScreenH;
                self.linkView.frame = frame;
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - 懒加载
- (UIControl *)urlLinkControl{
    if (_urlLinkControl == nil && _style == RLBInputViewStyleDefault) {
        CGSize fatherSize = _controlBGView.frame.size;
        UIControl *urlControl = [[UIControl alloc]initWithFrame:CGRectMake((fatherSize.width-50)/4-50, 0, 100, krlbInputView_Link_Height)];
        [urlControl addTarget:self action:@selector(linkUrlControlClick:) forControlEvents:UIControlEventTouchUpInside];
        [_controlBGView addSubview:urlControl];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12, 20, 20)];
        imageV.image = [UIImage imageNamed:@"YX_QZ_Replylink"];
        [urlControl addSubview:imageV];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, 70, 25)];
        label.text = @"插入链接";
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor customTitleColor];
        [urlControl addSubview:label];
        
        _urlLinkControl = urlControl;
    }
    return _urlLinkControl;
}
- (UIControl *)upImageControl{
    if (_upImageControl == nil && _style == RLBInputViewStyleDefault) {
        CGSize fatherSize = _controlBGView.frame.size;
        UIControl *imageControl = [[UIControl alloc]initWithFrame:CGRectMake((fatherSize.width-50)*3/4-50, 0, 100, krlbInputView_Link_Height)];
        [imageControl addTarget:self action:@selector(linkUrlControlClick:) forControlEvents:UIControlEventTouchUpInside];
        [_controlBGView addSubview:imageControl];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12, 20, 20)];
        imageV.image = [UIImage imageNamed:@"YX_QZ_Replyimg"];
        [imageControl addSubview:imageV];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, 70, 25)];
        label.text = @"上传图片";
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor customTitleColor];
        [imageControl addSubview:label];
        
        _upImageControl = imageControl;
    }
    return _upImageControl;
}
#pragma mark - 两个按钮点击事件
- (void)linkUrlControlClick:(UIControl *)sender{
    if (sender == _urlLinkControl) {
        self.linkView.linkStyle = RLBInputLinkStyleUrl;
        [self changeLinkFrameWithOriginY:_inputView.frame.origin.y];
    }else if(sender == _upImageControl){
        if (self.selectedPhotos.count != 0) {
            return;
        }
        //调一下回调方法，将数据回调
        [self hide];
        if(self.selectImageBlock){
            self.selectImageBlock();
        }
    }
}

- (RLBInputLinkView *)linkView{
    if (_linkView == nil && _style == RLBInputViewStyleDefault) {
        RLBInputLinkView *linkView = [[RLBInputLinkView alloc]initWithFrame:CGRectMake(0, XHInputView_ScreenH, XHInputView_ScreenW, 0) selectedPhotos:self.selectedPhotos selectedAssets:self.selectedAssets urlLinkStr:self.urlLinkStr];
        WeakSelf
        linkView.removeTextFBlock = ^{
            StrongSelf
            [strongSelf.textView becomeFirstResponder];
        };
        linkView.removeImageBlock = ^{
            StrongSelf
            [strongSelf.selectedPhotos removeAllObjects];
            [strongSelf.selectedAssets removeAllObjects];
        };
        linkView.previewImageBlock = ^(NSMutableArray *photos, NSMutableArray *assets) {
            StrongSelf
            //调一下回调方法，将数据回调
            [strongSelf hide];
            if(strongSelf.previewImageBlock){
                strongSelf.previewImageBlock(photos, assets);
            }
        };
        [self addSubview:linkView];
        _linkView = linkView;
    }
    return _linkView;
}

#pragma mark - 调整link的位置
- (void)changeLinkFrameWithOriginY:(CGFloat)originY{
    CGRect linkFrame = self.linkView.frame;
    linkFrame.origin.y = originY;
    [self.linkView changeSelfViewOriginWithRect:linkFrame];
}

#pragma mark - set
-(void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
}
-(void)setTextViewBackgroundColor:(UIColor *)textViewBackgroundColor{
    _textViewBackgroundColor = textViewBackgroundColor;
    _textBgView.backgroundColor = textViewBackgroundColor;
}
-(void)setFont:(UIFont *)font{
    _font = font;
    _textView.font = font;
    _placeholderLab.font = _textView.font;
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _placeholderLab.text = placeholder;
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    _placeholderLab.textColor = placeholderColor;
    _countLab.textColor = placeholderColor;
}
-(void)setSendButtonBackgroundColor:(UIColor *)sendButtonBackgroundColor{
    _sendButtonBackgroundColor = sendButtonBackgroundColor;
    _sendButton.backgroundColor = sendButtonBackgroundColor;
}
-(void)setSendButtonTitle:(NSString *)sendButtonTitle{
    _sendButtonTitle = sendButtonTitle;
    [_sendButton setTitle:sendButtonTitle forState:UIControlStateNormal];
}
-(void)setSendButtonCornerRadius:(CGFloat)sendButtonCornerRadius{
    _sendButtonCornerRadius = sendButtonCornerRadius;
    _sendButton.layer.cornerRadius = sendButtonCornerRadius;
}
-(void)setSendButtonFont:(UIFont *)sendButtonFont{
    _sendButtonFont = sendButtonFont;
    _sendButton.titleLabel.font = sendButtonFont;
}


@end
