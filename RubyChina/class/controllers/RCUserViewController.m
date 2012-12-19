//
//  RCUserViewController.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-29.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import "RCUserViewController.h"
#import <RestKit.h>
#import <UIImageView+AFNetworking.h>
#import "UIBarButtonItem+RubyChina.h"
//#import "UIViewController+RubyChina.h"
#import "RCSideContainerViewController.h"
#import "RCTopicDetailViewController.h"

@interface RCUserViewController () <RKObjectLoaderDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation RCUserViewController

@synthesize segmentedTab = _segmentedTab;
@synthesize tableView = _tableView;
@synthesize imageView = _imageView;
@synthesize user = _user;
@synthesize userLogin = _userLogin;
@synthesize topics = _topics;
@synthesize favoriteTopics = _favoriteTopics;

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"我的主页";
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_userLogin == nil) {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"top_bar_navigation_btn.png"] highLightedImage:[UIImage imageNamed:@"top_bar_navigation_btn_pressed.png"] target:self action:@selector(revealLeftSidebar:)];
        [self loadUserInfoWithUserName:username];
    } else {
        self.title = _userLogin;
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"top_bar_back_btn.png"] highLightedImage:[UIImage imageNamed:@"top_bar_back_btn_pressed.png"] target:self action:@selector(backbuttonPressed)];
        [self loadUserInfoWithUserName:_userLogin];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backbuttonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)segmentedTabChanged:(id)sender {
    if ([sender selectedSegmentIndex] != 0) {
        _imageView.hidden = YES;
    } else {
        _imageView.hidden = NO;
    }
    
    if ([sender selectedSegmentIndex] == 2 && _favoriteTopics == nil) {
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/users/%@/topics/favorite.json", _userLogin] delegate:self];
    }
    
    [_tableView reloadData];
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


- (void)loadUserInfoWithUserName:(NSString *)username
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"/users/%@.json", username] delegate:self];
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSString *resourcePath = objectLoader.resourcePath;

    if ([resourcePath hasSuffix:@"/favorite.json"]) {
        _favoriteTopics = [NSMutableArray arrayWithArray:objects];
    } else {
        _user = [objects objectAtIndex:0];
        [_imageView setImageWithURL:[NSURL URLWithString:[_user.avatarUrl stringByReplacingOccurrencesOfString:@"s=48" withString:@"s=80"]] placeholderImage:[UIImage imageNamed:@"avatar.png"]];
        _topics = _user.topics;
    }
    
    [_tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"请检查用户名是否设置正确" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - UITableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (_segmentedTab.selectedSegmentIndex) {
        case 0:
            numberOfRows = 9;
            break;
        case 1:
            numberOfRows = [_topics count];
            break;
        case 2:
            numberOfRows = [_favoriteTopics count];
            break;
            
        default:
            break;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    }
    
    switch (_segmentedTab.selectedSegmentIndex) {
        case 0:
            cell.textLabel.text = [self userInfoAtIndexPath:indexPath];
            break;
        case 1:
            cell.textLabel.text = [[_topics objectAtIndex:indexPath.row] title];
            break;
        case 2:
            cell.textLabel.text = [[_favoriteTopics objectAtIndex:indexPath.row] title];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSString *)userInfoAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *userInfo = nil;
    switch (indexPath.row) {
        case 0:
            userInfo = [NSString stringWithFormat:@"ID:  %@", _user.login];
            break;
        case 1:
            userInfo = [NSString stringWithFormat:@"Name:  %@", _user.name];
            break;
        case 2:
            userInfo = [NSString stringWithFormat:@"City:  %@", _user.location];
            break;
        case 3:
            userInfo = [NSString stringWithFormat:@"Company:  %@", _user.company];
            break;
        case 4:
            userInfo = [NSString stringWithFormat:@"Email:  %@", _user.email];
            break;
        case 5:
            userInfo = [NSString stringWithFormat:@"Twitter:  %@", _user.twitter];
            break;
        case 6:
            userInfo = [NSString stringWithFormat:@"Blog:  %@", _user.website];
            break;
        case 7:
            userInfo = [NSString stringWithFormat:@"签名:  %@", _user.tagline];
            break;
        case 8:
            userInfo = [NSString stringWithFormat:@"简介:  %@", _user.bio];
            break;
        default:
            break;
    }
    
    return userInfo;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segmentedTab.selectedSegmentIndex == 1) {
        RCTopicDetailViewController *controller = [[RCTopicDetailViewController alloc] init];
        controller.topic = [_topics objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (_segmentedTab.selectedSegmentIndex == 2) {
        RCTopicDetailViewController *controller = [[RCTopicDetailViewController alloc] init];
        controller.topic = [_favoriteTopics objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
