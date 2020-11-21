//
//  QATableViewCell.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/9.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QAListModel;
@interface QATableViewCell : UITableViewCell
@property (nonatomic, strong) QAListModel *cellInfoModel;
@end
