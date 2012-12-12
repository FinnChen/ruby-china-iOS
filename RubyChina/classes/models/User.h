//
//  User.h
//  RubyChina
//
//  Created by 陈锋 on 12-11-15.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *login;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *twitter;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *tagline;
@property (nonatomic, copy) NSString *githubUrl;
@property (nonatomic, copy) NSString *gravatarHash;
@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, strong) NSMutableArray *topics;

@end
