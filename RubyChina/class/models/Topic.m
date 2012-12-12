//
//  Topic.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-14.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import "Topic.h"

@implementation Topic

@synthesize topicID = _topicID;
@synthesize title = _title;
@synthesize body = _body;
@synthesize user = _user;
@synthesize repliesCount = _repliesCount;
@synthesize replies = _replies;

- (NSString *)description
{
    return [NSString stringWithFormat:@"Topic: topicID -> %@, title -> %@, repliesCount -> %@, user -> [%@], replies -> [%@]", _topicID, _title, _repliesCount, _user, _replies];
}

@end
