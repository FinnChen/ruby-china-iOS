//
//  RCReplyViewController.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-25.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import "RCReplyViewController.h"
#import "UIBarButtonItem+RubyChina.h"
#import "UIViewController+RubyChina.h"

@interface RCReplyViewController ()

@end

@implementation RCReplyViewController

@synthesize textView = _textView;
@synthesize replyDelegate = _replyDelegate;

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 200.0f)];
        _textView.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    }
    return _textView;
}

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
    self.title = @"评论";
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"发布"forState:UIControlStateNormal] ;
    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    [doneButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"search_page_cancel_btn.png"] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"search_page_cancel_btn_pressed.png"] forState:UIControlStateHighlighted];
    doneButton.frame = (CGRect){CGPointZero, [[UIImage imageNamed:@"search_page_cancel_btn.png"] size]};
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    UIBarButtonItem *cancelButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"top_bar_close_btn_pressed.png"] highLightedImage:[UIImage imageNamed:@"top_bar_close_btn_pressed.png"] target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    [self.view addSubview:self.textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name: UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneButtonPressed
{
    NSString *body = self.textView.text;
    if (body.length > 0) {
        [self.replyDelegate replyWithBody:body];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardFrameChanged:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect textViewFrame = self.textView.frame;
    textViewFrame.size.height = 480 - 64 - [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.textView.frame = textViewFrame;
}

@end
