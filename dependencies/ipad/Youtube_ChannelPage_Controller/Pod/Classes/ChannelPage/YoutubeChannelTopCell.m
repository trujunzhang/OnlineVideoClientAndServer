//
//  YoutubeChannelTopCell.m
//  IOSTemplate
//
//  Created by djzhang on 11/12/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import <google-api-services-youtube/GYoutubeHelper.h>
#import "YoutubeChannelTopCell.h"
#import "YoutubeParser.h"
#import "CacheImageConstant.h"


@implementation YoutubeChannelTopCell

- (instancetype)initWithSubscription:(id)subscription {
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"YoutubeChannelTopCell" owner:self options:nil];
    UIView *mainView = [subviewArray objectAtIndex:0];
    if(self) {
        self.shadowView.backgroundColor = [UIColor whiteColor];

        self.shadowView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.shadowView.layer.shadowOffset = CGSizeMake(2, 2);
        self.shadowView.layer.shadowOpacity = 1;
        self.shadowView.layer.shadowRadius = 1.0;

        [self bind:subscription];
    }
    return mainView;
}


- (void)bind:(id)subscription {

//   [YTCacheImplement CacheWithImageView:self.channelPhoto
//                                withUrl:[YoutubeParser getSubscriptionSnippetThumbnailUrl:subscription]
//                        withPlaceholder:[UIImage imageNamed:@"account_default_thumbnail.png"]
//   ];

    YoutubeResponseBlock completion = ^(NSArray *array, NSObject *respObject) {
        self.currentChannel = array[0];

        NSString *url = [YoutubeParser getChannelBannerImageUrl:self.currentChannel];
        [YTCacheImplement CacheWithImageView:self.youtubeCover
                                     withUrl:url
                             withPlaceholder:[UIImage imageNamed:@"channel_default_banner.jpg"]
//                                          size:CGSizeMake(32, 32)];
        ];

    };
    ErrorResponseBlock error = ^(NSError *error) {
        NSString *debug = @"debug";
    };
//   [[GYoutubeHelper getInstance] fetchChannelListWithIdentifier:[YoutubeParser getChannelIdBySubscription:subscription]
//                                                     completion:completion
//                                                   errorHandler:error];

//   [YTCacheImplement CacheWithImageView:self.channelPhoto
//                                   withUrl:subscription.snippet.thumbnails.high.url
//                           withPlaceholder:[UIImage imageNamed:@"account_default_thumbnail.png"]
//   ];

//   [self.channelTitle setText:subscription.snippet.title];

}
@end
