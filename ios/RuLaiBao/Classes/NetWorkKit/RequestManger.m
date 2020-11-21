 //
//  RequestManger.m
//  WeiJinKe
//
//  Created by mac2015 on 15/3/23.
//  Copyright (c) 2015年 mac2015. All rights reserved.
//

#import "RequestManger.h"
#import "DES3Util.h"
#import "NSString+MD5.h"
#import "Utils.h"

#import <AFNetworking.h>

/** 修改https位置 */

static BOOL PostHttp = NO;

@implementation RequestManger

+ (RequestManger *)Instance{
    static RequestManger *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
#pragma mark - get请求
- (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (SuccessBlock) successBlock
                  WithErrorCodeBlock: (ErrorBlock) errorBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:requestURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDic = responseObject;
        successBlock(jsonDic);
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        errorBlock(error);
    }];
}

#pragma mark - post请求加密
- (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (id) parameter
                 WithReturnValeuBlock: (SuccessBlock) successBlock
                   WithErrorCodeBlock: (ErrorBlock) errorBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
    [manager POST:requestURLString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSString *dataStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *Des3str1 = [DES3Util decrypt:dataStr];
        NSString *TipStr =Des3str1;
        NSData* xmlData = [TipStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *theError = nil;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:xmlData options:NSJSONReadingMutableContainers error:&theError];
        successBlock(jsonDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        errorBlock(error);
    }];
}

#pragma mark 上传图片
- (void) NetUpImgWithPostUrl:(NSString *)requestURLString
                     withImg:(UIImage *)Image
        WithReturnValeuBlock:(SuccessBlock)successBlock
          WithErrorCodeBlock:(ErrorBlock)errorBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    [manager POST:requestURLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /*
         * 该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        NSData *imageData = UIImagePNGRepresentation(Image);
        double scaleNum = (double)300*1024/imageData.length;
        NSLog(@"图片压缩率：%f",scaleNum);
        NSLog(@"图片大小:%ld",(unsigned long)imageData.length);
        if(scaleNum <1){
            imageData = UIImageJPEGRepresentation(Image, scaleNum);
        }else{
            imageData = UIImageJPEGRepresentation(Image, 0.1);
        }
        NSLog(@"压缩后图片大小:%ld",(unsigned long)imageData.length);
        //方法一： 直接上传图片  这个就是参数
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"123.png" mimeType:@"image/png"];
        //方法二：上传文件
        //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:ImageStr] name:@"photo" fileName:@"1234.png" mimeType:@"image/png" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度:%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        successBlock(jsonDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
}

#pragma mark - 轮播图
- (void)PostTopImageSuccess:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"appType\":\"%@\"}",@"ios"];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = @"";
//    NSString *urlstr = [NSString stringWithFormat:@"http://%@%@",RequestURL,@"/turn/advertise"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark - 上传头像

-(void)uploadImageFromImage:(UIImage *)image Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    
    //    NSString *tokenS =[Utils getToken];
    NSString *tokenS = @"dd155ee8-111f-4d6e-b303-7c2cddd5681e";
    NSData *tokenD = [tokenS dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Str =[GTMBase64 stringByEncodingData:tokenD];
    NSString *url = [NSString stringWithFormat:@"/account/photo/upload?token=%@",base64Str];
    NSString *urlstr = @"";
//    NSString *urlstr = [NSString stringWithFormat:@"http://%@%@",RequestURL,url];
    
    [self NetUpImgWithPostUrl:urlstr withImg:image WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
    
}

@end
