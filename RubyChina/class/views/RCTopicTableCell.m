//
//  RCTopicTableCell.m
//  RubyChina
//
//  Created by 陈锋 on 12-11-15.
//  Copyright (c) 2012年 ÈôàÈîã. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RCTopicTableCell.h"
#import <UIImageView+AFNetworking.h>
#import "NSDate+Timeago.h"

#define kTextLabelFontSize       14.0f
#define kDetailTextLabelFontSize 14.0f
#define kTimestampLabelFontSize  12.0f
#define KNodeLabelFontSize       11.5f

@interface RCTopicTableCell ()

@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) UILabel *nodeLabel;

@end

@implementation RCTopicTableCell

@synthesize topic = _topic;
@synthesize timestampLabel = _timestampLabel;
@synthesize nodeLabel = _nodeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    self.textLabel.text = [NSString stringWithFormat:@"@%@", _topic.user.login];
    self.detailTextLabel.text = _topic.title;
    [self.imageView setImageWithURL:[NSURL URLWithString:_topic.user.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar.png"]];

    if (topic.lastReplyUserLogin) {
        self.timestampLabel.text = [_topic.repliedAt timeAgo];
        self.nodeLabel.text = [NSString stringWithFormat:@"[%@] 最后由 %@ 回复", _topic.nodeName, _topic.lastReplyUserLogin];
    } else {
        self.timestampLabel.text = [_topic.createdDate timeAgo];
        self.nodeLabel.text = [NSString stringWithFormat:@"[%@] 由 %@ 创建", _topic.nodeName, _topic.user.login];
    }
    
    NSNumber *repliesCount = topic.repliesCount;

    if ([repliesCount compare:@0] == NSOrderedDescending) {
        [(UIButton *)self.accessoryView setTitle:[NSString stringWithFormat:@"%@", repliesCount] forState:UIControlStateNormal];
        self.accessoryView.hidden = NO;
    } else {
        self.accessoryView.hidden = YES;
    }

    [self setNeedsLayout];
}

- (void)customUI
{

    self.textLabel.font = [UIFont boldSystemFontOfSize:kTextLabelFontSize];
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:kDetailTextLabelFontSize];
    self.detailTextLabel.textColor = [UIColor darkTextColor];
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    UIButton *accessory = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = accessory.frame;
    frame.size.width = 28.0f;
    frame.size.height = 16.0f;
    accessory.frame = frame;
    accessory.backgroundColor = [UIColor lightGrayColor];
    accessory.layer.cornerRadius = 8.0f;
    accessory.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    accessory.selected = YES;
    self.accessoryView = accessory;
    self.accessoryView.hidden = YES;
    
    _timestampLabel = [[UILabel alloc] init];
    _timestampLabel.font = [UIFont systemFontOfSize:kTimestampLabelFontSize];
    _timestampLabel.textColor = [UIColor blueColor];
    _timestampLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timestampLabel];
    
    _nodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    _nodeLabel.backgroundColor = [UIColor lightGrayColor];
    _nodeLabel.font = [UIFont systemFontOfSize:KNodeLabelFontSize];
    _nodeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_nodeLabel];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0f, 10.0f, 48.0f, 48.0f);
    self.textLabel.frame = CGRectMake(70.0f, 10.0f, 200.0f, 20.0f);
    
    [self.timestampLabel sizeToFit];
    CGRect timestampFrame = self.timestampLabel.frame;
    timestampFrame.origin.x = 320.0f - 10.0f - timestampFrame.size.width;
    timestampFrame.origin.y = 12.5f;
    self.timestampLabel.frame = timestampFrame;

    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    self.detailTextLabel.frame = detailTextLabelFrame;
    [self.detailTextLabel sizeToFit];
    
//    [self.nodeLabel sizeToFit];
//    CGRect nodeLabelFrame = self.nodeLabel.frame;
    CGRect nodeLabelFrame = CGRectOffset(self.detailTextLabel.frame, 0.0f, self.detailTextLabel.frame.size.height + 10.0f);
//    nodeLabelFrame.origin.x = 70.0f;
//    nodeLabelFrame.origin.y = [[self class] heightForCellWithTopic:self.topic] - nodeLabelFrame.size.height - 10.0f;
    self.nodeLabel.frame = nodeLabelFrame;
    [self.nodeLabel sizeToFit];
    
}

+ (CGFloat)heightForCellWithTopic:(Topic *)topic
{
    CGSize textLabelSize = [topic.user.login sizeWithFont:[UIFont systemFontOfSize:kTextLabelFontSize]];
    CGSize detailLabelSize = [topic.title sizeWithFont:[UIFont systemFontOfSize:kDetailTextLabelFontSize] constrainedToSize:CGSizeMake(200.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    CGSize nodeLabelSize = [topic.nodeName sizeWithFont:[UIFont systemFontOfSize:KNodeLabelFontSize]];
    return fmaxf(70.0f, textLabelSize.height + detailLabelSize.height + nodeLabelSize.height + 40.0f);
}

@end
