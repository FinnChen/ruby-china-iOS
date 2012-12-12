//
//  Reply.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-22.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import "Reply.h"

@implementation Reply

- (NSString *)description
{
    return [NSString stringWithFormat:@"replyID:%@ userID:%@", self.replyID, self.user.userID];
}

@end
