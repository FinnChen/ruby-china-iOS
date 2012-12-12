//
//  Node.h
//  RubyChina
//
//  Created by 陈锋 on 12-11-14.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>

@interface Node : NSManagedObject
@property (nonatomic, strong) NSNumber *nodeID;
@property (nonatomic, copy) NSString *nodeName;
@property (nonatomic, strong) NSNumber *showable;
@property (nonatomic, copy) NSNumber *weight;

@end
