 //
//  RequestManger.m
//  WeiJinKe
//
//  Created by mac2015 on 15/3/23.
//  Copyright (c) 2015年 mac2015. All rights reserved.
//

#import "RequestManager.h"
#import "DES3Util.h"
#import "NSString+MD5.h"
#import "Configure.h"
#import "RLBOutLoginTool.h"

#import <AFNetworking.h>

@implementation RequestManager

+ (instancetype)sharedInstance{
    static RequestManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/*!
 注意⚠️(服务端报0002)：jsonInput 里面的参数应注意英文顺序，并区分大小写(大写在前，小写在后)⚠️
 */


#pragma mark - 登录 & 注册
-(void)postLoginUserTelNum:(NSString *)telNum UserPwd:(NSString *)userPwd Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"mobile\":\"%@\",\"password\":\"%@\"}",telNum,userPwd];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/ios/login"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark -- 注册
-(void)postRegisterUserTelNum:(NSString *)telNum ValidateCode:(NSString *)validateCode UserPwd:(NSString *)userPwd RealName:(NSString *)realName Area:(NSString *)area ParentRecommendCode:(NSString *)parentRecommendCode Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"area\":\"%@\",\"mobile\":\"%@\",\"parentRecommendCode\":\"%@\",\"password\":\"%@\",\"realName\":\"%@\",\"validateCode\":\"%@\"}",area,telNum,parentRecommendCode,userPwd,realName,validateCode];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/ios/register"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark -- 密码找回
-(void)postFindPasswordUserTelNum:(NSString *)telNum ValidateCode:(NSString *)validateCode NewPassword:(NSString *)userPwd Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"mobile\":\"%@\",\"newPassword\":\"%@\",\"validateCode\":\"%@\"}",telNum,userPwd,validateCode];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/password/find"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark -- 发短信
/*!
 业务类型：注册：register，密码找回：loginRet
 用户ID（注册、找回密码无）
 */
-(void)postMobileVerificationCodeWithUserId:(NSString *)userID Mobile:(NSString *)mobile BusiType:(NSString *)busiType Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"busiType\":\"%@\",\"mobile\":\"%@\",\"userId\":\"%@\"}",busiType,mobile,userID];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/user/mobile/send/verifycode"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

/** --------------------------我是分割线---------------------------------- */
#pragma mark - 首页
#pragma mark - 首页列表
-(void)postHomeListWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"userId\":\"%@\"}",userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/product/index/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 计划书
-(void)postProspectusListWithPage:(NSInteger)page companyName:(NSString *)companyName userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"companyName\":\"%@\",\"page\":\"%ld\",\"userId\":\"%@\"}",companyName,page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/product/prospectus/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 计划书搜索列表
-(void)postProSearchListWithName:(NSString *)name userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"name\":\"%@\",\"userId\":\"%@\"}",name,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/product/prospectus/nonsort/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 产品列表
-(void)postProductListWithPage:(NSInteger)page userId:(NSString *)userId category:(NSString *)category securityType:(NSString *)securityType Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"category\":\"%@\",\"page\":\"%ld\",\"securityType\":\"%@\",\"userId\":\"%@\"}",category,page,securityType,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/product/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 产品搜索列表
-(void)postProductSearchListWithKeyWord:(NSString *)keyWord userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"keyWord\":\"%@\",\"userId\":\"%@\"}",keyWord,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/product/nonsort/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 产品详情
-(void)postProductDetailWithId:(NSString *)Id userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"id\":\"%@\",\"userId\":\"%@\"}",Id,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
//    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/product/detail"];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/product/detail/other"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}




#pragma mark -- 添加预约
-(void)postAddAppointWithCompanyName:(NSString *)companyName exceptSubmitTime:(NSString *)exceptSubmitTime insuranceAmount:(NSString *)insuranceAmount insurancePeriod:(NSString *)insurancePeriod insurancePlan:(NSString *)insurancePlan mobile:(NSString *)mobile paymentPeriod:(NSString *)paymentPeriod periodAmount:(NSString *)periodAmount productCategory:(NSString *)productCategory productId:(NSString *)productId productName:(NSString *)productName remark:(NSString *)remark userId:(NSString *)userId userName:(NSString *)userName Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"companyName\":\"%@\",\"exceptSubmitTime\":\"%@\",\"insuranceAmount\":\"%@\",\"insurancePeriod\":\"%@\",\"insurancePlan\":\"%@\",\"mobile\":\"%@\",\"paymentPeriod\":\"%@\",\"periodAmount\":\"%@\",\"productCategory\":\"%@\",\"productId\":\"%@\",\"productName\":\"%@\",\"remark\":\"%@\",\"userId\":\"%@\",\"userName\":\"%@\"}",companyName,exceptSubmitTime,insuranceAmount,insurancePeriod,insurancePlan,mobile,paymentPeriod,periodAmount,productCategory,productId,productName,remark,userId,userName];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appointment/add"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}


/** -------------------------我是分割线----------------------------------- */
#pragma mark - 研修
#pragma mark -- 研修首页 - 课程推荐 + 精品课程 - 5
/*!
 首次进入_头部+精品课程
 */
-(void)postResearchIndexSuccess:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"appType\":\"%@\"}",@"ios"];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/research/index"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark -- 研修首页 - 热门问答
/*!
 热门问答
 */
-(void)postResearchQuestionHotListWithPage:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\"}",page];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/hot/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark -- 研修首页 - 换一换
/*!
 换一换
 */
-(void)postResearchChangeCourseWithPage:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\"}",page];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/research/change"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark -- 1 - 课程
#pragma mark --- 课程列表
/*!
 typeCode:课程类型编码（查询所有 不传）
 */
-(void)postCourseListWithPage:(NSInteger)page TypeCode:(NSString *)typeCode Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"typeCode\":\"%@\"}",page,typeCode];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCourse/index"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 课程详情-简介
-(void)postCourseDetailContentWithID:(NSString *)courseId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"id\":\"%@\"}",courseId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCourse/detail/content"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 课程详情-目录
/*!
 courseUserId ：课程演讲人id
 */
-(void)postCourseDetailContentWithPage:(NSInteger)page SpeechmakeId:(NSString *)SpeechmakeId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"speechmakeId\":\"%@\"}",page,SpeechmakeId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCourse/detail/outline"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 课程详情-研讨
/*!
 userId: 用户id(未登录时传空白)
 */
-(void)postCourseDetailCommenWithPage:(NSInteger)page CourseId:(NSString *)courseId UserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"courseId\":\"%@\",\"page\":\"%ld\",\"userId\":\"%@\"}",courseId,page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCourse/detail/comment"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 课程详情-研讨-新增评论回复
/*!
 toUserId:回复的目标用户id（注：当回复时需要，评论不需要传）
 commentId:所属评论的id（注：当回复时需要，评论不需要传）
 linkId：所属回复的id（注：当回复时需要，评论不需要传）
 */
-(void)postCourseDetailCommenAddWithCourseId:(NSString *)courseId CommentId:(NSString *)commentId LinkId:(NSString *)linkId CommentContent:(NSString *)commentContent UserId:(NSString *)userId ToUserId:(NSString *)toUserId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"commentContent\":\"%@\",\"commentId\":\"%@\",\"courseId\":\"%@\",\"linkId\":\"%@\",\"toUserId\":\"%@\",\"userId\":\"%@\"}",commentContent,commentId,courseId,linkId,toUserId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCourse/detail/comment/add"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 课程详情-PPT
-(void)postCourseDetailPPTWithCourseId:(NSString *)courseId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"id\":\"%@\"}",courseId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCourse/detail/ppt"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 2 - 问答
#pragma mark --- 问答列表-类型
-(void)postQAListTypeSuccess:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"appType\":\"%@\"}",@"ios"];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/type"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 问答列表
/*!
 appQuestionType:课程类型编码（查询所有 不传）
 */
-(void)postQAListWithPage:(NSInteger)page TypeCode:(NSString *)typeCode Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"appQuestionType\":\"%@\",\"page\":\"%ld\"}",typeCode,page];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 问答 - 问题详情
-(void)postQAQuestionDetailWithQuestionId:(NSString *)questionId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"questionId\":\"%@\"}",questionId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/detail"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 问答 - 问题详情 - 问答list
-(void)postQAQuestionDetailQuestionListWithUserID:(NSString *)userId QuestionId:(NSString *)questionId ListPage:(NSInteger)page SortType:(NSString *)sortType Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"questionId\":\"%@\",\"sortType\":\"%@\",\"userId\":\"%@\"}",page,questionId,sortType,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/appAnswer/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 问答 - 回答详情
-(void)postQAAnswerDetailWithUserID:(NSString *)userId QuestionId:(NSString *)questionId AnswerId:(NSString *)answerId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"answerId\":\"%@\",\"questionId\":\"%@\",\"userId\":\"%@\"}",answerId,questionId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/appAnswer/detail"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 问答 - 回答详情 - 评论列表
-(void)postQAAnswerDetailWithUserID:(NSString *)userId AnswerId:(NSString *)answerId ListPage:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"answerId\":\"%@\",\"page\":\"%ld\",\"userId\":\"%@\"}",answerId,page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/appAnswer/comment/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 问答 - 回答详情 -- 评论或回复
/*!
 toUserId:回复的目标用户id（注：当回复时需要，评论不需要传）
 commentId:所属评论的id（注：当回复时需要，评论不需要传）
 linkId:所属回复的id（注：当回复时需要，评论不需要传）
 */
-(void)postQAAnswerDetailCommentAddWithUserId:(NSString *)userId ToUserId:(NSString *)toUserId AnswerId:(NSString *)answerId CommentId:(NSString *)commentId LinkId:(NSString *)linkId CommentContent:(NSString *)commentContent Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"answerId\":\"%@\",\"commentContent\":\"%@\",\"commentId\":\"%@\",\"linkId\":\"%@\",\"toUserId\":\"%@\",\"userId\":\"%@\"}",answerId,commentContent,commentId,linkId,toUserId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/answer/comment"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 圈子详情 -- 话题点赞
-(void)postQAQuestionDetailLikeWithUserID:(NSString *)userId AnswerId:(NSString *)answerId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"answerId\":\"%@\",\"userId\":\"%@\"}",answerId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/answer/like"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 问答 -- 发布提问
-(void)postQAQuestionAddWithUserID:(NSString *)userId QuestionTypeCode:(NSString *)typeCode QuestionTitle:(NSString *)questionTitle QuestionDesc:(NSString *)questionDesc Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"questionDesc\":\"%@\",\"questionTitle\":\"%@\",\"typeCode\":\"%@\",\"userId\":\"%@\"}",questionDesc,questionTitle,typeCode,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/question"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 问答 -- 回答提问
-(void)postQAAnswerAddWithUserID:(NSString *)userId QuestionID:(NSString *)questionId AnswerContent:(NSString *)answerContent Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"answerContent\":\"%@\",\"questionId\":\"%@\",\"userId\":\"%@\"}",answerContent,questionId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/answer"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 3 - 圈子
#pragma mark --- 圈子列表
-(void)postGroupListWithUserID:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"userId\":\"%@\"}",userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCircle/index"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 圈子详情
-(void)postGroupDetailWithUserID:(NSString *)userId GroupId:(NSString *)circleId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"circleId\":\"%@\",\"userId\":\"%@\"}",circleId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCircle/detail"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 圈子详情 -- 话题list
-(void)postGroupDetailTopicListWithUserID:(NSString *)userId GroupId:(NSString *)circleId ListPage:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"circleId\":\"%@\",\"page\":\"%ld\",\"userId\":\"%@\"}",circleId,page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appTopic/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 圈子详情 -- 话题详情
-(void)postGroupTopicDetailWithUserID:(NSString *)userId TopicId:(NSString *)appTopicId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"appTopicId\":\"%@\",\"userId\":\"%@\"}",appTopicId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appTopic/detail"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 圈子详情 -- 评论列表
-(void)postGroupTopicDetailCommentListWithUserID:(NSString *)userId TopicId:(NSString *)appTopicId ListPage:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"appTopicId\":\"%@\",\"page\":\"%ld\",\"userId\":\"%@\"}",appTopicId,page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appTopic/comment/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 圈子详情 -- 评论或回复
/*!
 toUserId:回复的目标用户id（注：当回复时需要，评论不需要传）
 commentId:所属评论的id（注：当回复时需要，评论不需要传）
 linkId:所属评论的id（注：当回复时需要，评论不需要传）
 
 linkCommentUrl:评论链接（注：当评论是需要，回复不需要传）
 imgCommentUrl:评论图片地址（注：当评论是需要，回复不需要传）
 */
-(void)postGroupTopicDetailCommentAddWithAppTopicId:(NSString *)appTopicId CommentId:(NSString *)commentId LinkId:(NSString *)linkId CommentContent:(NSString *)commentContent UserId:(NSString *)userId ToUserId:(NSString *)toUserId LinkCommentUrl:(NSString *)linkCommentUrl ImgCommentUrl:(NSString *)imgCommentUrl Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"appTopicId\":\"%@\",\"commentContent\":\"%@\",\"commentId\":\"%@\",\"imgCommentUrl\":\"%@\",\"linkCommentUrl\":\"%@\",\"linkId\":\"%@\",\"toUserId\":\"%@\",\"userId\":\"%@\"}",appTopicId,commentContent,commentId,imgCommentUrl,linkCommentUrl,linkId,toUserId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appTopic/comment"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 圈子详情 -- 上传图片
-(void)postGroupTopicDetailUploadPhoto:(UIImage *)image TopicId:(NSString *)topicId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"photoType\":\"%@\",\"topicId\":\"%@\"}",@"commentPhoto",topicId];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:jsonInput forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/otherimage/upload"];
    [self NetUpImgWithPostUrl:urlstr withImg:image WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark --- 圈子详情 -- 话题点赞
-(void)postGroupTopicDetailLikeWithUserID:(NSString *)userId TopicId:(NSString *)appTopicId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"appTopicId\":\"%@\",\"userId\":\"%@\"}",appTopicId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appTopic/like"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 圈子详情 -- 话题置顶
-(void)postGroupTopicDetailSetTopWithUserID:(NSString *)userId CircleId:(NSString *)circleId TopicId:(NSString *)appTopicId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"appTopicId\":\"%@\",\"circleId\":\"%@\",\"userId\":\"%@\"}",appTopicId,circleId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appTopic/top"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 圈子详情 -- 发布话题
-(void)postGroupTopicAddWithUserID:(NSString *)userId CircleId:(NSString *)circleId Content:(NSString *)content Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"circleId\":\"%@\",\"content\":\"%@\",\"userId\":\"%@\"}",circleId,content,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appTopic/add"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 圈子详情 -- 圈子权限设置
-(void)postGroupTopicSetLimitWithUserID:(NSString *)userId CircleId:(NSString *)circleId AuditStatus:(NSString *)auditStatus Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"auditStatus\":\"%@\",\"circleId\":\"%@\",\"userId\":\"%@\"}",auditStatus,circleId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCircle/set"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 圈子详情 -- 申请加入圈子
-(void)postGroupDetailApplyJoinWithUserID:(NSString *)userId GroupId:(NSString *)circleId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"circleId\":\"%@\",\"userId\":\"%@\"}",circleId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCircle/apply/join"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark --- 圈子详情 -- 申请退出圈子
-(void)postGroupDetailApplyOutWithUserID:(NSString *)userId GroupId:(NSString *)circleId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"circleId\":\"%@\",\"userId\":\"%@\"}",circleId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCircle/apply/out"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}


/** -------------------------我是分割线----------------------------------- */
#pragma mark - 规划
#pragma mark -- 规划列表&搜索列表
-(void)postPlanSearchWithUserId:(NSString *)userId customerName:(NSString *)customerName Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"customerName\":\"%@\",\"userId\":\"%@\"}",customerName,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/order/plan/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}


/** --------------------------我是分割线---------------------------------- */
#pragma mark - 我的
#pragma mark -- 我的列表
-(void)postMyListWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"userId\":\"%@\"}",userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/index"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 个人信息
-(void)postInformationWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"userId\":\"%@\"}",userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/appUserInfo"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 提交认证
-(void)postSubmitWithIdNo:(NSString *)idNo position:(NSString *)position realName:(NSString *)realName userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"idNo\":\"%@\",\"position\":\"%@\",\"realName\":\"%@\",\"userId\":\"%@\"}",idNo,position,realName,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/appUserInfo/submit"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 上传图片（不加密）
/*头像-headPhoto，名片-cardPhoto，身份证正面-idNoPhoto*/
-(void)postSubmitWithPhoto:(NSString *)photo photoType:(NSString *)photoType userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"photoType\":\"%@\",\"userId\":\"%@\"}",photoType,userId];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:jsonInput forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/photo/upload"];
    
    [self NetUpImgWithPostUrl:urlstr withImgStr:photo WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 交易记录
-(void)postTradeListWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"userId\":\"%@\"}",page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/appTradeRecord/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 交易明细
-(void)postTradeDetailWithId:(NSString *)Id userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"id\":\"%@\",\"userId\":\"%@\"}",Id,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/appTradeRecord/detail"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}


#pragma mark -- 我的佣金
-(void)postCommissionWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"userId\":\"%@\"}",userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/commission/total"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 已发、待发佣金
-(void)postUnpayCommissionWithUserId:(NSString *)userId commissionStatus:(NSString *)commissionStatus page:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"commissionStatus\":\"%@\",\"page\":\"%ld\",\"userId\":\"%@\"}",commissionStatus,page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/commission/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 我的工资单月份
-(void)postSalaryYearWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"userId\":\"%@\"}",userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/userwagerecord/yearlist"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 我的工资单列表
-(void)postMySalaryListWithUserId:(NSString *)userId currentYear:(NSString *)currentYear page:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"currentYear\":\"%@\",\"page\":\"%ld\",\"userId\":\"%@\"}",currentYear,page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/userwagerecord/wagerecordlist"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 我的工资单详情
-(void)postSalaryDetailWithUserId:(NSString *)userId id:(NSString *)Id Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"id\":\"%@\",\"userId\":\"%@\"}",Id,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/userwagerecord/detail"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 佣金明细
-(void)postCommissionListWithUserId:(NSString *)userId page:(NSInteger)page currentMonth:(NSString *)currentMonth Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"currentMonth\":\"%@\",\"page\":\"%ld\",\"userId\":\"%@\"}",currentMonth,page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/appTradeRecord/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 佣金明细详情
-(void)postCommissionDetailWithId:(NSString *)Id Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"id\":\"%@\"}",Id];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/appTradeRecord/detail"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}


#pragma mark -- 我的银行卡列表
-(void)postMyBankCardWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"userId\":\"%@\"}",userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/userbankcard/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -  删除、设置工资卡
-(void)postDeleteBankCardWithId:(NSString *)Id userId:(NSString *)userId doType:(NSString *)doType Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"id\":\"%@\",\"userId\":\"%@\"}",Id,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@%@",DataHttp,RequestHeader,@"/account/userbankcard/to_",doType];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark - 新增银行卡
-(void)postAddBankCardWithBank:(NSString *)bank bankAddress:(NSString *)bankAddress bankcardNo:(NSString *)bankcardNo bankName:(NSString *)bankName idNo:(NSString *)idNo mobile:(NSString *)mobile realName:(NSString *)realName userId:(NSString *)userId validateCode:(NSString *)validateCode Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror {
    NSString *jsonInput = [NSString stringWithFormat:@"{\"bank\":\"%@\",\"bankAddress\":\"%@\",\"bankName\":\"%@\",\"bankcardNo\":\"%@\",\"idNo\":\"%@\",\"mobile\":\"%@\",\"realName\":\"%@\",\"userId\":\"%@\",\"validateCode\":\"%@\"}",bank,bankAddress,bankName,bankcardNo,idNo,mobile,realName,userId,validateCode];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/userbankcard/addsave"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 我的报单列表
-(void)postGuaranteeListWithPage:(NSInteger)page status:(NSString *)status userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"status\":\"%@\",\"userId\":\"%@\"}",(long)page,status,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/order/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 报单详情
-(void)postGuaranteeDetailWithOrderId:(NSString *)orderId userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"orderId\":\"%@\",\"userId\":\"%@\"}",orderId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/order/detail"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 续保提醒列表
-(void)postRenewListWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"userId\":\"%@\"}",page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/order/renewal/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 我的预约列表
-(void)postAppointListWithPage:(NSInteger)page auditStatus:(NSString *)auditStatus userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"auditStatus\":\"%@\",\"page\":\"%ld\",\"userId\":\"%@\"}",auditStatus,page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appointment/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 我的预约详情
-(void)postAppointDetailWithId:(NSString *)Id Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"id\":\"%@\"}",Id];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appointment/detail/"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 取消预约
-(void)postCancelAppointWithId:(NSString *)Id Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"id\":\"%@\"}",Id];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appointment/delete/"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark --我的提问
-(void)postMyAskedWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"userId\":\"%@\"}",page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/my/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark --我的话题列表
-(void)postMyTalkWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"userId\":\"%@\"}",page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appTopic/my/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark --我参与的提问列表
-(void)postMyTakepartAsklistWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"userId\":\"%@\"}",page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appQuestion/myJoin/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark --我参与的话题列表
-(void)postMyTakepartTalklistWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"userId\":\"%@\"}",page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appTopic/myJoin/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 我的收藏
-(void)postMyCollectionWithCategory:(NSString *)category page:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"category\":\"%@\",\"page\":\"%ld\",\"userId\":\"%@\"}",category,page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/collection/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 收藏，取消收藏
-(void)postCollectionWithDataStatus:(NSString *)dataStatus collectionId:(NSString *)collectionId productId:(NSString *)productId userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"collectionId\":\"%@\",\"dataStatus\":\"%@\",\"productId\":\"%@\",\"userId\":\"%@\"}",collectionId,dataStatus,productId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/collection/update"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark - 设置
#pragma mark -- 修改登录密码
-(void)postModifyPwdWithNewPassword:(NSString *)newPassword password:(NSString *)password UserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"newPassword\":\"%@\",\"password\":\"%@\",\"userId\":\"%@\"}",newPassword,password,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/set/password/modify"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 推荐给好友
-(void)postRecommendWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"userId\":\"%@\"}",userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/set/recommendAppTo"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 推荐记录
-(void)postRecordListWithUserId:(NSString *)userId page:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"userId\":\"%@\"}",page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/account/set/recommendList"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 联系客服
-(void)postCustomerServiceWithContent:(NSString *)content mobileNumber:(NSString *)mobileNumber userId:(NSString *)userId userName:(NSString *)userName Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"content\":\"%@\",\"mobileNumber\":\"%@\",\"userId\":\"%@\",\"userName\":\"%@\"}",content,mobileNumber,userId,userName];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/feedback/add"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 平台公告
-(void)postNoticeWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"userId\":\"%@\"}",page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/bulletin/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark -- 退出登录
-(void)postLogoffWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"userId\":\"%@\"}",userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/ios/logoff"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark -- 消息 - 未读数
-(void)postMessageUnreadCountWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"userId\":\"%@\"}",userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/message/type/count"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark -- 消息 - 佣金&保单 消息列表
-(void)postMessagebusiTypeListWithUserId:(NSString *)userId busiType:(NSString *)busiType PageNum:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"busiType\":\"%@\",\"page\":\"%ld\",\"userId\":\"%@\"}",busiType,page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/messages/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark -- 消息 - 圈子新成员
-(void)postMessageGroupApplyListWithUserId:(NSString *)userId PageNum:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"userId\":\"%@\"}",page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCircleApply/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark -- 消息 - 圈子新成员-同意申请
-(void)postMessageGroupApplyAgreeWithUserId:(NSString *)userId ApplyId:(NSString *)applyId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"applyId\":\"%@\",\"userId\":\"%@\"}",applyId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCircleApply/agree"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark -- 消息 - 圈子新成员 - 删除申请
-(void)postMessageGroupApplyDeleteWithUserId:(NSString *)userId ApplyId:(NSString *)applyId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"applyId\":\"%@\",\"userId\":\"%@\"}",applyId,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/appCircleApply/delete"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}
#pragma mark -- 消息 - 圈子新成员
-(void)postMessageUserInteractListWithUserId:(NSString *)userId PageNum:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror{
    NSString *jsonInput = [NSString stringWithFormat:@"{\"page\":\"%ld\",\"userId\":\"%@\"}",page,userId];
    //加密的签名
    NSString *md5str = [jsonInput VJK_md5String];
    NSString *lowermd5str = [md5str lowercaseString];
    NSString *jsonInputstr = [NSString stringWithFormat:@"{\"check\":\"%@\",\"data\":%@}",lowermd5str,jsonInput];
    //加密
    NSString *Des3str = [DES3Util encrypt:jsonInputstr];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:Des3str forKey:@"requestKey"];
    NSString *urlstr = [NSString stringWithFormat:@"%@://%@%@",DataHttp,RequestHeader,@"/userInteract/list"];
    
    [self NetRequestPOSTWithRequestURL:urlstr WithParameter:dict WithReturnValeuBlock:mysuccess WithErrorCodeBlock:myerror];
}

#pragma mark - 基本方法
#pragma mark -- get请求
- (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (SuccessBlock) successBlock
                  WithErrorCodeBlock: (ErrorBlock) errorBlock{
    
    AFHTTPSessionManager *manager = [RequestManager sharedManager];
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

#pragma mark --  post请求加密
- (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (id) parameter
                 WithReturnValeuBlock: (SuccessBlock) successBlock
                   WithErrorCodeBlock: (ErrorBlock) errorBlock{
    
    AFHTTPSessionManager *manager = [RequestManager sharedManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        });
    });
    
    [manager POST:requestURLString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSString *dataStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *Des3str1 = [DES3Util decrypt:dataStr];
        NSString *TipStr =Des3str1;
        NSData* xmlData = [TipStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *theError = nil;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:xmlData options:NSJSONReadingMutableContainers error:&theError];
        if ([jsonDic[@"code"] isEqualToString:@"9999"]) {
            [self errorInfoToOutLogin];
        }else{
            successBlock(jsonDic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        errorBlock(error);
    }];
}

#pragma mark --  上传图片
//上传文件
- (void) NetUpImgWithPostUrl:(NSString *)requestURLString
                 withImgStr:(NSString *)ImageStr
              WithParameter: (id) parameter
       WithReturnValeuBlock:(SuccessBlock)successBlock
         WithErrorCodeBlock:(ErrorBlock)errorBlock{
    
    AFHTTPSessionManager *manager = [RequestManager sharedManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 在parameters里存放照片以外的对象
    [manager POST:requestURLString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /** 该方法的参数
            1. appendPartWithFileURL：要上传的照片[二进制流]
            2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
            3. fileName：要保存在服务器上的文件名
            4. mimeType：上传的文件的类型*/
        //方法二：上传文件
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:ImageStr] name:@"photo" fileName:@"1234.png" mimeType:@"image/png" error:nil];
        
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

//直接上传图片
- (void) NetUpImgWithPostUrl:(NSString *)requestURLString
                     withImg:(UIImage *)Image
               WithParameter: (id) parameter
        WithReturnValeuBlock:(SuccessBlock)successBlock
          WithErrorCodeBlock:(ErrorBlock)errorBlock{
    
    AFHTTPSessionManager *manager = [RequestManager sharedManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 20.f;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    [manager POST:requestURLString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /*
         * 该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        NSData *imageData = UIImagePNGRepresentation(Image);
        NSLog(@"图片大小:%ld",(unsigned long)imageData.length);
        
        if (imageData.length>100*1024) {
            if (imageData.length>1024*1024) {//1M以及以上
                imageData=UIImageJPEGRepresentation(Image, 0.7);
            }else if (imageData.length>512*1024) {//0.5M-1M
                imageData=UIImageJPEGRepresentation(Image, 0.8);
            }else if (imageData.length>200*1024) {
                //0.25M-0.5M
                imageData=UIImageJPEGRepresentation(Image, 0.9);
            }
        }
        
        NSLog(@"压缩后图片大小:%ld",(unsigned long)imageData.length);
        //方法一： 直接上传图片  这个就是参数
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"topic.jpg" mimeType:@"image/jpg"];
        
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

#pragma mark - 创建AFHTTPSessionManager的单例
+ (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 初始化请求管理类
        manager = [AFHTTPSessionManager manager];
    });
    return manager;
}

#pragma mark - 判断网络是否可用
/*!
 此方法也可以在AppDelegate中使用，进行全局监听
 */
- (NetStatus)isNetCanUse{
    //检测网络
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //开启监听，记得开启，不然不走block
    [manger startMonitoring];
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown = -1,
         AFNetworkReachabilityStatusNotReachable = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G|4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                break;
            default:
                break;
        }
    }];
    return NetStatusWIFI;
}

-(void)errorInfoToOutLogin{
    [RLBOutLoginTool logOutUserInfo];
}
@end
