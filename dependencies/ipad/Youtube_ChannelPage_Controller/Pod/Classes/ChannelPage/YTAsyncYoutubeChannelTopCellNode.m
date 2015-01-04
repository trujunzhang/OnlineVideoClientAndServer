//
//  YTAsyncYoutubeChannelTopCellNode.m
//  IOSTemplate
//
//  Created by djzhang on 11/12/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <google-api-services-youtube/GYoutubeHelper.h>
#import "YTAsyncYoutubeChannelTopCellNode.h"

#import "YoutubeParser.h"
#import "FrameCalculator.h"
#import "ASCacheNetworkImageNode.h"
#import "HexColor.h"
#import "Foundation.h"
#import "AsCacheMultiplexImageNode.h"

static const int TOP_CHANNEL_SECOND_ROW_HEIGHT = 48;


@interface YTAsyncYoutubeChannelTopCellNode () {
   // line01
   ASImageNode * _channelBannerThumbnailNode;
   ASImageNode * _channelThumbnailsNode;

   // line02
   ASTextNode * _channelTitleTextNode;
   ASTextNode * _channelSubscriptionCountTextNode;

   // line03
   ASDisplayNode * _divider;
}
@property(nonatomic) CGSize nodeCellSize;
@property(nonatomic, strong) YTYouTubeChannel * pageChannel;


@end


@implementation YTAsyncYoutubeChannelTopCellNode

- (instancetype)initWithChannel:(id)channel {
   self = [super init];
   if (self) {
      self.pageChannel = channel;

      [self setupContainerNode];
      [self setupAllNodesEffect];
   }

   return self;
}


- (void)layout {
   self.nodeCellSize = self.view.bounds.size;
   [self layoutSubNodes];
}


#pragma mark -
#pragma mark Setup sub nodes.


- (void)setupContainerNode {
   [self rowFirstForChannelBanner];
   [self rowSecondForChannelInfo];
   [self rowThirdForDivide];
}


- (void)setupAllNodesEffect {

   // 1.1
   self.backgroundColor = [UIColor whiteColor];

   // 1.2
   self.shadowColor = [UIColor colorWithHexString:@"B5B5B5" alpha:0.8].CGColor;
   self.shadowOffset = CGSizeMake(1, 3);
   self.shadowOpacity = 1.0;
   self.shadowRadius = 2.0;

   [self effectFirstForChannelBanner];
   [self effectSecondForChannelInfo];
   [self effectThirdForDivide];
}


- (void)layoutSubNodes {
   //MARK: Node Layout Section
   self.frame = [FrameCalculator frameForContainer:self.nodeCellSize];

   [self layoutFirstForChannelBanner];
   [self layoutSecondForChannelInfo];
   [self layoutThirdForDivide];
}


#pragma mark -
#pragma mark first row for channel clover.(Row N01)


- (void)rowFirstForChannelBanner {
   ASImageNode * imageNode = [self getImageNodeForChannelBanner];

   imageNode.contentMode = UIViewContentModeScaleToFill;

   _channelBannerThumbnailNode = imageNode;
   [self addSubnode:_channelBannerThumbnailNode];

   // 2
   [self showChannelThumbnail:[YoutubeParser getChannelSnippetThumbnail:self.pageChannel]];
}


- (ASImageNode *)getImageNodeForChannelBanner {
   ASCacheNetworkImageNode * node =
    [[ASCacheNetworkImageNode alloc] initWithPlaceHolder:[UIImage imageNamed:@"channel_default_banner.jpg"]];

   [node startFetchImageWithString:[YoutubeParser getChannelBannerImageUrl:self.pageChannel]];

   return node;
}


- (void)showChannelThumbnail:(NSString *)channelThumbnailUrl {
   ASCacheNetworkImageNode * channelThumbnailsNode = [ASCacheNetworkImageNode nodeWithImageUrl:channelThumbnailUrl];

   _channelThumbnailsNode = channelThumbnailsNode;
   [self addSubnode:_channelThumbnailsNode];
}


- (void)layoutFirstForChannelBanner {
   _channelBannerThumbnailNode.frame = [FrameCalculator frameForPageChannelBannerThumbnails:self.nodeCellSize
                                                                       secondRowFrameHeight:TOP_CHANNEL_SECOND_ROW_HEIGHT];

   _channelThumbnailsNode.frame = [FrameCalculator frameForPageChannelThumbnails:self.frame.size];
}


- (void)effectFirstForChannelBanner {
   _channelBannerThumbnailNode.contentMode = UIViewContentModeScaleToFill;
}


#pragma mark -
#pragma mark second row for channel title.(Row N02)


- (void)rowSecondForChannelInfo {
   // 1
   ASTextNode * channelTitleTextNode = [[ASTextNode alloc] init];
   channelTitleTextNode.attributedString =
    [NSAttributedString attributedStringForPageChannelTitleText:[YoutubeParser getChannelBrandingSettingsTitle:self.pageChannel]];

   //MARK: Container Node Creation Section
   _channelTitleTextNode = channelTitleTextNode;
   [self addSubnode:_channelTitleTextNode];

   // 2
   ASTextNode * channelSubscriptionCountTextNode = [[ASTextNode alloc] init];
   channelSubscriptionCountTextNode.attributedString =
    [NSAttributedString attributedStringForChannelStatisticsSubscriberCount:[YoutubeParser getChannelStatisticsSubscriberCount:self.pageChannel]];

   //MARK: Container Node Creation Section
   _channelSubscriptionCountTextNode = channelSubscriptionCountTextNode;
   [self addSubnode:_channelSubscriptionCountTextNode];

   // 3

}


- (void)layoutSecondForChannelInfo {
   _channelTitleTextNode.frame = [FrameCalculator frameForPageChannelTitle:self.nodeCellSize
                                                      secondRowFrameHeight:TOP_CHANNEL_SECOND_ROW_HEIGHT];

   _channelSubscriptionCountTextNode.frame =
    [FrameCalculator frameForPageChannelStatisticsSubscriberCount:self.nodeCellSize
                                             secondRowFrameHeight:TOP_CHANNEL_SECOND_ROW_HEIGHT];

}


- (void)effectSecondForChannelInfo {
   // 3
   _channelTitleTextNode.backgroundColor = [UIColor clearColor];
}


#pragma mark -
#pragma mark second row for divide.(Row N03)


- (void)rowThirdForDivide {
   // hairline cell separator
   _divider = [[ASDisplayNode alloc] init];
   _divider.backgroundColor = [UIColor colorWithHexString:@"EAEAEA" alpha:1.0];
   [self addSubnode:_divider];
}


- (void)layoutThirdForDivide {
   _divider.frame = [FrameCalculator frameForDivider:self.nodeCellSize thirdRowHeight:0];

}


- (void)effectThirdForDivide {

}


@end
