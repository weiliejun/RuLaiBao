//
//  HomeViewCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/3/29.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewModel;

@interface HomeViewCell : UITableViewCell

- (void)setValueforCell:(HomeViewModel *)homeModel;


@end
