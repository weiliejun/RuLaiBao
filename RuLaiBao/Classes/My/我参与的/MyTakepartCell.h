//
//  MyTakepartCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAskedModel;
@class MyTalkModel;

@interface MyTakepartCell : UITableViewCell

- (void)setAskedListModelWithDictionary:(MyAskedModel *)model;

- (void)setTalkListModelWithDictionary:(MyTalkModel *)model;

@end
