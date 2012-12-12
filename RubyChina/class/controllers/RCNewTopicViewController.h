//
//  RCNewTopicViewController.h
//  RubyChina
//
//  Created by 陈锋 on 12-11-27.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCNewTopicViewController : UIViewController

@property (strong, nonatomic) NSArray *nodes;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *nodeButton;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *nodePickerView;

- (IBAction)nodeButtonPressed:(id)sender;
@end
