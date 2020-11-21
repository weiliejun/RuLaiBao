//
//  RequestManger.h
//  WeiJinKe
//
//  Created by mac2015 on 15/3/23.
//  Copyright (c) 2015年 mac2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NetStatus) {
    NetStatusWIFI = 10010,//WIFI
    NetStatusWLAN        ,//WLAN
    NetStatusNONET        //No
};

/** 成功 */
typedef void (^SuccessBlock)(id responseData);
/** 错误 */
typedef void (^ErrorBlock)(NSError *error);
/** 网络 */
typedef void (^NetStatusBlock)(NetStatus netStatus);

@interface RequestManager : NSObject

#pragma mark - 单例对象,用于调用网络请求方法
+ (instancetype)sharedInstance;

/** --------------------------我是分割线---------------------------------- */
#pragma mark - 登录 & 注册
-(void)postLoginUserTelNum:(NSString *)telNum UserPwd:(NSString *)userPwd Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 注册
-(void)postRegisterUserTelNum:(NSString *)telNum ValidateCode:(NSString *)validateCode UserPwd:(NSString *)userPwd RealName:(NSString *)realName Area:(NSString *)area ParentRecommendCode:(NSString *)parentRecommendCode Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 密码找回
-(void)postFindPasswordUserTelNum:(NSString *)telNum ValidateCode:(NSString *)validateCode NewPassword:(NSString *)userPwd Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 发短信
-(void)postMobileVerificationCodeWithUserId:(NSString *)userID Mobile:(NSString *)mobile BusiType:(NSString *)busiType Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

/** --------------------------我是分割线---------------------------------- */
#pragma mark - 首页
#pragma mark - 首页列表
-(void)postHomeListWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 计划书
-(void)postProspectusListWithPage:(NSInteger)page companyName:(NSString *)companyName userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 计划书搜索列表
-(void)postProSearchListWithName:(NSString *)name userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 产品列表
-(void)postProductListWithPage:(NSInteger)page userId:(NSString *)userId category:(NSString *)category securityType:(NSString *)securityType Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 产品搜索列表
-(void)postProductSearchListWithKeyWord:(NSString *)keyWord userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 产品详情
-(void)postProductDetailWithId:(NSString *)Id userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 添加预约
-(void)postAddAppointWithCompanyName:(NSString *)companyName exceptSubmitTime:(NSString *)exceptSubmitTime insuranceAmount:(NSString *)insuranceAmount insurancePeriod:(NSString *)insurancePeriod insurancePlan:(NSString *)insurancePlan mobile:(NSString *)mobile paymentPeriod:(NSString *)paymentPeriod periodAmount:(NSString *)periodAmount productCategory:(NSString *)productCategory productId:(NSString *)productId productName:(NSString *)productName remark:(NSString *)remark userId:(NSString *)userId userName:(NSString *)userName Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;


/** --------------------------我是分割线---------------------------------- */
#pragma mark - 研修
#pragma mark -- 研修首页 - 课程推荐 + 精品课程 - 5
-(void)postResearchIndexSuccess:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 研修首页 - 热门问答
-(void)postResearchQuestionHotListWithPage:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 研修首页 - 换一换
-(void)postResearchChangeCourseWithPage:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -- 1 - 课程
#pragma mark --- 课程列表
-(void)postCourseListWithPage:(NSInteger)page TypeCode:(NSString *)typeCode Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 课程详情-简介
-(void)postCourseDetailContentWithID:(NSString *)courseId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 课程详情-目录
-(void)postCourseDetailContentWithPage:(NSInteger)page SpeechmakeId:(NSString *)SpeechmakeId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 课程详情-研讨
-(void)postCourseDetailCommenWithPage:(NSInteger)page CourseId:(NSString *)courseId UserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 课程详情-研讨-新增评论回复
-(void)postCourseDetailCommenAddWithCourseId:(NSString *)courseId CommentId:(NSString *)commentId LinkId:(NSString *)linkId CommentContent:(NSString *)commentContent UserId:(NSString *)userId ToUserId:(NSString *)toUserId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 课程详情-PPT
-(void)postCourseDetailPPTWithCourseId:(NSString *)courseId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -- 2 - 问答
#pragma mark --- 课程列表-类型
-(void)postQAListTypeSuccess:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 课程列表
-(void)postQAListWithPage:(NSInteger)page TypeCode:(NSString *)typeCode Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 问答 - 问题详情
-(void)postQAQuestionDetailWithQuestionId:(NSString *)questionId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 问答 - 问题详情 - 问答list
-(void)postQAQuestionDetailQuestionListWithUserID:(NSString *)userId QuestionId:(NSString *)questionId ListPage:(NSInteger)page SortType:(NSString *)sortType Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 问答 - 回答详情
-(void)postQAAnswerDetailWithUserID:(NSString *)userId QuestionId:(NSString *)questionId AnswerId:(NSString *)answerId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 问答 - 回答详情 - 评论列表
-(void)postQAAnswerDetailWithUserID:(NSString *)userId AnswerId:(NSString *)answerId ListPage:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 问答 - 回答详情 -- 评论或回复
-(void)postQAAnswerDetailCommentAddWithUserId:(NSString *)userId ToUserId:(NSString *)toUserId AnswerId:(NSString *)answerId CommentId:(NSString *)commentId LinkId:(NSString *)linkId CommentContent:(NSString *)commentContent Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 问答 - 回答详情 -- 话题点赞
-(void)postQAQuestionDetailLikeWithUserID:(NSString *)userId AnswerId:(NSString *)answerId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 问答 -- 发布提问
-(void)postQAQuestionAddWithUserID:(NSString *)userId QuestionTypeCode:(NSString *)typeCode QuestionTitle:(NSString *)questionTitle QuestionDesc:(NSString *)questionDesc Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 问答 -- 回答提问
-(void)postQAAnswerAddWithUserID:(NSString *)userId QuestionID:(NSString *)questionId AnswerContent:(NSString *)answerContent Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -- 3 - 圈子
#pragma mark --- 圈子列表
-(void)postGroupListWithUserID:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 圈子详情
-(void)postGroupDetailWithUserID:(NSString *)userId GroupId:(NSString *)circleId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 圈子详情 -- 话题list
-(void)postGroupDetailTopicListWithUserID:(NSString *)userId GroupId:(NSString *)circleId ListPage:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 圈子详情 -- 话题详情
-(void)postGroupTopicDetailWithUserID:(NSString *)userId TopicId:(NSString *)appTopicId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 圈子详情 -- 评论列表
-(void)postGroupTopicDetailCommentListWithUserID:(NSString *)userId TopicId:(NSString *)appTopicId ListPage:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 圈子详情 -- 评论或回复
-(void)postGroupTopicDetailCommentAddWithAppTopicId:(NSString *)appTopicId CommentId:(NSString *)commentId LinkId:(NSString *)linkId CommentContent:(NSString *)commentContent UserId:(NSString *)userId ToUserId:(NSString *)toUserId LinkCommentUrl:(NSString *)linkCommentUrl ImgCommentUrl:(NSString *)imgCommentUrl Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 圈子详情 -- 上传图片
-(void)postGroupTopicDetailUploadPhoto:(UIImage *)image TopicId:(NSString *)topicId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 圈子详情 -- 话题点赞
-(void)postGroupTopicDetailLikeWithUserID:(NSString *)userId TopicId:(NSString *)appTopicId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 圈子详情 -- 话题置顶
-(void)postGroupTopicDetailSetTopWithUserID:(NSString *)userId CircleId:(NSString *)circleId TopicId:(NSString *)appTopicId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 圈子详情 -- 发布话题
-(void)postGroupTopicAddWithUserID:(NSString *)userId CircleId:(NSString *)circleId Content:(NSString *)content Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 圈子详情 -- 圈子权限设置
-(void)postGroupTopicSetLimitWithUserID:(NSString *)userId CircleId:(NSString *)circleId AuditStatus:(NSString *)auditStatus Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 圈子详情 -- 申请加入圈子
-(void)postGroupDetailApplyJoinWithUserID:(NSString *)userId GroupId:(NSString *)circleId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --- 圈子详情 -- 申请退出圈子
-(void)postGroupDetailApplyOutWithUserID:(NSString *)userId GroupId:(NSString *)circleId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;


/** -------------------------我是分割线----------------------------------- */
#pragma mark - 规划
#pragma mark -- 规划列表&搜索列表
-(void)postPlanSearchWithUserId:(NSString *)userId customerName:(NSString *)customerName Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;


/** --------------------------我是分割线---------------------------------- */
#pragma mark - 我的
#pragma mark -- 我的列表
-(void)postMyListWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 个人信息
-(void)postInformationWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 提交认证
-(void)postSubmitWithIdNo:(NSString *)idNo position:(NSString *)position realName:(NSString *)realName userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 上传图片（不加密）
-(void)postSubmitWithPhoto:(NSString *)photo photoType:(NSString *)photoType userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 交易记录
-(void)postTradeListWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 交易明细
-(void)postTradeDetailWithId:(NSString *)Id userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -- 我的佣金
-(void)postCommissionWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -- 已发、待发佣金
-(void)postUnpayCommissionWithUserId:(NSString *)userId commissionStatus:(NSString *)commissionStatus page:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -- 我的工资单月份
-(void)postSalaryYearWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -- 我的工资单列表
-(void)postMySalaryListWithUserId:(NSString *)userId currentYear:(NSString *)currentYear page:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -- 我的工资单详情
-(void)postSalaryDetailWithUserId:(NSString *)userId id:(NSString *)Id Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -- 佣金明细
-(void)postCommissionListWithUserId:(NSString *)userId page:(NSInteger)page currentMonth:(NSString *)currentMonth Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -- 佣金明细详情
-(void)postCommissionDetailWithId:(NSString *)Id Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;


#pragma mark -- 我的银行卡列表
-(void)postMyBankCardWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -  删除、设置工资卡
-(void)postDeleteBankCardWithId:(NSString *)Id userId:(NSString *)userId doType:(NSString *)doType Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark - 新增银行卡
-(void)postAddBankCardWithBank:(NSString *)bank bankAddress:(NSString *)bankAddress bankcardNo:(NSString *)bankcardNo bankName:(NSString *)bankName idNo:(NSString *)idNo mobile:(NSString *)mobile realName:(NSString *)realName userId:(NSString *)userId validateCode:(NSString *)validateCode Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;


#pragma mark -- 我的报单列表
-(void)postGuaranteeListWithPage:(NSInteger)page status:(NSString *)status userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 天安添加保单
-(void)postGuaranteeAddUserId:(NSString *)userId PolicyHolder:(NSString *)policyHolder OrderCode:(NSString *)orderCode Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 报单详情
-(void)postGuaranteeDetailWithOrderId:(NSString *)orderId userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 续保提醒列表
-(void)postRenewListWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 我的预约列表
-(void)postAppointListWithPage:(NSInteger)page auditStatus:(NSString *)auditStatus userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 我的预约详情
-(void)postAppointDetailWithId:(NSString *)Id Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 取消预约
-(void)postCancelAppointWithId:(NSString *)Id Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --我的提问列表
-(void)postMyAskedWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --我的话题列表
-(void)postMyTalkWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --我参与的提问列表
-(void)postMyTakepartAsklistWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark --我参与的话题列表
-(void)postMyTakepartTalklistWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 我的收藏
-(void)postMyCollectionWithCategory:(NSString *)category page:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 收藏，取消收藏
-(void)postCollectionWithDataStatus:(NSString *)dataStatus collectionId:(NSString *)collectionId productId:(NSString *)productId userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark - 设置
#pragma mark -- 修改登录密码
-(void)postModifyPwdWithNewPassword:(NSString *)newPassword password:(NSString *)password UserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 推荐给好友
-(void)postRecommendWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 推荐记录
-(void)postRecordListWithUserId:(NSString *)userId page:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 联系客服
-(void)postCustomerServiceWithContent:(NSString *)content mobileNumber:(NSString *)mobileNumber userId:(NSString *)userId userName:(NSString *)userName Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 平台公告
-(void)postNoticeWithPage:(NSInteger)page userId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -- 退出登录
-(void)postLogoffWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;

#pragma mark -- 消息 - 未读数
-(void)postMessageUnreadCountWithUserId:(NSString *)userId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 消息 - 佣金&保单 消息列表
-(void)postMessagebusiTypeListWithUserId:(NSString *)userId busiType:(NSString *)busiType PageNum:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 消息 - 圈子新成员
-(void)postMessageGroupApplyListWithUserId:(NSString *)userId PageNum:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 消息 - 圈子新成员-同意申请
-(void)postMessageGroupApplyAgreeWithUserId:(NSString *)userId ApplyId:(NSString *)applyId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 消息 - 圈子新成员 - 删除申请
-(void)postMessageGroupApplyDeleteWithUserId:(NSString *)userId ApplyId:(NSString *)applyId Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
#pragma mark -- 消息 - 圈子新成员
-(void)postMessageUserInteractListWithUserId:(NSString *)userId PageNum:(NSInteger)page Success:(SuccessBlock)mysuccess Error:(ErrorBlock)myerror;
@end
