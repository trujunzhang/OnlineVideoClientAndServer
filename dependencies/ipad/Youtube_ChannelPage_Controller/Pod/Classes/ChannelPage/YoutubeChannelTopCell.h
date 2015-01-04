//
//  YoutubeChannelTopCell.h
//  IOSTemplate
//
//  Created by djzhang on 11/12/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoutubeConstants.h"


@interface YoutubeChannelTopCell : UIView

@property(strong, nonatomic) IBOutlet UIView * shadowView;


@property(strong, nonatomic) IBOutlet UIImageView * youtubeCover;

@property(strong, nonatomic) IBOutlet UIImageView * channelPhoto;

@property(strong, nonatomic) IBOutlet UILabel * channelTitle;

@property(strong, nonatomic) IBOutlet UILabel * channelSubscriberCount;

@property(strong, nonatomic) IBOutlet UIButton * channelSubscribedState;


@property(nonatomic, strong) YTYouTubeChannel * currentChannel;

- (instancetype)initWithSubscription:(id)subscription;
@end
