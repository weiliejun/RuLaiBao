//
//  AppointmentCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/17.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAppointListModel;

@interface MyAppointmentCell : UITableViewCell

- (void)setMyAppointListModelWithDictionary:(MyAppointListModel *)model;

@end
