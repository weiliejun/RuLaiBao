//
//  MyCustomCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/10.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomCell : UITableViewCell

/** 字典数据 */
@property (nonatomic, strong) NSDictionary *infoDict;

/** 当第 0 组 第 1 行 的时候 需要显示有数据 */
//@property (nonatomic, copy) NSString *totalNumStr;

/** 数字 */
@property (nonatomic, weak) UILabel *rightLabel;

@end
