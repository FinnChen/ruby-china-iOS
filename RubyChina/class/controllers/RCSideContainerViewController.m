//
//  RCSideContainerViewController.m
//  RubyChina
//
//  Created by 陈锋 on 12-12-10.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <RestKit.h>
#import "BButton.h"

#import "RCSideContainerViewController.h"

#import "Node.h"
#import "RCNodesDelegate.h"
#import "RCTopicMasterViewController.h"
#import "RCNewTopicViewController.h"
#import "RCSettingViewController.h"
#import "RCNodesViewController.h"

#define RC_LEFT_SIDE_WIDTH 270.0f
#define RC_LEFT_SIDE_NAVBAR_TAG 100
#define RC_LEFT_SIDE_STATIC_CELL_NUM 2


@interface RCSideContainerViewController () <RCNodesDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, copy) NSArray *menus;
@property (nonatomic, strong) NSMutableArray *nodes;
@end

@implementation RCSideContainerViewController

@synthesize leftSideView = _leftSideView;
@synthesize rightContentView = _rightContentView;

@synthesize delegate = _delegate;
@synthesize viewControllerPairs = _viewControllerPairs;
@synthesize selectedViewController = _selectedViewController;
@synthesize selectedIndex = _selectedIndex;

@synthesize tableView = _tableView;
@synthesize coverView = _coverView;
@synthesize menus = _menus;
@synthesize nodes = _nodes;


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
	// Do any additional setup after loading the view.
    
    [self setupLeftSideView];
    
    _menus = @[@"我的主页", @"社区"];
    
    [self loadNode];
    
    // add pan and swipe UIGestureRecognizer to right content view
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_rightContentView addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_rightContentView addGestureRecognizer:swipeLeft];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [_rightContentView addGestureRecognizer:panGesture];
    [panGesture requireGestureRecognizerToFail:swipeRight];
    [panGesture requireGestureRecognizerToFail:swipeLeft];
    
    
    CGSize size = _rightContentView.bounds.size;
    UIView *aCoverView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    aCoverView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [aCoverView addGestureRecognizer:tapGesture];
    
    _coverView = aCoverView;
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
//    [_rightContentView addGestureRecognizer:tapGesture];
//    [tapGesture requireGestureRecognizerToFail:panGesture];
    
    swipeRight.delegate = self;
    swipeLeft.delegate = self;
    panGesture.delegate = self;
//    tapGesture.delegate = self;
    

    // add the default childViewController;
    UIViewController *controller = [_viewControllerPairs objectForKey:_menus[1]];
    controller.view.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    [self addChildViewController:controller];
    [_rightContentView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
    
    _rightContentView.frame = (CGRect){CGPointZero, size};
    
    _selectedViewController = controller;
    
    _leftSideViewRevealed = NO;
    
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewRowAnimationNone];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    
    
    _leftSideView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, RC_LEFT_SIDE_WIDTH, rect.size.height)];
    _leftSideView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [view addSubview:_leftSideView];
    
    _rightContentView = [[UIView alloc] initWithFrame:(CGRect){(CGPoint){RC_LEFT_SIDE_WIDTH, 0.0f}, rect.size}];
    _rightContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _rightContentView.userInteractionEnabled = YES;
    _rightContentView.multipleTouchEnabled = YES;
    
    [view addSubview:_rightContentView];
    
    [self setView:view];
}

- (void)setupLeftSideView
{
    UIImage *navBackGroundImg = [UIImage imageNamed:@"navigation_background.png"];
    _leftSideView.backgroundColor = [UIColor colorWithPatternImage:navBackGroundImg];
    
    CGSize size = self.view.bounds.size;
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, RC_LEFT_SIDE_WIDTH, 44.0f)];
    navBar.tag = RC_LEFT_SIDE_NAVBAR_TAG;
    UIImage *navImg = [UIImage imageNamed:@"navigation_top_bar_background.png"];
    UIImageView *navBgImgView = [[UIImageView alloc] initWithImage:navImg];
    [navBar addSubview:navBgImgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 140.0f, 44.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightTextColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
    label.text = @"Ruby-China";
    [navBar addSubview:label];
    
    UIImage *addButtonImg = [UIImage imageNamed:@"navigation_top_bar_add_btn.png"];
    UIImage *addButtonPressedImg = [UIImage imageNamed:@"navigation_top_bar_add_btn_pressed.png"];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:addButtonImg forState:UIControlStateNormal];
    [addButton setImage:addButtonPressedImg forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    CGRect addButtonFrame = addButton.frame;
    addButtonFrame.size = addButtonImg.size;
    addButton.frame = addButtonFrame;
    addButton.center = CGPointMake(155.0f, 44.0f/2);
    [navBar addSubview:addButton];
    
    UIImage *editButtonImg = [UIImage imageNamed:@"navigation_top_bar_edit_btn.png"];
    UIImage *editButtonPressedImg = [UIImage imageNamed:@"navigation_top_bar_edit_btn_pressed.png"];
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:editButtonImg forState:UIControlStateNormal];
    [editButton setImage:editButtonPressedImg forState:UIControlStateHighlighted];
    [editButton addTarget:self action:@selector(editButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    CGRect editButtonFrame = editButton.frame;
    editButtonFrame.size = editButtonImg.size;
    editButton.frame = editButtonFrame;
    editButton.center = CGPointMake(195.0f, 44.0f/2);
    [navBar addSubview:editButton];
    
    UIImage *lineImg = [UIImage imageNamed:@"navigation_top_bar_line.png"];
    UIImageView *lineView = [[UIImageView alloc] initWithImage:lineImg];
    CGRect lineFrame = lineView.frame;
    lineFrame.origin.x = 220.0f;
    lineView.frame = lineFrame;
    [navBar addSubview:lineView];
    
    UIImage *settingImg = [UIImage imageNamed:@"navigation_top_bar_setting_btn.png"];
    UIImage *settingPressedImg = [UIImage imageNamed:@"navigation_top_bar_setting_btn_pressed.png"];
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setImage:settingImg forState:UIControlStateNormal];
    [settingButton setImage:settingPressedImg forState:UIControlStateHighlighted];
    [settingButton addTarget:self action:@selector(settinButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    CGRect settingFrame = settingButton.frame;
    settingFrame.size = settingImg.size;
    settingButton.frame = settingFrame;
    settingButton.center = CGPointMake(220.0f + (RC_LEFT_SIDE_WIDTH - 220.0f)/2, 44.0f/2);
    [navBar addSubview:settingButton];
    
    UIImage *doneImg = [UIImage imageNamed:@"navigation_top_bar_over_btn.png"];
    UIImage *donePressedImg = [UIImage imageNamed:@"navigation_top_bar_over_btn_pressed.png"];
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setImage:doneImg forState:UIControlStateNormal];
    [doneButton setImage:donePressedImg forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    CGRect doneFrame = doneButton.frame;
    doneFrame.size = doneImg.size;
    doneButton.frame = doneFrame;
    doneButton.center = CGPointMake(220.0f + (RC_LEFT_SIDE_WIDTH - 220.0f)/2, 44.0f/2);
    doneButton.hidden = YES;
    [navBar addSubview:doneButton];
    
    [_leftSideView addSubview:navBar];
    
    BButton *btn = [[BButton alloc] initWithFrame:CGRectMake(10.0, 5.0 + navBar.bounds.size.height, 250.0, 33.0)];
    [btn setTitle:@"发布新帖" forState:UIControlStateNormal]; // Set the button title
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [btn addTarget:self action:@selector(newTopicBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.color = [UIColor colorWithRed:91.0f/255.0f green:183.0f/255.0f blue:91.0f/255.0f alpha:1.00f];
    
    [_leftSideView addSubview:btn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 88.0f, RC_LEFT_SIDE_WIDTH, size.height - 88.0f)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_leftSideView addSubview:_tableView];
}

- (void)addButtonPressed
{
    RCNodesViewController *nc = [[RCNodesViewController alloc] init];
    nc.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nc];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)editButtonPressed
{
    self.tableView.editing = YES;
    [self updateNavBar];
}

- (void)settinButtonPressed
{
    RCSettingViewController *svc = [[RCSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:svc];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)doneButtonPressed
{
    self.tableView.editing = NO;
    [self updateNavBar];
    
    [self updateNodesWeight];
    
    [[[RKObjectManager sharedManager] objectStore] save:nil];
    
    [self ensureSelectedIndex];
}

- (void)updateNavBar
{
    UIView *navBar = [_leftSideView viewWithTag:RC_LEFT_SIDE_NAVBAR_TAG];
    [navBar.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            BOOL state = [(UIButton *)obj isHidden];
            [(UIButton *)obj setHidden:!state];
        }
    }];
}


#pragma mark -
#pragma mark UIGesture handle methods

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:_rightContentView];
    CGRect frame = _rightContentView.frame;
    
    if (self.isLeftSideViewRevealed) {
        frame.origin.x = MIN(MAX(RC_LEFT_SIDE_WIDTH + translation.x, 0.0f), RC_LEFT_SIDE_WIDTH);
    } else {
        frame.origin.x = MAX(MIN(translation.x, RC_LEFT_SIDE_WIDTH), 0.0f);
    }
    _rightContentView.frame = frame;

    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (frame.origin.x < 100.0f) {
            [self hideLeftSideView];
        } else {
            [self revealLeftSideView];
        }
    }
}


- (void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight && !self.isLeftSideViewRevealed)
        [self revealLeftSideView];
}


- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft && self.isLeftSideViewRevealed)
        [self hideLeftSideView];
}


- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    if (self.isLeftSideViewRevealed) {
        [self hideLeftSideView];
    }
}


#pragma mark -
#pragma mark UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // when the topic detail controller is pushed, disable the gesture recognizer
    if (_selectedViewController.childViewControllers.count > 1) {
        return NO;
    }
    
    if ([gestureRecognizer respondsToSelector:@selector(translationInView:)]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:_rightContentView];
        if (fabs(translation.y) > fabs(translation.x))
            return NO;
    }
    
    // add coverView to stop scroll when sidebar show
    if ([[_rightContentView subviews] containsObject:_coverView] == NO) {
        [_rightContentView addSubview:_coverView];
    }
    
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer.view isEqual:_rightContentView] && ![otherGestureRecognizer.view isEqual:_rightContentView]) {
        return NO;
    }
    
    return YES;
}


- (void)revealLeftSideView
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         CGRect frame = _rightContentView.frame;
                         frame.origin.x = RC_LEFT_SIDE_WIDTH;
                         _rightContentView.frame = frame;
                     }];
    
    self.leftSideViewRevealed = YES;
    
    if ([[_rightContentView subviews] containsObject:_coverView] == NO) {
        [_rightContentView addSubview:_coverView];
    }
}


- (void)hideLeftSideView
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         CGRect frame = _rightContentView.frame;
                         frame.origin.x = 0.0f;
                         _rightContentView.frame = frame;
                         
                     }];
    self.leftSideViewRevealed = NO;
    
    if ([[_rightContentView subviews] containsObject:_coverView]) {
        [_coverView removeFromSuperview];
    }
}


- (void)ensureSelectedIndex
{
    __block NSString *nodeName = nil;
    
    [_viewControllerPairs enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == _selectedViewController) {
            nodeName = key;
            *stop = YES;
        }
    }];
    
    __block NSUInteger index = 1;
    [_nodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *str = ([obj isKindOfClass:[NSManagedObject class]] ? [obj nodeName] : obj);

        if ([str isEqualToString:nodeName]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}


#pragma mark -
#pragma mark Core Data related Methods

- (void)loadNode
{
    NSFetchRequest *request = [Node fetchRequest];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"weight" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"showable == %d", YES];
    [request setPredicate:predicate];
    _nodes = nil;
    _nodes  = [NSMutableArray arrayWithArray:_menus];
    [_nodes addObjectsFromArray:[Node objectsWithFetchRequest:request]];
    
}


- (void)updateNodesWeight
{
    [[_nodes subarrayWithRange:NSMakeRange(RC_LEFT_SIDE_STATIC_CELL_NUM, _nodes.count - RC_LEFT_SIDE_STATIC_CELL_NUM)] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setWeight:[NSNumber numberWithInt:idx]];
    }];
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nodes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SideBarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_list_background.png"]];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_list_foucs.png"]];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_list_arrow.png"]];
    }
    
    
    NSInteger row = indexPath.row;
    
    if (row < RC_LEFT_SIDE_STATIC_CELL_NUM) {
        cell.textLabel.text = [_nodes objectAtIndex:row];
    }
    if(row >= RC_LEFT_SIDE_STATIC_CELL_NUM) {
        cell.textLabel.text = [[_nodes objectAtIndex:indexPath.row] nodeName];
    }
    
    cell.textLabel.textColor = [UIColor lightTextColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    
    return cell;
}

- (void)newTopicBtnClicked:(id)sender
{
    RCNewTopicViewController *newTopicController = [[RCNewTopicViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newTopicController];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Node *node = [_nodes objectAtIndex:indexPath.row];
    
    NSString *key = (indexPath.row < 2 ? _menus[indexPath.row] : node.nodeName);
    
    UIViewController *toVC = [_viewControllerPairs objectForKey:key];
    
    if (toVC == _selectedViewController) {
        [self hideLeftSideView];
        return;
    }
    
    if (toVC == nil) {
        RCTopicMasterViewController *controller =[[RCTopicMasterViewController alloc] init];
        controller.resourcePath = [NSString stringWithFormat:@"/topics/node/%@.json?size=20",  node.nodeID];
        controller.titleStr = node.nodeName;
        
        toVC = [[UINavigationController alloc] initWithRootViewController:controller];
        [_viewControllerPairs setObject:toVC forKey:key];
    }

    UIViewController *fromVC = _selectedViewController;

    [fromVC willMoveToParentViewController:nil];
    [self addChildViewController:toVC];
    toVC.view.frame = fromVC.view.frame;
    
    [self transitionFromViewController:fromVC
                      toViewController:toVC
                              duration:0
                               options:0
                            animations:nil
                            completion:^(BOOL finished) {
                                [fromVC removeFromParentViewController];
                                [toVC didMoveToParentViewController:self];
                            }];
    _selectedViewController = toVC;
    
    [self hideLeftSideView];

}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(indexPath.row >= RC_LEFT_SIDE_STATIC_CELL_NUM, @"staic cell should not be edit");
    
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        NSString *nodeNameKey = [[_nodes objectAtIndex:indexPath.row] nodeName];
        
        UIViewController *toDelVC = [_viewControllerPairs objectForKey:nodeNameKey];
        
        if (toDelVC != nil) {
            
            if (toDelVC == _selectedViewController) {
                UIViewController *fromVC = toDelVC;
                UIViewController *toVC = [_viewControllerPairs objectForKey:_menus[1]];
                
                [fromVC willMoveToParentViewController:nil];
                [self addChildViewController:toVC];
                toVC.view.frame = fromVC.view.frame;
                
                [self transitionFromViewController:fromVC
                                  toViewController:toVC
                                          duration:0
                                           options:0
                                        animations:nil
                                        completion:^(BOOL finished) {
                                            [fromVC removeFromParentViewController];
                                            [toVC didMoveToParentViewController:self];
                                        }];
                _selectedViewController = toVC;
            }
            
            [_viewControllerPairs removeObjectForKey:nodeNameKey];
        }
        
        [[_nodes objectAtIndex:indexPath.row] setShowable:[NSNumber numberWithBool:NO]];
        [_nodes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
//    [self updateNodesWeight];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < RC_LEFT_SIDE_STATIC_CELL_NUM) {
        return NO;
    }
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < RC_LEFT_SIDE_STATIC_CELL_NUM) {
        return NO;
    }
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.row < RC_LEFT_SIDE_STATIC_CELL_NUM) {
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Node *src = [_nodes objectAtIndex:sourceIndexPath.row];
    Node *dst = [_nodes objectAtIndex:destinationIndexPath.row];
    
    [_nodes setObject:dst atIndexedSubscript:sourceIndexPath.row];
    [_nodes setObject:src atIndexedSubscript:destinationIndexPath.row];
    
    [self updateNodesWeight];
}


#pragma mark RCNodeDelegate method

- (void)updateNodes
{
    [self loadNode];
    [self updateNodesWeight];
    [_tableView reloadData];
    [self ensureSelectedIndex];
}


@end
