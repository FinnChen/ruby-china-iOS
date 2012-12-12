//
//  RCSideContainerViewController.h
//  RubyChina
//
//  Created by 陈锋 on 12-12-10.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCSideContainerDelegate;

@interface RCSideContainerViewController : UIViewController

@property (nonatomic, strong) UIView *leftSideView;
@property (nonatomic, strong) UIView *rightContentView;

@property (nonatomic, weak) id<RCSideContainerDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *viewControllerPairs;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic)         NSUInteger selectedIndex;
@property (nonatomic, getter = isLeftSideViewRevealed) BOOL leftSideViewRevealed;

- (void)revealLeftSideView;
- (void)hideLeftSideView;

@end

@protocol RCSideContainerDelegate <NSObject>

- (BOOL)sideContainerViewController:(RCSideContainerViewController *)sideContainerVC shouldSelectViewController:(UIViewController *) viewController;
- (void)sideContainerViewController:(RCSideContainerViewController *)sideContainerVC didSelectViewController:(UIViewController *)viewController;

@end
