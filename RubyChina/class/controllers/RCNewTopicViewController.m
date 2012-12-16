//
//  RCNewTopicViewController.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-27.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RCNewTopicViewController.h"
#import "Node.h"
#import "UIBarButtonItem+RubyChina.h"
#import "UIViewController+RubyChina.h"

@interface RCNewTopicViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) NSNumber *selectedNodeID;

@end

@implementation RCNewTopicViewController

@synthesize nodes = _nodes;
@synthesize titleTextField = _titleTextField;
@synthesize nodeButton = _nodeButton;
@synthesize bodyTextView = _bodyTextView;
@synthesize nodePickerView = _nodePickerView;

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
    
    self.title = @"新建帖子";
    
    UIImage *bgImg = [UIImage imageNamed:@"bg.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    
    _nodePickerView.hidden = YES;
    _bodyTextView.layer.borderWidth = 1.0f;
    _bodyTextView.layer.cornerRadius = 8.0f;
    _bodyTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"发布"forState:UIControlStateNormal] ;
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [doneButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"search_page_cancel_btn.png"] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"search_page_cancel_btn_pressed.png"] forState:UIControlStateHighlighted];
    doneButton.frame = (CGRect){CGPointZero, [[UIImage imageNamed:@"search_page_cancel_btn.png"] size]};
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    UIBarButtonItem *cancelButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"top_bar_close_btn_pressed.png"] highLightedImage:[UIImage imageNamed:@"top_bar_close_btn_pressed.png"] target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
    [self loadNode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNode
{
    NSFetchRequest *request = [Node fetchRequest];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nodeID" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    _nodes = [Node objectsWithFetchRequest:request];
}

- (void)doneButtonPressed
{
    RKClient *client = [[RKObjectManager sharedManager] client];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNNING!" message:@"请设置密钥后重新发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //    [alert show];
    
    NSString *title = [_titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *body = [_bodyTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    // http://ruby-china.org/api/topics.json
    [client post:[NSString stringWithFormat: @"/topics.json?token=%@", token]
            usingBlock:^(RKRequest *request) {
                
                NSDictionary *params = [NSDictionary dictionaryWithObjects:@[title, body, _selectedNodeID]
                                                                   forKeys:@[@"title", @"body", @"node_id"]];
        
                [request setParams:params];
    }];
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nodeButtonPressed:(id)sender
{
    if (_nodePickerView.hidden == NO) {
        return;
    }
    
    [_titleTextField resignFirstResponder];
    [_bodyTextView resignFirstResponder];
    
    _nodePickerView.hidden = NO;
    [_nodePickerView selectRow:2 inComponent:0 animated:NO];
}

- (void)tapOnView:(UIGestureRecognizer *)recognizer
{
    [_titleTextField resignFirstResponder];
    _nodePickerView.hidden = YES;
    [_bodyTextView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _bodyTextView.frame;
        frame.size.height = 70.0f;
        _bodyTextView.frame = frame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _bodyTextView.frame;
        frame.size.height = 180.0f;
        _bodyTextView.frame = frame;
    }];
}

#pragma mark - UIGestureRecognizer methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view != self.view) {
        return NO;
    }
    
    return YES;
}
#pragma mark - UIPickerViewDataSource methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _nodes.count;
}

#pragma mark - UIPickerViewDelegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Node *node = [_nodes objectAtIndex:row];
    return node.nodeName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Node *node = [_nodes objectAtIndex:row];
    [_nodeButton setTitle:node.nodeName forState:UIControlStateNormal];
    _selectedNodeID = node.nodeID;
}
@end
