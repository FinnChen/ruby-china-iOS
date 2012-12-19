//
//  RCTopicDetailViewController.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-17.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import "RCTopicDetailViewController.h"
#import "UIBarButtonItem+RubyChina.h"
#import <UIImageView+AFNetworking.h>
#import <RestKit.h>
#import "Reply.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
#import "RCReplyViewController.h"
#import "RCUserViewController.h"

#define RC_USER_SCHEME @"rcuser://"
#define RC_REPLY       @"rcreply://"

@interface RCTopicDetailViewController () <RKObjectLoaderDelegate, RCReplyDelegate, UIScrollViewDelegate, UIWebViewDelegate>

@end

@implementation RCTopicDetailViewController
@synthesize webView = _webView;
@synthesize topic = _topic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.frame.size.height)];
        _webView.delegate = self;
    }
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
    return _webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"top_bar_back_btn.png"] highLightedImage:[UIImage imageNamed:@"top_bar_back_btn_pressed.png"] target:self action:@selector(backbuttonPressed)];
    
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replyButton setTitle:@"评论"forState:UIControlStateNormal] ;
    replyButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    [replyButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [replyButton setBackgroundImage:[UIImage imageNamed:@"search_page_cancel_btn.png"] forState:UIControlStateNormal];
    [replyButton setBackgroundImage:[UIImage imageNamed:@"search_page_cancel_btn_pressed.png"] forState:UIControlStateHighlighted];
    replyButton.frame = (CGRect){CGPointZero, [[UIImage imageNamed:@"search_page_cancel_btn.png"] size]};
    [replyButton addTarget:self action:@selector(replyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:replyButton];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"/topics/%@.json", _topic.topicID] delegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [[[RKObjectManager sharedManager] requestQueue] cancelAllRequests];
    [_webView stopLoading];
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

- (void)replyButtonPressed
{
    RCReplyViewController *rvc = [[RCReplyViewController alloc] init];
    rvc.replyDelegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:rvc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)loadHTML
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *base = [NSURL fileURLWithPath:path];
    
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
	[engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    [engine setObject:_topic forKey:@"topic"];
    
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"topic_detail" ofType:@"tmpl"];
    
	NSString *result = [engine processTemplateInFileAtPath:templatePath withVariables:nil];
    [self.webView loadHTMLString:result baseURL:base];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    _topic = nil;
    _topic = object;
    [self loadHTML];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

#pragma mark - UIWebView Delegate mehtods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    if ([[url absoluteString] hasPrefix:RC_USER_SCHEME]) {
        RCUserViewController *userContrller = [[RCUserViewController alloc] initWithNibName:@"RCUserViewController" bundle:nil];
        userContrller.userLogin = [url host];
        [self.navigationController pushViewController:userContrller animated:YES];
        return NO;
    }
    
    if ([[url absoluteString] hasPrefix:RC_REPLY]) {
        NSArray *array = [[[url absoluteString] substringFromIndex:[RC_REPLY length]] componentsSeparatedByString:@"#"];
        NSString *floor = [array objectAtIndex:0];
        NSString *replyTo = [array lastObject];
        
        RCReplyViewController *replyController = [[RCReplyViewController alloc] init];
        replyController.replyDelegate = self;
        replyController.textView.text = [NSString stringWithFormat:@"#%@楼 @%@ ", floor, replyTo];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:replyController];
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
    }
    
    if ([[url absoluteString] hasPrefix:@"http://"] || [[url absoluteString] hasPrefix:@"https"]) {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

#pragma mark - RCReplyDelegate methods

- (void)replyWithBody:(NSString *)body
{
    RKClient *client = [[RKObjectManager sharedManager] client];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNNING!" message:@"请设置密钥后重新发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert show];

    [client post:[NSString stringWithFormat: @"/topics/%@/replies.json?token=%@", _topic.topicID, token] usingBlock:^(RKRequest *request) {
        NSDictionary *params =[NSDictionary dictionaryWithKeysAndObjects:@"id", _topic.topicID, @"body", body, nil];
        [request setParams:params];
    }];
}


@end
