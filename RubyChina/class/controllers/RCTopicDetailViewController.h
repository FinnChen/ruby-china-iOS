//
//  RCTopicDetailViewController.h
//  RubyChina
//
//  Created by 陈锋 on 12-11-17.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@interface RCTopicDetailViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) Topic *topic;

@end
