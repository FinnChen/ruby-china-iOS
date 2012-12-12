//
//  RCTopicMasterViewController.h
//  RubyChina
//
//  Created by 陈锋 on 12-11-11.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSPullToRefresh.h>
#import "LoadMoreTableFooterView.h"

@class RCSidebarViewController;

@interface RCTopicMasterViewController : UIViewController <SSPullToRefreshViewDelegate, LoadMoreTableFooterDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) LoadMoreTableFooterView *loadMoreFooterView;

@property (nonatomic, copy) NSString *resourcePath;
@property (nonatomic, copy) NSString *titleStr; // consistent with node name

@end
