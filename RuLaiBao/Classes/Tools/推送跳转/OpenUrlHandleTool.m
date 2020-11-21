//
//  OpenUrlHandleTool.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/10.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "OpenUrlHandleTool.h"
#import "Configure.h"
#import "AppDelegate.h"
#import "MainNavigationController.h"
#import "MainTabBarController.h"

/** 保险产品详情 */
//#import "InsuranceDetailViewController.h"
#import "NewDetailViewController.h"

/** 课程详情 */
#import "CourseDetailViewController.h"
/** 问题详情 */
#import "QADetailViewController.h"
/** 回答详情 */
#import "AnswerDetailViewController.h"
/** 话题详情 */
#import "GroupTopicViewController.h"

@implementation OpenUrlHandleTool
/*!
 1、在此处需处理判断传进来的url是否合法，并且在本地是否配置
 2、分析处理跳转方式：push || present，并处理传进来的参数
 */
+ (void)jumpControllerWithRemoteURL:(NSURL *)remoteUrl{
    //链接
    if ([remoteUrl.host isEqualToString:@"com.rulaibao"] && [remoteUrl.path isEqualToString:@"/detail"]) {
        NSLog(@"%@>><<",remoteUrl.query);
        
        NSMutableDictionary *allPartDict = [NSMutableDictionary dictionaryWithCapacity:5];
        NSMutableArray *partArr = [NSMutableArray arrayWithCapacity:5];
        NSArray *temp = [remoteUrl.query componentsSeparatedByString:@"&"];
        for (int i=0; i<temp.count; i++) {
            NSString *litterPartStr = temp[i];
            NSArray *temp = [litterPartStr componentsSeparatedByString:@"="];
            if (temp.count == 2) {
                NSDictionary *dict = [NSDictionary dictionaryWithObject:temp[1] forKey:temp[0]];
                [partArr addObject:dict];
            }
        }
        
        for (NSDictionary *tempDict in partArr) {
            //向allPartDict对象中添加整个字典tempDict
            [allPartDict addEntriesFromDictionary:tempDict];
        }
        
        if (partArr.count ==0) {
            return;
        }else{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            //处理数据进行跳转
            if ([allPartDict[@"type"] isEqualToString:@"product"]) {
                //产品详情
                NewDetailViewController *newDetailVC = [[NewDetailViewController alloc]init];
                newDetailVC.Id =  [NSString stringWithFormat:@"%@",allPartDict[@"id"]];
//                InsuranceDetailViewController *vc = [[InsuranceDetailViewController alloc]init];
//                vc.Id = [NSString stringWithFormat:@"%@",allPartDict[@"id"]];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.navigationController pushViewController:newDetailVC animated:YES];
                    [app.mainTabBarController.selectedViewController pushViewController:newDetailVC animated:YES];
                });
            }else if ([allPartDict[@"type"] isEqualToString:@"course"]){
                //课程详情
                CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
                vc.courseId = [NSString stringWithFormat:@"%@",allPartDict[@"id"]];
                vc.speechmakeId = [NSString stringWithFormat:@"%@",allPartDict[@"speechmakeId"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [app.mainTabBarController.selectedViewController pushViewController:vc animated:YES];
                });
            }else if ([allPartDict[@"type"] isEqualToString:@"question"]){
                //问题详情
                QADetailViewController *vc = [[QADetailViewController alloc]init];
                vc.questionId = [NSString stringWithFormat:@"%@",allPartDict[@"id"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [app.mainTabBarController.selectedViewController pushViewController:vc animated:YES];
                });
            }else if ([allPartDict[@"type"] isEqualToString:@"answer"]){
                //回答详情
                AnswerDetailViewController *vc = [[AnswerDetailViewController alloc]init];
                vc.questionId = [NSString stringWithFormat:@"%@",allPartDict[@"questionId"]];
                vc.answerId = [NSString stringWithFormat:@"%@",allPartDict[@"answerId"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [app.mainTabBarController.selectedViewController pushViewController:vc animated:YES];
                });
            }else if ([allPartDict[@"type"] isEqualToString:@"topic"]){
                //回答详情
                GroupTopicViewController *vc = [[GroupTopicViewController alloc]init];
                vc.appTopicId = [NSString stringWithFormat:@"%@",allPartDict[@"id"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [app.mainTabBarController.selectedViewController pushViewController:vc animated:YES];
                });
            }else{
                //error
                
            }
        }
        
    }
}

/*!
 *type
 详情页类型：course:课程详情;question：问题详情 answer：回答问题详情页 ; product:产品详情
 *id
 type为question、course、product时(格式为type=course&id=XXX)
 *questionId
 问题id type为answer时(格式为type=course& questionId=xxxs& answerId=xxx)
 *answerId
 回答id type为answer时
 说明：课程详情对应app接口:5.4；产品详情对应app接口：7.3；问题详情：3.2;回答详情:3.4
 */

/*
 相关示例：
 产品详情：rulaibao://com.rulaibao/detail?type=product&id=18051609224477390756
 课程详情: rulaibao://com.rulaibao/detail?type=course&id=18050317362725436286&speechmakeId=18042617666660552139
 问题详情：rulaibao://com.rulaibao/detail?type=question&id=18052813455634180490
 回答详情：rulaibao://com.rulaibao/detail?type=answer&questionId=18052813455634180490&answerId=18052813464904088931
 话题详情：rulaibao://com.rulaibao/detail?type=topic&id=1822222222
 */
@end
