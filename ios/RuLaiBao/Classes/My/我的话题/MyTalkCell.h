//
//  MyTalkCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/18.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTalkModel;

@interface MyTalkCell : UITableViewCell

- (void)setMyTalkListModelWithDictionary:(MyTalkModel *)model;

@end
