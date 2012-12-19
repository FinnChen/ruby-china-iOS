//
//  RCSettingViewController.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-25.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import "RCSettingViewController.h"
#import "UIViewController+RubyChina.h"

#define kTokenTextFiledTag 100
#define kUsernameTextFieldTag 101

@interface RCSettingViewController () <UITextFieldDelegate>

@end

@implementation RCSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIImage *bgImg = [UIImage imageNamed:@"bg.png"];
        self.view.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成"forState:UIControlStateNormal] ;
    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    [doneButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"search_page_cancel_btn.png"] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"search_page_cancel_btn_pressed.png"] forState:UIControlStateHighlighted];
    doneButton.frame = (CGRect){CGPointZero, [[UIImage imageNamed:@"search_page_cancel_btn.png"] size]};
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 60.0f, 20.0f)];
        label.text = indexPath.row == 1 ? @"密钥:" : @"用户名:";
        label.textAlignment = UITextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
//        [label sizeToFit];
        label.center = CGPointMake(label.center.x, cell.center.y);
        [cell.contentView addSubview:label];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f + label.frame.size.width, 5.0f, 218.0f, 30.0f)];
        textField.center = CGPointMake(textField.center.x, cell.center.y);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if (indexPath.row == 1) {
            if ([[defaults objectForKey:@"token"] length]) {
                textField.text = [defaults objectForKey:@"token"];
            } else {
                textField.placeholder = @"请输入token...";
            }
            textField.tag = kTokenTextFiledTag;
        } else {
            if ([[defaults objectForKey:@"username"] length]) {
                textField.text = [defaults objectForKey:@"username"];
            } else {
                textField.placeholder = @"请输入用户名...";
            }
            textField.tag = kUsernameTextFieldTag;
        }
        
        textField.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        textField.secureTextEntry = YES;
        textField.delegate = self;
        [cell.contentView addSubview:textField];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (textField.tag == kTokenTextFiledTag) {
            [defaults setObject:textField.text forKey:@"token"];
        }
        if (textField.tag == kUsernameTextFieldTag) {
            [defaults setObject:textField.text forKey:@"username"];
        }
        [defaults synchronize];
}

@end
