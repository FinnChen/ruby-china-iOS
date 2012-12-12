//
//  RCUserViewController.h
//  RubyChina
//
//  Created by 陈锋 on 12-11-29.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface RCUserViewController : UIViewController

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedTab;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) User *user;
@property (nonatomic, copy) NSString *userLogin;
@property (nonatomic, strong) NSMutableArray *topics;
@property (nonatomic, strong) NSMutableArray *favoriteTopics;

- (IBAction)segmentedTabChanged:(id)sender;
@end
