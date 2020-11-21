//
//  RLBInputLinkView.h
//  RuLaiBao
//
//  Created by qiu on 2018/11/13.
//  Copyright © 2018 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RLBInputLinkStyle) {
    RLBInputLinkStyleUrl,
    RLBInputLinkStyleImage,
    RLBInputLinkStyleAll,
};

/** 用于解决键盘响应事件 */
typedef void(^TextFieldWillRemoveBlock)(void);
typedef void(^ImageViewWillRemoveBlock)(void);
typedef void(^ImageViewDidPreviewBlock)(NSMutableArray *photos,NSMutableArray *assets);

@interface RLBInputLinkView : UIView

@property (nonatomic, assign) RLBInputLinkStyle linkStyle;

@property (nonatomic, weak, readonly) UITextField *urlTextField;

@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, copy) NSString *urlLinkStr;

@property (nonatomic, copy) TextFieldWillRemoveBlock removeTextFBlock;
@property (nonatomic, copy) ImageViewWillRemoveBlock removeImageBlock;
@property (nonatomic, copy) ImageViewDidPreviewBlock previewImageBlock;

-(instancetype)initWithFrame:(CGRect)frame selectedPhotos:(NSMutableArray *)selectedPhotos selectedAssets:(NSMutableArray *)selectedAssets urlLinkStr:(NSString *)urlLinkStr;

- (void)changeSelfViewOriginWithRect:(CGRect)rectSelf;
- (NSString *)getTextFieldStr;
@end

