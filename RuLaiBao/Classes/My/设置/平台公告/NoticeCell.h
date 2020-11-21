//
//  NoticeCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/20.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoticeModel;

@interface NoticeCell : UITableViewCell

//改变颜色
//- (void)setLabelColor:(UIColor *)color;

- (void)setNoticeModelWithDictionary:(NoticeModel *)model;



@end
