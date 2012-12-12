//
//  UIBarButtonItem+RubyChina.h
//  RubyChina
//
//  Created by 陈锋 on 12-11-17.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (RubyChina)

+ (UIBarButtonItem *)barItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barItemWithImage:(UIImage *)image highLightedImage:(UIImage *)highLightedImage target:(id)target action:(SEL)action;

@end
