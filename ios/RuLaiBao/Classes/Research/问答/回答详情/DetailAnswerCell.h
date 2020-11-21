//
//  DetailAnswerCell.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYAttributedLabel;
@class TYTextContainer;
@interface DetailAnswerCell : UITableViewCell
@property (nonatomic, weak, readonly) TYAttributedLabel *label;
@property (nonatomic, strong) TYTextContainer *container;
@end
