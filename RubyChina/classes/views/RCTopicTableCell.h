//
//  RCTopicTableCell.h
//  RubyChina
//
//  Created by 陈锋 on 12-11-15.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@interface RCTopicTableCell : UITableViewCell
@property (nonatomic, strong) Topic *topic;

+ (CGFloat)heightForCellWithTopic:(Topic *)topic;
@end
