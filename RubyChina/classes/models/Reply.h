//
//  Reply.h
//  RubyChina
//
//  Created by 陈锋 on 12-11-22.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Reply : NSObject
@property (nonatomic, strong) NSNumber *replyID;
@property (nonatomic, copy)   NSString   *body;
@property (nonatomic, copy)   NSString   *bodyHtml;
@property (nonatomic, strong) NSDate     *createdDate;
@property (nonatomic, strong) NSDate     *updatedDate;
@property (nonatomic, strong) User       *user;
@end
