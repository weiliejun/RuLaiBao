//
//  MyGuaranteeCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGuaranteeCell : UITableViewCell

/** block属性回调点中的哪个按钮 */
@property (nonatomic, copy) void(^completeButtonClick)(NSInteger selectIndex);

@end
