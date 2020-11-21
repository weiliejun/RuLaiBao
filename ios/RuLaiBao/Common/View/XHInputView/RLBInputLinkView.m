//
//  RLBInputLinkView.m
//  RuLaiBao
//
//  Created by qiu on 2018/11/13.
//  Copyright © 2018 junde. All rights reserved.
//

#import "RLBInputLinkView.h"

#define LinkView_Default_Space 5
#define LinkView_Default_TextHeight 35
#define LinkView_Default_ImageHeight 80

@interface RLBInputLinkView ()<UITextFieldDelegate>
@property (nonatomic, assign) CGRect rectSelf;

@property (nonatomic, assign, getter=isHadUrlLike) BOOL hasUrlLink;
@property (nonatomic, assign, getter=isHadImageLike) BOOL hasImageLink;

@property (nonatomic, weak) UITextField *urlTextField;
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation RLBInputLinkView
-(instancetype)initWithFrame:(CGRect)frame selectedPhotos:(NSMutableArray *)selectedPhotos selectedAssets:(NSMutableArray *)selectedAssets urlLinkStr:(NSString *)urlLinkStr{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _hasUrlLink = NO;
        _hasImageLink = NO;
        
        _rectSelf = frame;
        _selectedPhotos = selectedPhotos;
        _selectedAssets = selectedAssets;
        _urlLinkStr = urlLinkStr;
        
        [self setDefaultData];
    }
    return self;
}
#pragma mark - 设置默认数据
- (void)setDefaultData{
    if(_selectedPhotos.count == 0 && _urlLinkStr.length == 0){
        return;
    }
    if (_selectedPhotos.count != 0) {
        
        self.imageView.image = [self zipScaleWithImage:_selectedPhotos[0]];
        
        self.hasImageLink = YES;
    }
    if (_urlLinkStr.length != 0) {
        self.urlTextField.text = _urlLinkStr;
        self.hasUrlLink = YES;
        
    }
    [self changeFrameWithHasUrlAndHasImage];
}

#pragma mark - 更新位置
- (void)changeSelfViewOriginWithRect:(CGRect)rectSelf{
    _rectSelf = rectSelf;
    CGRect tempRect = rectSelf;
    tempRect.origin.y = rectSelf.origin.y - rectSelf.size.height;
    self.frame = tempRect;
}

#pragma mark - 设置
- (void)setLinkStyle:(RLBInputLinkStyle)linkStyle{
    _linkStyle = linkStyle;
    
    if (linkStyle == RLBInputLinkStyleUrl) {
        _hasUrlLink = !self.isHadUrlLike;
        
    }else if(linkStyle == RLBInputLinkStyleImage){
        _hasImageLink = !self.isHadImageLike;
    }
    [self changeFrameWithHasUrlAndHasImage];
}
- (void)changeFrameWithHasUrlAndHasImage{
    if (self.isHadUrlLike && !self.isHadImageLike) {
        //仅有链接
        self.frame = CGRectMake(_rectSelf.origin.x, _rectSelf.origin.y-2*LinkView_Default_Space-LinkView_Default_TextHeight, _rectSelf.size.width, 2*LinkView_Default_Space+ LinkView_Default_TextHeight);
        if (_imageView != nil) {
            [self.imageView removeFromSuperview];
        }
        self.urlTextField.frame = CGRectMake(5, LinkView_Default_Space, self.frame.size.width-10, LinkView_Default_TextHeight);
    }else if (!self.isHadUrlLike && self.isHadImageLike) {
        //仅有图片
        self.frame = CGRectMake(_rectSelf.origin.x, _rectSelf.origin.y-LinkView_Default_ImageHeight-LinkView_Default_Space*2, _rectSelf.size.width, LinkView_Default_ImageHeight+LinkView_Default_Space*2);
        self.imageView.frame = CGRectMake(5, LinkView_Default_Space, LinkView_Default_ImageHeight, LinkView_Default_ImageHeight);
        if (_urlTextField != nil) {
            if (self.removeTextFBlock) {
                self.removeTextFBlock();
            }
            [self.urlTextField removeFromSuperview];
        }
    }else if (self.isHadUrlLike && self.isHadImageLike) {
        _linkStyle = RLBInputLinkStyleAll;
        //两者都有
        self.frame = CGRectMake(_rectSelf.origin.x, _rectSelf.origin.y-LinkView_Default_Space*3-LinkView_Default_TextHeight-LinkView_Default_ImageHeight, _rectSelf.size.width, LinkView_Default_Space*3+LinkView_Default_TextHeight+LinkView_Default_ImageHeight);
        self.imageView.frame = CGRectMake(5, LinkView_Default_Space, LinkView_Default_ImageHeight, LinkView_Default_ImageHeight);
        self.urlTextField.frame = CGRectMake(5, LinkView_Default_ImageHeight + LinkView_Default_Space*2, self.frame.size.width-10, LinkView_Default_TextHeight);
    }else{
        //两者都无
        if (self.removeTextFBlock) {
            self.removeTextFBlock();
        }
        [self removeFromSuperview];
    }
}

#pragma mark - 得到textf的内容
/** 防止部分view错位 */
- (NSString *)getTextFieldStr{
    NSString *str = @"";
    if (_urlTextField != nil) {
        str = _urlTextField.text;
    }
    return str;
}

#pragma mark - 懒加载
- (UITextField *)urlTextField{
    if (_urlTextField == nil) {
        UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, LinkView_Default_TextHeight)];
//        textF.placeholder = @"输入链接";
        textF.font = [UIFont systemFontOfSize:14];
        textF.backgroundColor = [UIColor whiteColor];
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14]; // 设置font
        attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor]; // 设置颜色
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"输入链接" attributes:attrs]; // 初始化富文本占位字符串
        textF.attributedPlaceholder = attStr;
        
        textF.layer.borderWidth=1.0f;
        textF.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
        
        textF.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        textF.leftViewMode=UITextFieldViewModeAlways;
        
        textF.clearButtonMode = UITextFieldViewModeWhileEditing;
        textF.keyboardType = UIKeyboardTypeURL;
        textF.returnKeyType = UIReturnKeyDone;
        textF.delegate = self;
        [self addSubview:textF];
        _urlTextField = textF;
    }
    return _urlTextField;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, LinkView_Default_ImageHeight, LinkView_Default_ImageHeight)];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        [self addSubview:imageV];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [imageV addGestureRecognizer:tapGesture];
        imageV.userInteractionEnabled = YES;
        
        UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(LinkView_Default_ImageHeight-25, 0, 25, 25)];
        [imageBtn setBackgroundImage:[UIImage imageNamed:@"YX_QZ_Replyclose"] forState:UIControlStateNormal];
        [imageBtn addTarget:self action:@selector(imageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [imageV addSubview:imageBtn];
        
        _imageView = imageV;
    }
    return _imageView;
}
- (void)imageBtnClick{
    //block传值
    self.hasImageLink = NO;
    if (self.removeImageBlock) {
        self.removeImageBlock();
    }
    [self changeFrameWithHasUrlAndHasImage];
}

- (void)clickImage{
    if (self.previewImageBlock) {
        self.previewImageBlock(_selectedPhotos, _selectedAssets);
    }
}

#pragma mark - 转换图片d尺寸
- (UIImage *)zipScaleWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    
    NSLog(@">>>>>%f,%f",width,height);
    CGFloat scale = width/height;
    
    if (width > height) {
        height = LinkView_Default_ImageHeight;
        width = height*scale;
    }else{
        width = LinkView_Default_ImageHeight;
        height = width/scale;
    }
    
    NSLog(@"%f,%f<<<<<",width,height);
    //进行尺寸重绘
    UIImage* newImage = nil;
    @autoreleasepool{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, [[UIScreen mainScreen] scale]);
        [sourceImage drawInRect:CGRectMake(0,0,width,height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newImage;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.removeTextFBlock) {
        self.removeTextFBlock();
        return NO;
    }
    return YES;
}

- (void)dealloc{
    [self removeFromSuperview];
}

@end
