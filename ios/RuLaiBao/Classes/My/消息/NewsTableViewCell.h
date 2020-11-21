//
//  NewsTableViewCell.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell
/** 赋值，左边数据 */
-(void)setNewsCellInfo:(NSString *)newsInfoStr;
/** 赋值，右边条数 */
-(void)setNewsInfoNum:(NSString *)newsNum;
@end
