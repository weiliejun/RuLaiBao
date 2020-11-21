//
//  MoreSuggestionViewController.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/3.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoreSearchSuggestionDidSelectCellBlock)(UITableViewCell *selectedCell);
typedef void(^MoreSearchSuggestionDidScrollBlock)(void);

@protocol MoreSearchSuggestionViewDataSource <NSObject>

@required
- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section;
@optional
- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView;
- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MoreSuggestionViewController : UITableViewController

@property (nonatomic, weak) id<MoreSearchSuggestionViewDataSource> dataSource;
@property (nonatomic, copy) NSArray<NSString *> *searchSuggestions;
@property (nonatomic, copy) MoreSearchSuggestionDidSelectCellBlock didSelectCellBlock;
/** 滑动事件反馈到superview上 */
@property (nonatomic, copy) MoreSearchSuggestionDidScrollBlock didScrollBlock;

+ (instancetype)searchSuggestionViewControllerWithDidSelectCellBlock:(MoreSearchSuggestionDidSelectCellBlock)didSelectCellBlock;

@end
