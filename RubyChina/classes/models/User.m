//
//  User.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-15.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userID = _userID;
@synthesize name = _name;
@synthesize login = _login;
@synthesize email = _email;
@synthesize location = _location;
@synthesize company = _company;
@synthesize twitter = _twitter;
@synthesize website = _website;
@synthesize bio = _bio;
@synthesize tagline = _tagline;
@synthesize githubUrl = _githubUrl;
@synthesize gravatarHash = _gravatarHash;
@synthesize avatarUrl = _avatarUrl;
@synthesize topics = _topics;

- (NSString *)description
{
    return [NSString stringWithFormat:@"user: userID -> %@, name -> %@, login -> %@, topids -> %@", _userID, _name, _login, _topics];
}
@end
