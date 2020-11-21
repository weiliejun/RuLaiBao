//
//  RLBSelectImagePickerTool.h
//  RuLaiBao
//
//  Created by qiu on 2018/11/14.
//  Copyright © 2018 junde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 选择 */
typedef void (^SelectAssetBlock)(NSArray<UIImage *> *photos,NSArray *assets);
/** 取消 */
typedef void (^SelectCancelBlock)(void);

@interface RLBSelectImagePickerTool : NSObject
+ (instancetype)sharedInstance;

- (void)selectImagePickerWithCurrentVC:(UIViewController *)currentVC selectAssetsArr:(NSMutableArray *)selectAssetsArr selectAssetBlock:(SelectAssetBlock)selectAssetBlock selectCancleBlock:(SelectCancelBlock)selectCancelBlock;

- (void)selectImagePickerToPreviewWithCurrentVC:(UIViewController *)currentVC selectAssetArr:(NSMutableArray *)selectAssetArr selectedPhotoArr:(NSMutableArray *)selectedPhotoArr selectAssetBlock:(SelectAssetBlock)selectAssetBlock selectCancleBlock:(SelectCancelBlock)selectCancelBlock;
@end
