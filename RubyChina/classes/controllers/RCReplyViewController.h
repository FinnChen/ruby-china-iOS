//
//  RCReplyViewController.h
//  RubyChina
//
//  Created by 陈锋 on 12-11-25.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCReplyDelegate;

@interface RCReplyViewController : UIViewController
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) id<RCReplyDelegate> replyDelegate;
@end

@protocol RCReplyDelegate <NSObject>

- (void)replyWithBody:(NSString *)body;

@end