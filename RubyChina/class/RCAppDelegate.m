//
//  RCAppDelegate.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-11.
//  Copyright (c) 2012年 陈锋. All rights reserved.
//

#import "RCAppDelegate.h"
#import "RCSideContainerViewController.h"
#import "RCTopicMasterViewController.h"
#import "RCUserViewController.h"
#import <RestKit.h>
#import "Node.h"
#import "Topic.h"
#import "Reply.h"


@implementation RCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self configUIAppearance];
    [self configRestKit];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    RCUserViewController *userVC = [[RCUserViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:userVC];
    
    RCTopicMasterViewController *defulatVC = [[RCTopicMasterViewController alloc] init];
    defulatVC.titleStr = @"社区";
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:defulatVC];
    
    RCSideContainerViewController *sideVC = [[RCSideContainerViewController alloc] init];
//    sideVC.viewControllers = [NSMutableArray arrayWithArray:@[navController, navController2]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: @{@"我的主页" : navController, @"社区" : navController2}];
    sideVC.viewControllerPairs = dict;
    
    self.window.rootViewController = sideVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)configUIAppearance
{
    UIImage *navBarImage = [UIImage imageNamed:@"top_tool_bar_background.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBarImage
                                       forBarMetrics:UIBarMetricsDefault];
    
}

- (void)configRestKit
{
    RKURL *baseURL = [RKURL URLWithBaseURLString:@"http://ruby-china.org/api/"];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    objectManager.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    NSString *storeFilename = @"RubyChina.sqlite";
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *storePath = [docDir stringByAppendingPathComponent:storeFilename];
    
    // core data seed
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:storePath]) {
        NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"node_seed" ofType:@"sqlite"];
        if (seedPath) {
            [fileManager copyItemAtPath:seedPath toPath:storePath error:nil];
        }
    }
    
    RKManagedObjectStore *objectStore = [RKManagedObjectStore objectStoreWithStoreFilename: storeFilename];
    objectManager.objectStore = objectStore;
    
    // Topic Object Mapping
    RKObjectMapping *topicMapping = [RKObjectMapping mappingForClass:[Topic class]];
    [topicMapping mapKeyPath:@"id" toAttribute:@"topicID"];
    [topicMapping mapKeyPath:@"title" toAttribute:@"title"];
    [topicMapping mapKeyPath:@"body" toAttribute:@"body"];
    [topicMapping mapKeyPath:@"body_html" toAttribute:@"bodyHtml"];
    [topicMapping mapKeyPath:@"replies_count" toAttribute:@"repliesCount"];
    [topicMapping mapKeyPath:@"created_at" toAttribute:@"createdDate"];
    [topicMapping mapKeyPath:@"replied_at" toAttribute:@"repliedAt"];
    [topicMapping mapKeyPath:@"node_name" toAttribute:@"nodeName"];
    [topicMapping mapKeyPath:@"last_reply_user_login" toAttribute:@"lastReplyUserLogin"];
    [objectManager.mappingProvider setObjectMapping:topicMapping forKeyPath:@""];

    [objectManager.mappingProvider setObjectMapping:topicMapping forResourcePathPattern:@"/topics.json"];
    [objectManager.mappingProvider setObjectMapping:topicMapping forResourcePathPattern:@"/topics/node/:id.json"];
    [objectManager.mappingProvider setObjectMapping:topicMapping forResourcePathPattern:@"/topics/:id.json"];
    [objectManager.mappingProvider setObjectMapping:topicMapping forResourcePathPattern:@"/users/:user/favorite.json"];
    
    // User Object Mapping
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping mapKeyPathsToAttributes:@"id", @"userID", @"name", @"name", @"login", @"login", @"email", @"email", @"location", @"location", @"company", @"company", @"twitter", @"twitter", @"website", @"website", @"bio", @"bio", @"tagline", @"tagline", @"github_url", @"githubUrl", @"gravatar_hash", @"gravatarHash", @"avatar_url", @"avatarUrl" ,nil];
    [objectManager.mappingProvider setObjectMapping:userMapping forResourcePathPattern:@"/users/:user.json"];
    
    // Reply Object Mapping
    RKObjectMapping *replyMapping = [RKObjectMapping mappingForClass:[Reply class]];
    [replyMapping mapKeyPathsToAttributes:@"id", @"replyID", @"body", @"body", @"body_html", @"bodyHtml", @"created_at", @"createdDate", @"updated_at", @"updatedDate", nil];
//    [objectManager.mappingProvider setObjectMapping:replyMapping forKeyPath:@"replies"];
    
    
    [topicMapping hasMany:@"replies" withMapping:replyMapping];
    [topicMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
    [userMapping hasMany:@"topics" withMapping:topicMapping];
    [replyMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[[RKObjectManager sharedManager] objectStore] save:nil];
}
@end
