//
//  MoreSearchViewController.m
//  PYSearchExample
//
//  Created by qiu on 2018/3/19.
//  Copyright © 2018年 CoderKo1o. All rights reserved.
//

#import "MoreSearchViewController.h"
#import "SelfSizingCollectCell.h"
#import "MoreSuggestionViewController.h"

#import "BorrowerInfoHeaderView.h"
#import "UICollectionViewLeftAlignedLayout.h"

#import "Configure.h"

static NSString *reusableView = @"reusableView";
static NSString *reusableViewCell = @"reusableViewCell";
@interface MoreSearchViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,MoreSearchSuggestionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *allDataArr;

/**  The search bar */
@property (nonatomic, weak) UISearchBar *searchBar;

/**
 The text field of search bar
 */
@property (nonatomic, weak) UITextField *searchTextField;
/**
 The width of cancel button
 */
@property (nonatomic, assign) CGFloat cancelButtonWidth;
/**
 The search suggestion view contoller
 */
@property (nonatomic, weak) MoreSuggestionViewController *searchSuggestionVC;

/**
 The records of search
 */
@property (nonatomic, strong) NSMutableArray *searchHistories;

@end
@implementation MoreSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.cancelButtonWidth == 0) { // Just adapt iOS 11.2
        [self viewDidLayoutSubviews];
    }
    
//    // Adjust the view according to the `navigationBar.translucent`
//    if (NO == self.navigationController.navigationBar.translucent) {
//         self.searchSuggestionVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame) - self.view.py_y, self.view.py_width, self.view.py_height + self.view.py_y);
//        if (!self.navigationController.navigationBar.barTintColor) {
//            self.navigationController.navigationBar.barTintColor = PYSEARCH_COLOR(249, 249, 249);
//        }
//    }
}

+ (instancetype)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches hotComSearcheArr:(NSArray<NSString *> *)hotComSearcheArr titleSearchArr:(NSMutableArray<NSString *> *)titleSearchArr searchBarPlaceholder:(NSString *)placeholder didSearchBlock:(MoreDidSearchBlock)block
{
    MoreSearchViewController *searchVC = [[self alloc] init];
    searchVC.hotSearches = hotSearches;
    searchVC.hotComSearcheArr = hotComSearcheArr;
    searchVC.titleSearchArr = titleSearchArr;
    searchVC.searchBar.placeholder = placeholder;
    searchVC.didSearchBlock = [block copy];
    return searchVC;
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    UIButton *cancelButton = self.navigationItem.rightBarButtonItem.customView;
    self.cancelButtonWidth = cancelButton.py_width > self.cancelButtonWidth ? cancelButton.py_width : self.cancelButtonWidth;
    // Adapt the search bar layout problem in the navigation bar on iOS 11
    // More details : https://github.com/iphone5solo/PYSearch/issues/108
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) { // iOS 11
        UINavigationBar *navBar = self.navigationController.navigationBar;
        navBar.layoutMargins = UIEdgeInsetsZero;
        CGFloat space = 8;
        for (UIView *subview in navBar.subviews) {
            if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
                subview.layoutMargins = UIEdgeInsetsMake(0, space, 0, space); // Fix cancel button width is modified
                break;
            }
        }
        _searchBar.py_width = self.view.py_width - self.cancelButtonWidth - PYSEARCH_MARGIN * 3 - 8;
        _searchBar.py_height = self.view.py_width > self.view.py_height ? 24 : 30;
        _searchTextField.frame = _searchBar.bounds;
    } else {
        UIView *titleView = self.navigationItem.titleView;
        titleView.py_x = PYSEARCH_MARGIN * 1.5;
        titleView.py_y = self.view.py_width > self.view.py_height ? 3 : 7;
        titleView.py_width = self.view.py_width - self.cancelButtonWidth - titleView.py_x * 2 - 3;
        titleView.py_height = self.view.py_width > self.view.py_height ? 24 : 30;
    }
}

-(instancetype)init{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UICollectionViewLeftAlignedLayout  *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    // 设置具体属性
    //设置头
    layout.headerReferenceSize = CGSizeMake(Width_Window, 40);
    // 1.设置 最小行间距
    layout.minimumLineSpacing = 12;
    // 2.设置 最小列间距
    layout. minimumInteritemSpacing  = 20;
    // 3.设置item块的大小 (可以用于自适应)
//    layout.estimatedItemSize = CGSizeMake(20, 30);
    // 设置滑动的方向 (默认是竖着滑动的)
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    // 设置item的内边距
    layout.sectionInset = UIEdgeInsetsMake(5,10,5,5);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, Width_Window, Height_View_SafeArea-10) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[SelfSizingCollectCell class] forCellWithReuseIdentifier:reusableViewCell];
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [self.collectionView registerClass:[BorrowerInfoHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableView];
    [self setUpUI];
}

-(void)setUpUI{
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    self.navigationController.navigationBar.backIndicatorImage = nil;
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancleButton setTitle:[NSBundle py_localizedStringForKey:PYSearchCancelButtonText] forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancelDidClick)  forControlEvents:UIControlEventTouchUpInside];
    [cancleButton sizeToFit];
    cancleButton.py_width += PYSEARCH_MARGIN;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancleButton];
    
    UIView *titleView = [[UIView alloc] init];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    [titleView addSubview:searchBar];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) { // iOS 11
        if (@available(iOS 9.0, *)) {
            [NSLayoutConstraint activateConstraints:@[
                                                      [searchBar.topAnchor constraintEqualToAnchor:titleView.topAnchor],
                                                      [searchBar.leftAnchor constraintEqualToAnchor:titleView.leftAnchor],
                                                      [searchBar.rightAnchor constraintEqualToAnchor:titleView.rightAnchor constant:-PYSEARCH_MARGIN],
                                                      [searchBar.bottomAnchor constraintEqualToAnchor:titleView.bottomAnchor]
                                                      ]];
        } 
    } else {
        searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    self.navigationItem.titleView = titleView;
    searchBar.placeholder = [NSBundle py_localizedStringForKey:PYSearchSearchPlaceholderText];
    searchBar.backgroundImage = [NSBundle py_imageNamed:@"clearImage"];
    searchBar.delegate = self;
    for (UIView *subView in [[searchBar.subviews lastObject] subviews]) {
        if ([[subView class] isSubclassOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subView;
            textField.font = [UIFont systemFontOfSize:16];
            textField.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            textField.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
            _searchTextField = textField;
            break;
        }
    }
    self.searchBar = searchBar;
    
    if (self.searchHistoriesCachePath == nil) {
        self.searchHistoriesCachePath = PYSEARCH_SEARCH_HISTORY_CACHE_PATH;
    }
    
    PYSEARCH_LOG(@"%@",self.searchHistoriesCachePath);
    self.searchHistoriesCount = 20;
}

- (void)cancelDidClick
{
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 增加建议VC
- (MoreSuggestionViewController *)searchSuggestionVC
{
    if (!_searchSuggestionVC) {
        MoreSuggestionViewController *searchSuggestionVC = [[MoreSuggestionViewController alloc] init];
        __weak typeof(self) _weakSelf = self;
        __weak typeof(searchSuggestionVC) _weakSearchVC = searchSuggestionVC;
        searchSuggestionVC.didScrollBlock = ^{
            [_weakSelf scrollViewDidScroll:_weakSearchVC.tableView];
        };
        searchSuggestionVC.didSelectCellBlock = ^(UITableViewCell *didSelectCell) {
            __strong typeof(_weakSelf) _swSelf = _weakSelf;
//            _swSelf.searchBar.text = didSelectCell.textLabel.text;
            NSIndexPath *indexPath = [_swSelf.searchSuggestionVC.tableView indexPathForCell:didSelectCell];
            
            if ([_swSelf.delegate respondsToSelector:@selector(searchViewController:didSelectSearchSuggestionAtIndexPath:searchBar:)]) {
                [_swSelf.delegate searchViewController:_swSelf didSelectSearchSuggestionAtIndexPath:indexPath searchBar:_swSelf.searchBar];
                [_swSelf saveSearchCacheAndRefreshView];
            } else if ([_swSelf.delegate respondsToSelector:@selector(searchViewController:didSelectSearchSuggestionAtIndex:searchText:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                [_swSelf.delegate searchViewController:_swSelf didSelectSearchSuggestionAtIndex:indexPath.row searchText:_swSelf.searchBar.text];
#pragma clang diagnostic pop
                [_swSelf saveSearchCacheAndRefreshView];
            } else {
                [_swSelf searchBarSearchButtonClicked:_swSelf.searchBar];
            }
        };
        searchSuggestionVC.view.frame = CGRectMake(0, 0, Width_Window, Height_Window-Height_Statusbar_NavBar-10);
        
        searchSuggestionVC.view.backgroundColor = [UIColor customBackgroundColor];
        searchSuggestionVC.view.hidden = YES;
        searchSuggestionVC.dataSource = self;
        [self.view addSubview:searchSuggestionVC.view];
        [self addChildViewController:searchSuggestionVC];
        _searchSuggestionVC = searchSuggestionVC;
    }
    return _searchSuggestionVC;
}

- (void)setSearchSuggestions:(NSArray<NSString *> *)searchSuggestions
{
    _searchSuggestions = [searchSuggestions copy];
    self.searchSuggestionVC.searchSuggestions = [searchSuggestions copy];
//    self.collectionView.hidden = [self.searchSuggestionVC.tableView numberOfRowsInSection:0];
//    self.searchSuggestionVC.view.hidden = ![self.searchSuggestionVC.tableView numberOfRowsInSection:0];
    //只要输入字段就显示界面
    self.collectionView.hidden = _searchBar.text.length;
    self.searchSuggestionVC.view.hidden = !_searchBar.text.length;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.allDataArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.allDataArr[section] count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SelfSizingCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusableViewCell forIndexPath:indexPath];
    NSArray *arr = self.allDataArr[indexPath.section];
    cell.textLabel.text = arr[indexPath.row];
    return cell;
}

//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //先通过kind类型判断是头还是尾巴，然后在判断是哪一组，如果都是一样的头尾，那么只要第一次判断就可以了
    if (kind == UICollectionElementKindSectionHeader){
        BorrowerInfoHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableView forIndexPath:indexPath];
        if (self.searchHistories.count > 0 && indexPath.section == self.allDataArr.count -1) {
            headerView.isShowClearBtn = YES;
        }else{
            headerView.isShowClearBtn = NO;
        }
        headerView.headerViewClearBlock = ^{
            [self emptySearchHistoryDidClick];
        };
        headerView.headerLabel.text = self.titleSearchArr[indexPath.section];
        return headerView;
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    SelfSizingCollectCell *cell = (SelfSizingCollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UILabel *label = cell.textLabel;
    self.searchBar.text = label.text;
    
    [self searchBarSearchButtonClicked:self.searchBar];
}

#pragma mark - 添加size值，若不加此值，则headerview会显示出错
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.allDataArr[indexPath.section];
    NSString *text = arr[indexPath.row];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT+10, 40) options:NSStringDrawingTruncatesLastVisibleLine|   NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    rect.size.width +=25;
    rect.size.height+=15;
    return rect.size;
}

//清空按钮
//- (void)emptySearchHistoryDidClick{
//    [self.searchHistories removeAllObjects];
//    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
//    [self.allDataArr removeLastObject];
//    [self.collectionView reloadData];
//}
- (void)emptySearchHistoryDidClick{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确定清除历史搜索记录吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.searchHistories removeAllObjects];
        [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
        [self.allDataArr removeLastObject];
        [self.collectionView reloadData];
    }];
    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    [alertVC addAction:certainAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSearchWithSearchBar:searchText:)]) {
        [self.delegate searchViewController:self didSearchWithSearchBar:self.searchBar searchText:self.searchBar.text];
        [self saveSearchCacheAndRefreshView];
        return;
    }
    //点击search按钮，跳转
    if (self.didSearchBlock) self.didSearchBlock(self, self.searchBar, self.searchBar.text);
    [self saveSearchCacheAndRefreshView];
}

- (void)saveSearchCacheAndRefreshView{
    UISearchBar *searchBar = self.searchBar;
    [searchBar resignFirstResponder];
    NSString *searchText = searchBar.text;
    searchText = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (searchText.length > 0) {
        [self.searchHistories removeObject:searchText];
        [self.searchHistories insertObject:searchText atIndex:0];
        
        if (self.searchHistories.count > self.searchHistoriesCount) {
            [self.searchHistories removeLastObject];
        }
        [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
        if ((self.hotComSearcheArr.count != 0 && self.allDataArr.count == 3) || (self.hotComSearcheArr.count == 0 && self.allDataArr.count == 2) || (self.hotSearches.count == 0 && self.allDataArr.count == 2) || (self.hotSearches.count == 0 && self.hotComSearcheArr.count == 0 && self.allDataArr.count == 1)) {
            //只有含有searchHistories的时候才会删除最后一个再添加上
            [self.allDataArr removeLastObject];
        }
        [self.allDataArr addObject:self.searchHistories];
        [self.collectionView reloadData];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    self.collectionView.hidden = searchText.length && [self.searchSuggestionVC.tableView numberOfRowsInSection:0];
//    self.searchSuggestionVC.view.hidden = !searchText.length || ![self.searchSuggestionVC.tableView numberOfRowsInSection:0];
    self.collectionView.hidden = searchText.length;
    self.searchSuggestionVC.view.hidden = !searchText.length;
    
    if (self.searchSuggestionVC.view.hidden) {
        self.searchSuggestions = nil;
    }
    [self.view bringSubviewToFront:self.searchSuggestionVC.view];
    if ([self.delegate respondsToSelector:@selector(searchViewController:searchTextDidChange:searchText:)]) {
        [self.delegate searchViewController:self searchTextDidChange:searchBar searchText:searchText];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self setSearchSuggestions:self.searchSuggestions];
    return YES;
}

#pragma mark - PYSearchSuggestionViewDataSource
- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView
{
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInSearchSuggestionView:)]) {
        return [self.dataSource numberOfSectionsInSearchSuggestionView:searchSuggestionView];
    }
    return 1;
}

- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:numberOfRowsInSection:)]) {
        NSInteger numberOfRow = [self.dataSource searchSuggestionView:searchSuggestionView numberOfRowsInSection:section];
        searchSuggestionView.hidden =  !self.searchBar.text.length || 0 == numberOfRow;
        return numberOfRow;
    }
    return self.searchSuggestions.count;
}

- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:cellForRowAtIndexPath:)]) {
        return [self.dataSource searchSuggestionView:searchSuggestionView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:heightForRowAtIndexPath:)]) {
        return [self.dataSource searchSuggestionView:searchSuggestionView heightForRowAtIndexPath:indexPath];
    }
    return 44.0;
}

#pragma mark --- lazyinit
- (NSMutableArray *)searchHistories
{
    if (!_searchHistories) {
        _searchHistories = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath]];
    }
    return _searchHistories;
}

-(NSMutableArray *)allDataArr{
    if (!_allDataArr) {
        _allDataArr = [NSMutableArray arrayWithCapacity:10];
        
        if (self.hotSearches.count>0) {
            [_allDataArr addObject:self.hotSearches];
        }
        if (self.hotComSearcheArr.count>0) {
            [_allDataArr addObject:self.hotComSearcheArr];
        }
        if (self.searchHistories.count>0) {
            [_allDataArr addObject:self.searchHistories];
        }
    }
    return _allDataArr;
}
- (void)setSearchHistoriesCachePath:(NSString *)searchHistoriesCachePath{
    _searchHistoriesCachePath = [searchHistoriesCachePath copy];
    self.searchHistories = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
