//
//  MoreSearchViewController.h
//  PYSearchExample
//
//  Created by qiu on 2018/3/19.
//  Copyright © 2018年 CoderKo1o. All rights reserved.
//

/*!
 改良版的搜索默认页面
 可传入多种数据组（必须保持个数一致<数组个数与title个数>）
 */
#import <UIKit/UIKit.h>
#import "PYSearchConst.h"

@class MoreSearchViewController, PYSearchSuggestionViewController;

typedef void(^MoreDidSearchBlock)(MoreSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText);


@protocol MoreSearchViewControllerDataSource <NSObject,UITableViewDataSource>

@optional
/**
 Return height for row.
 
 @param searchSuggestionView    view which display search suggestions
 @param indexPath               indexPath of row
 @return height of row
 */
- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 Return number of sections in search suggestion view.
 
 @param searchSuggestionView    view which display search suggestions
 @return number of sections
 */
- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView;

/**
 Return number of rows in section.
 
 @param searchSuggestionView    view which display search suggestions
 @param section                 index of section
 @return number of rows in section
 */
- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section;

/**
 Return a `UITableViewCell` object.
 
 @param searchSuggestionView    view which display search suggestions
 @param indexPath               indexPath of row
 @return a `UITableViewCell` object
 */
- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
/**
 The protocol of delegate
 */
@protocol MoreSearchViewControllerDelegate <NSObject, UITableViewDelegate>

@optional

/**
 Called when search begain.
 
 @param searchViewController    search view controller
 @param searchBar               search bar
 @param searchText              text for search
 */
- (void)searchViewController:(MoreSearchViewController *)searchViewController
      didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText;

/**
 Called when popular search is selected.
 
 @param searchViewController    search view controller
 @param index                   index of tag
 @param searchText              text for search
 
 Note: `searchViewController:didSearchWithSearchBar:searchText:` will not be called when this method is implemented.
 */
- (void)searchViewController:(MoreSearchViewController *)searchViewController
   didSelectHotSearchAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText;

/**
 Called when search history is selected.
 
 @param searchViewController    search view controller
 @param index                   index of tag or row
 @param searchText              text for search
 
 Note: `searchViewController:didSearchWithSearchBar:searchText:` will not be called when this method is implemented.
 */
- (void)searchViewController:(MoreSearchViewController *)searchViewController
didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText;

/**
 Called when search suggestion is selected.
 
 @param searchViewController    search view controller
 @param index                   index of row
 @param searchText              text for search
 
 Note: `searchViewController:didSearchWithSearchBar:searchText:` will not be called when this method is implemented.
 */
- (void)searchViewController:(MoreSearchViewController *)searchViewController
didSelectSearchSuggestionAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText PYSEARCH_DEPRECATED("Use searchViewController:didSelectSearchSuggestionAtIndexPath:searchText:");

/**
 Called when search suggestion is selected, the method support more custom of search suggestion view.
 
 @param searchViewController    search view controller
 @param indexPath               indexPath of row
 @param searchBar               search bar
 
 Note: `searchViewController:didSearchWithSearchBar:searchText:` and `searchViewController:didSelectSearchSuggestionAtIndex:searchText:` will not be called when this method is implemented.
 Suggestion: To ensure that can cache selected custom search suggestion records, you need to set `searchBar.text` = "custom search text".
 */
- (void)searchViewController:(MoreSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath
                   searchBar:(UISearchBar *)searchBar;

/**
 Called when search text did change, you can reload data of suggestion view thought this method.
 
 @param searchViewController    search view controller
 @param searchBar               search bar
 @param searchText              text for search
 */
- (void)searchViewController:(MoreSearchViewController *)searchViewController
         searchTextDidChange:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText;

/**
 Called when cancel item did press, default execute `[self dismissViewControllerAnimated:YES completion:nil]`.
 
 @param searchViewController search view controller
 */
- (void)didClickCancel:(MoreSearchViewController *)searchViewController;

@end

@interface MoreSearchViewController : UIViewController
/**
 The delegate
 **/
@property (nonatomic, weak) id<MoreSearchViewControllerDelegate> delegate;
/**
 The data source
 */
@property (nonatomic, weak) id<MoreSearchViewControllerDataSource> dataSource;
/**
 The path of cache search record, default is `PYSEARCH_SEARCH_HISTORY_CACHE_PATH`.
 */
@property (nonatomic, copy) NSString *searchHistoriesCachePath;

/**
 The number of cache search record, default is 20.
 */
@property (nonatomic, assign) NSUInteger searchHistoriesCount;

/*!
 title数组 hotComSearcheArr == nil时，此处只需传入两个数据即可
 */
@property (nonatomic, copy) NSMutableArray<NSString *> *titleSearchArr;
/** 热搜数组 */
@property (nonatomic, copy) NSArray<NSString *> *hotSearches;
/** 热搜第二个数组 */
@property (nonatomic, copy) NSArray<NSString *> *hotComSearcheArr;
/**
 The block which invoked when search begain.
 */
@property (nonatomic, copy) MoreDidSearchBlock didSearchBlock;

/**
 The element of search suggestions
 
 Note: it is't effective when `searchSuggestionHidden` is NO or cell of suggestion view is custom.
 */
@property (nonatomic, copy) NSArray<NSString *> *searchSuggestions;
/**
 Creates an instance of searchViewContoller with popular searches, search bar's placeholder and the block which invoked when search begain.
 
 @param hotSearches     popular searchs
 @param placeholder     placeholder of search bar
 @param block           block which invoked when search begain
 @return new instance of `PYSearchViewController` class
 
 Note: The `delegate` has a priority greater than the `block`, `block` is't effective when `searchViewController:didSearchWithSearchBar:searchText:` is implemented.
 Note 2:The `titleSearchArr` count must 与数组个数一直
 */
+ (instancetype)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches
                                   hotComSearcheArr:(NSArray<NSString *> *)hotComSearcheArr
                                     titleSearchArr:(NSMutableArray<NSString *> *)titleSearchArr
                               searchBarPlaceholder:(NSString *)placeholder
                                     didSearchBlock:(MoreDidSearchBlock)block;
@end
