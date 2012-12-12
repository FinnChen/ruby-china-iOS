//
//  UIViewController+RubyChina.m
//  RubyChina
//
//  Created by 陈锋 on 12-12-4.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import "UIViewController+RubyChina.h"
#import "RCSideContainerViewController.h"

@implementation UIViewController (RubyChina)
- (void)setTitle:(NSString *)title
{
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        //        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor darkTextColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}
@end
