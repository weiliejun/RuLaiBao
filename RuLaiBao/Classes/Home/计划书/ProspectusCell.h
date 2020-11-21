//
//  ProspectusCell.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/2.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProspectusModel;
@class SearchListModel;

@interface ProspectusCell : UITableViewCell

- (void)setProspectusModelWithDictionary:(ProspectusModel *)model;

- (void)setSearchListModelWithDictionary:(SearchListModel *)model;

@end
