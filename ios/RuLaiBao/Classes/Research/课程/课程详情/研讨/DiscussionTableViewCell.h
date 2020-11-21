//
//  DiscussionTableViewCell.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/8.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYAttributedLabel;
@class TYTextContainer;
@interface DiscussionTableViewCell : UITableViewCell

@property (nonatomic, weak, readonly) TYAttributedLabel *label;

@property (nonatomic, strong) TYTextContainer *container;
@end
