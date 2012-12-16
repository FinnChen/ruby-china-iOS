//
//  RCTopicMasterViewController.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-11.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <RestKit.h>
#import <UIImageView+AFNetworking.h>
#import "UIBarButtonItem+RubyChina.h"
#import "UIViewController+RubyChina.h"
#import "RCSideContainerViewController.h"
#import "RCTopicMasterViewController.h"
#import "RCTopicDetailViewController.h"
#import "RCUserViewController.h"
#import "RCTopicTableCell.h"
#import "Node.h"
#import "Topic.h"
#import "User.h"
#import "Reply.h"


@interface RCTopicMasterViewController () <RKObjectLoaderDelegate>

@property (nonatomic, strong) NSMutableArray *topics;
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger pageSize;
@property (nonatomic) BOOL loadmoreLoading;
@property (nonatomic, strong) UIBarButtonItem *rightBtn;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation RCTopicMasterViewController

//@synthesize tableView = _tableView;
//@synthesize pullToRefreshView = _pullToRefreshView;
//@synthesize leftSelectedIndexPath = _leftSelectedIndexPath;
//@synthesize resourcePath = _resourcePath;
//@synthesize topics = _topics;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentPage = 1;
    _pageSize = 20;
    _topics = [NSMutableArray array];
    
    // navigation bar
    self.title = _titleStr;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"top_bar_navigation_btn.png"] highLightedImage:[UIImage imageNamed:@"top_bar_navigation_btn_pressed.png"] target:self action:@selector(revealLeftSidebar:)];
    
    
    _rightBtn = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"text_page_top_bar_refresh_btn.png"] highLightedImage:[UIImage imageNamed:@"top_bar_refresh_btn_pressed.png"] target:self action:@selector(refreshTopics)];
    [self.navigationItem setRightBarButtonItem:_rightBtn animated:NO];

    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.frame = _rightBtn.customView.frame;
    [self.navigationController.navigationBar addSubview:_indicator];
    
    
    // teble view
    CGRect frame = self.view.frame;
    frame.origin = (CGPoint){0,0};
    frame.size.height = 480.0f - 64.0f;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
    // load more footer view
    if (![_resourcePath hasPrefix:@"/topics/node/"] && _loadMoreFooterView == nil) {
		LoadMoreTableFooterView *view = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.contentSize.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_loadMoreFooterView = view;
		
	}
    
    // pull to refresh view
    _pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:_tableView delegate:self];
    [self.pullToRefreshView startLoadingAndExpand:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [[self.navigationItem.rightBarButtonItem.customView viewWithTag:110] setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [[[RKObjectManager sharedManager] requestQueue] cancelAllRequests];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)revealLeftSidebar:(id)sender
{
    RCSideContainerViewController *parentVC = (RCSideContainerViewController *)(self.navigationController.parentViewController);
    if (parentVC.isLeftSideViewRevealed) {
        [parentVC hideLeftSideView];
    } else {
        [parentVC revealLeftSideView];
    }

}


#pragma mark - 
#pragma mark Load Remote Objects Methods

- (void)loadData
{
    _currentPage = 1;
    [self loadDataAtPage:_currentPage withPageSize:_pageSize];
}

- (void)loadDataAtPage:(NSUInteger)page withPageSize:(NSUInteger)pageSize
{
    if (![self.resourcePath hasPrefix:@"/topics/node/"]) {
        self.resourcePath = [NSString stringWithFormat:@"/topics.json?page=%u&per_page=%u", page, pageSize];
    }
    [self sendRequestToResourcePath:self.resourcePath];
}

- (void)sendRequestToResourcePath:(NSString *)path
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:path delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if (_currentPage == 1) {
        _topics = [NSMutableArray arrayWithArray:objects];
        [self.pullToRefreshView finishLoading];
    } else {
        for (NSObject *object in objects) {
            if ([object isKindOfClass:[Topic class]]) {
                [_topics addObject:object];
            }
        }
        _loadmoreLoading = NO;
        [_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    [self afterLoadData];

    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [self.pullToRefreshView finishLoading];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"加载错误，请重试..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - SSPullRefresh Methods

- (void)refreshTopics
{
    [self.pullToRefreshView startLoadingAndExpand:YES];
}

//- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view {
//    return YES;
//}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self beforeLoadData];
    [self loadData];
}

- (void)pullToRefreshViewDidFinishLoading:(SSPullToRefreshView *)view {

}

#pragma mark - LoadMoreFooterView Methods
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view
{
    _loadmoreLoading = YES;
    [self beforeLoadData];
    [self loadDataAtPage:++_currentPage withPageSize:_pageSize];
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view
{
    return _loadmoreLoading;
}

- (void)beforeLoadData
{
    _rightBtn.customView.hidden = YES;
    _indicator.hidden = NO;
    [_indicator startAnimating];
}

- (void)afterLoadData
{
    _rightBtn.customView.hidden = NO;
    _indicator.hidden = YES;
    [_indicator stopAnimating];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
	
}

#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"topicCell";
    RCTopicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[RCTopicTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (_topics.count > 0) {
        [cell setTopic:[_topics objectAtIndex:indexPath.row]];
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)];
        [cell.imageView addGestureRecognizer:tap];
        [cell.imageView setUserInteractionEnabled:YES];
        [cell.imageView setMultipleTouchEnabled:YES];
    }
    
    return cell;
}

- (void)avatarTapped:(UIGestureRecognizer *)recognizer
{
    RCSideContainerViewController *parentVC = (RCSideContainerViewController *)self.navigationController.parentViewController;
    
    if (parentVC.isLeftSideViewRevealed) {
        [parentVC hideLeftSideView];
        return;
    }
    
    RCUserViewController *userController = [[RCUserViewController alloc] initWithNibName:@"RCUserViewController" bundle:nil];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:[recognizer locationInView:_tableView]];
    Topic *topic = [_topics objectAtIndex:indexPath.row];
    userController.userLogin = topic.user.login;
    [self.navigationController pushViewController:userController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RCTopicTableCell heightForCellWithTopic:[_topics objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCSideContainerViewController *parentVC = (RCSideContainerViewController *)self.navigationController.parentViewController;
    
    if (parentVC.isLeftSideViewRevealed) {
        [parentVC hideLeftSideView];
    } else {
        RCTopicDetailViewController *topicDetailController = [[RCTopicDetailViewController alloc] init];
        topicDetailController.topic = [_topics objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:topicDetailController animated:YES];
    }
}

@end
