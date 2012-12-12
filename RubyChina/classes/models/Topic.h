//
//  Topic.h
//  RubyChina
//
//  Created by 陈锋 on 12-11-14.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Topic : NSObject

@property (nonatomic) NSNumber *topicID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *bodyHtml;
@property (nonatomic, strong) NSNumber *repliesCount;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSDate *repliedAt;
@property (nonatomic, copy) NSString *nodeName;
@property (nonatomic, strong) NSNumber *nodeId;
@property (nonatomic, strong) User *user;
@property (nonatomic, copy) NSString *lastReplyUserLogin;
@property (nonatomic, strong) NSMutableArray *replies;

@end
