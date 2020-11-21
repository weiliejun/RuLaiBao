//
//  MyCollectCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyCollectionModel;

@interface MyCollectCell : UITableViewCell

- (void)setCollectionListModelWithDictionary:(MyCollectionModel *)model;

@end
