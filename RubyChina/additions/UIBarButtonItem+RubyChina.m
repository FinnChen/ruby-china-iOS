//
//  UIBarButtonItem+RubyChina.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-17.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import "UIBarButtonItem+RubyChina.h"

@implementation UIBarButtonItem (RubyChina)

+ (UIBarButtonItem *)barItemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.frame= CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)barItemWithImage:(UIImage *)image highLightedImage:(UIImage *)highLightedImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highLightedImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

@end
