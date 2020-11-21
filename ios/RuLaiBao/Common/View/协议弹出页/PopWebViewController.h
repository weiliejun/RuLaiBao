//
//  PopWebViewController.h
//  WeiJinKe
//
//  Created by mac2015 on 15/5/7.
//  Copyright (c) 2015年 mac2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopWebViewController : UIViewController

@property(nonatomic,copy)NSString *htmlstr;

-(void)popInfoHtmlstr:(NSString *)htmlstr;

-(void)popInfoUrlstr:(NSString *)urlstr;
@end
