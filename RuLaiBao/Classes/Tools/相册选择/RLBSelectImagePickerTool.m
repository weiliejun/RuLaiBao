//
//  RLBSelectImagePickerTool.m
//  RuLaiBao
//
//  Created by qiu on 2018/11/14.
//  Copyright © 2018 junde. All rights reserved.
//

#import "RLBSelectImagePickerTool.h"
#import "TZImagePickerController.h"

@implementation RLBSelectImagePickerTool

+ (instancetype)sharedInstance{
    static RLBSelectImagePickerTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(void)selectImagePickerWithCurrentVC:(UIViewController *)currentVC selectAssetsArr:(NSMutableArray *)selectAssetsArr selectAssetBlock:(SelectAssetBlock)selectAssetBlock selectCancleBlock:(SelectCancelBlock)selectCancelBlock{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = selectAssetsArr; // 目前已经选中的图片数组
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    imagePickerVc.naviBgColor = [UIColor darkGrayColor];
    imagePickerVc.naviTitleColor = [UIColor whiteColor];
    imagePickerVc.barItemTextColor = [UIColor whiteColor];
    imagePickerVc.navigationBar.translucent = NO;
    
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSLog(@">>");
        selectAssetBlock(photos,assets);
    }];
    [imagePickerVc setImagePickerControllerDidCancelHandle:^{
        NSLog(@"<<<");
        selectCancelBlock();
    }];
    
    [currentVC presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)selectImagePickerToPreviewWithCurrentVC:(UIViewController *)currentVC selectAssetArr:(NSMutableArray *)selectAssetArr selectedPhotoArr:(NSMutableArray *)selectedPhotoArr selectAssetBlock:(SelectAssetBlock)selectAssetBlock selectCancleBlock:(SelectCancelBlock)selectCancelBlock{
     // preview photos /仅限于刚才选的 预览照片
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:selectAssetArr selectedPhotos:selectedPhotoArr index:0];
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingMultipleVideo = NO;
    imagePickerVc.showSelectedIndex = NO;
    imagePickerVc.isSelectOriginalPhoto = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        selectAssetBlock(photos,assets);
    }];
    [imagePickerVc setImagePickerControllerDidCancelHandle:^{
        selectCancelBlock();
    }];
    [currentVC presentViewController:imagePickerVc animated:YES completion:nil];
}
@end
