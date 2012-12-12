//
//  RCNodesViewController.h
//  RubyChina
//
//  Created by 陈锋 on 12-11-23.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCNodesDelegate.h"
#import "Node.h"

@interface RCNodesViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *nodes;
@property (nonatomic, strong) id<RCNodesDelegate> delegate;
@end
