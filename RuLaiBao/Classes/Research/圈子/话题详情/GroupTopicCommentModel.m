//
//  GroupTopicCommentModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/3.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "GroupTopicCommentModel.h"
#import "Configure.h"
#import "NSString+Custom.h"
#import "TYAttributedLabel.h"
#import "ReplyModel.h"

#define kPhotoHeight 100

@implementation GroupTopicCommentModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.commentId       = dic[@"commentId"];
        self.commentName     = dic[@"commentName"];
        self.commentPhoto    = dic[@"commentPhoto"];
        
        self.cid             = dic[@"cid"];
        self.commentContent  = dic[@"commentContent"];
        self.commentTime     = dic[@"commentTime"];
        self.replys =[self processReplyArr:dic[@"replys"]];
        
        self.commentLinkUrl = dic[@"linkCommentUrl"];
        self.commentLinkPhoto = dic[@"imgCommentUrlSmall"];
        self.commentLinkPhotoBig = dic[@"imgCommentUrlBig"];
       
        self.commentTextContainer = [self creatCommentTextContainerWithCommentContent:self.commentContent commentLinkUrl:self.commentLinkUrl commentLinkPhoto:self.commentLinkPhoto];
        
        self.textContainers =[self addReplyToTableViewItemS:self.replys];
        
        //算text的layout
        CGFloat height = self.commentTextContainer.textHeight + 1;
        CGFloat textHeight = height > 30 ? height : 30;
        
        self.frameLayout = CGRectMake(10, 10+40+10, Width_Window-20, textHeight);
        //增加imageview的size
        
        CGFloat photoViewHeight = 0.0;
        
        NSString *tmpPhotoSize = [NSString stringWithFormat:@"{%@,%@}",dic[@"imgCommentWidth"],dic[@"imgCommentHeight"]];
        CGSize photoSize = [self convertPhotoRect: CGSizeFromString(tmpPhotoSize)];
        
        if (!CGSizeEqualToSize(photoSize, CGSizeZero) && self.commentLinkPhoto.length != 0) {
            self.commentPhotoRect = CGRectMake(10, 10+40+10+textHeight+10, photoSize.width, photoSize.height);
            photoViewHeight = photoSize.height+10;
        }else{
            self.commentPhotoRect = CGRectZero;
            photoViewHeight = 0.0;
        }
        
        self.headerHeight = self.frameLayout.origin.y+self.frameLayout.size.height +photoViewHeight+5+30+5;
        
    }
    return self;
}
-(NSArray *)processReplyArr:(NSArray *)arr{
    NSMutableArray *tmp1 = [NSMutableArray array];
    for (NSDictionary *dict1 in arr) {
        ReplyModel *infoModel = [[ReplyModel alloc]initReplyModelWithDic:dict1];
        [tmp1 addObject:infoModel];
    }
    return [tmp1 copy];
}

- (NSArray *)addReplyToTableViewItemS:(NSArray *)replyArr{
    NSMutableArray *tmp = [NSMutableArray array];
    
    for (NSInteger i = 0; i < replyArr.count; ++i) {
        [tmp addObject:[self creatTextContainer:replyArr[i]]];
    }
    return [tmp copy];
}

- (TYTextContainer *)creatTextContainer:(ReplyModel *)model{
    NSString *replyNameStr = [NSString stringWithFormat:@"%@",model.replyName];
    NSString *replyToNameStr = [NSString stringWithFormat:@"%@",model.replyToName];
    NSString *text = [NSString stringWithFormat:@"%@回复%@：%@",replyNameStr,replyToNameStr,model.replyContent];
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    textContainer.font = [UIFont systemFontOfSize:16.0];
    textContainer.textColor = [UIColor customTitleColor];
    textContainer.linesSpacing = 2;
    
    NSDictionary *linkData = @{@"toUserId":model.replyId,@"toUserName":replyNameStr};
    NSRange Range1 = NSMakeRange(0, replyNameStr.length);
    NSDictionary *linkToData = @{@"toUserId":model.replyToId,@"toUserName":replyToNameStr};
    NSRange Range2 = NSMakeRange(replyNameStr.length+2, replyToNameStr.length);

    [textContainer addLinkWithLinkData:linkData linkColor:[UIColor customNavBarColor] underLineStyle:kCTUnderlineStyleNone range:Range1];
    [textContainer addLinkWithLinkData:linkToData linkColor:[UIColor customNavBarColor] underLineStyle:kCTUnderlineStyleNone range:Range2];
    
    textContainer = [textContainer createTextContainerWithTextWidth:Width_Window-30];
    return textContainer;
}

#pragma mark - 处理回复数据
/*!
 在此方法中处理回复的model
 1、取出fatherModel中的回复数组tempArr
 2、添加replyModel到数组tempArr中
 3、将tempArr替换到fatherModel中
 */
-(instancetype)handleModelWith:(ReplyModel *)replyModel fatherModel:(GroupTopicCommentModel *)fatherModel{
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:fatherModel.replys];
    [tempArr addObject:replyModel];
    fatherModel.replys = tempArr;
    fatherModel.textContainers =[self addReplyToTableViewItemS:tempArr];
    return fatherModel;
}

#pragma mark - 处理评论的数据
//将评论的文字、url以及图片加以整合
- (TYTextContainer *)creatCommentTextContainerWithCommentContent:(NSString *)commentContent commentLinkUrl:(NSString *)commentLinkUrl commentLinkPhoto:(NSString *)commentLinkPhoto{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = commentContent;
    textContainer.numberOfLines = 0;
    textContainer.font = [UIFont systemFontOfSize:16.0];
    textContainer.textColor = [UIColor customTitleColor];
    textContainer.textAlignment = kCTTextAlignmentLeft;
    textContainer.linesSpacing = 3.0;
    
    if (commentLinkUrl.length != 0) {
        //追加url
        [textContainer appendText:@"\n"];
        [textContainer appendLinkWithText:commentLinkUrl linkFont:[UIFont systemFontOfSize:15] linkColor:[UIColor customBlueColor] linkData:[self converWebHostWithOldUrl:commentLinkUrl]];
    }
    
//    if (commentLinkPhoto.length != 0) {
//        // 追加图片  此种方法无法分离image的填充效果  故暂且不用
//        [textContainer appendText:@"\n"];
//        TYImageStorage *imageUrlStorage = [[TYImageStorage alloc]init];
//        //        imageUrlStorage.imageURL = [NSURL URLWithString:commentLinkPhoto];
//        UIImage *imageTmp =[self zipScaleWithImage:[UIImage imageNamed:@"1.jpg"]];
//        imageUrlStorage.image =imageTmp;
//        imageUrlStorage.placeholdImageName = @"";
//        imageUrlStorage.size = CGSizeMake(imageTmp.size.width, imageTmp.size.height);
//        [textContainer appendTextStorage:imageUrlStorage];
//    }
    
    
    textContainer = [textContainer createTextContainerWithTextWidth:Width_Window-20];
    return textContainer;
}

#pragma mark - 转换web url
//对urlStr进行添加http头
- (NSString *)converWebHostWithOldUrl:(NSString *)urlStr{
    NSString *returnUrlStr = nil;
    NSString *scheme = nil;
    
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (urlStr != nil) && (urlStr.length != 0) ) {
        NSRange  urlRange = [urlStr rangeOfString:@"://"];
        if (urlRange.location == NSNotFound) {
            returnUrlStr = [NSString stringWithFormat:@"http://%@", urlStr];
        } else {
            scheme = [urlStr substringWithRange:NSMakeRange(0, urlRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                returnUrlStr = urlStr;
            } else {
                //不支持的URL方案
                returnUrlStr = urlStr;
            }
        }
    }
    return returnUrlStr;
}

-(CGSize)convertPhotoRect:(CGSize)photoSize{
    /*!
     W:H = 0.5 100:150 (eg: 100:1000那么就设置为标准宽度，其他省略)
     W:H = 2   150:100 (eg: 1000:100那么就设置为标准高度，其他省略)
     在其中间 谁小按照谁来s等比例缩小 (eg: 110:200 那么就按照100:n来实现 得出大概为100:188左右)
     */
    
    if (photoSize.width == 0 || photoSize.height == 0) {
        return CGSizeZero;
    }
    CGFloat width = photoSize.width;    //图片宽度
    CGFloat height = photoSize.height;  //图片高度
    
    NSLog(@">>>>>%f,%f",width,height);
    CGFloat scale = width/height;
    
    if(scale < 0.5){
        width = kPhotoHeight;
        height = 150;
    }else if(scale > 2){
        height = kPhotoHeight;
        width = 150;
    }else{
        if (width>height) {
            height = kPhotoHeight;
            width = height*scale;
        }else{
            width = kPhotoHeight;
            height = width/scale;
        }
    }
    
    NSLog(@"%f,%f<<<<<",width,height);
    return CGSizeMake(width, height);
    
}
- (UIImage *)zipScaleWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    
    NSLog(@">>>>>%f,%f",width,height);
    CGFloat scale = width/height;
    
    if(scale < 0.5){
        width = kPhotoHeight;
        height = 200;
    }else if(scale > 2){
        height = kPhotoHeight;
        width = 200;
    }else{
        if (width>height) {
            width = kPhotoHeight;
            height = width/scale;
        }else{
            height = kPhotoHeight;
            width = height*scale;
        }
    }
    
    NSLog(@"%f,%f<<<<<",width,height);
    //进行尺寸重绘
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, [[UIScreen mainScreen] scale]);
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
