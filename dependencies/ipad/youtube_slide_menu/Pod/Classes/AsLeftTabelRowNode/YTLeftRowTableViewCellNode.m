//
//  YTLeftRowTableViewCellNode.m
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "YTLeftRowTableViewCellNode.h"
#import "FrameCalculator.h"
#import "Foundation.h"
#import "ASCacheNetworkImageNode.h"
#import "AsyncDisplayKitStatic.h"
#import "YTAsChannelThumbnailsImageNode.h"

static CGFloat ROW_TITLE_FONT_SIZE = 16;


@interface YTLeftRowTableViewCellNode () {

   ASImageNode * _videoChannelThumbnailsNode;
   ASTextNode * _channelTitleTextNode;
}


@end


@implementation YTLeftRowTableViewCellNode

- (instancetype)initWithNodeCellSize:(struct CGSize const)nodeCellSize lineTitle:(NSString *)lineTitle lineIconUrl:(NSString *)lineIconUrl isRemoteImage:(BOOL)isRemoteImage {
   self = [super init];
   if (self) {
      self.nodeCellSize = nodeCellSize;
      self.lineTitle = lineTitle;
      self.lineIconUrl = lineIconUrl;
      self.isRemoteImage = isRemoteImage;

      [self rowThirdForChannelInfo];
      [self layoutSubNodes];
      [self setupAllNodesEffect];
   }

   return self;
}


#pragma mark -
#pragma mark Setup sub nodes.


- (void)setupAllNodesEffect {

   // 1
   self.layerBacked = true;
   self.backgroundColor = [UIColor clearColor];

   [self effectThirdForChannelInfo];
}


- (void)layoutSubNodes {
   //MARK: Node Layout Section
   self.frame = [FrameCalculator frameForContainer:self.nodeCellSize];

   [self layoutThirdForChannelInfo];
}


#pragma mark -
#pragma mark third row for channel title.(Row N03)


- (void)rowThirdForChannelInfo {
   // 1
   [self showSubscriptionThumbnail];

   // 2
   _channelTitleTextNode = [ASTextNode initWithAttributedString:
    [NSAttributedString attributedStringForLeftMenuSubscriptionTitleText:self.lineTitle fontSize:ROW_TITLE_FONT_SIZE]];

   [self addSubnode:_channelTitleTextNode];
}


- (void)showSubscriptionThumbnail {
   if (self.isRemoteImage) {
      _videoChannelThumbnailsNode = [YTAsChannelThumbnailsImageNode nodeWithThumbnailUrl:self.lineIconUrl
                                                                               forCorner:4.0f];
   } else {
      _videoChannelThumbnailsNode = [ASImageNode initWithImageNamed:self.lineIconUrl];
   }

   [self addSubnode:_videoChannelThumbnailsNode];
}


- (void)layoutThirdForChannelInfo {
   _videoChannelThumbnailsNode.frame = [FrameCalculator frameForLeftMenuSubscriptionThumbnail:self.nodeCellSize];


   _channelTitleTextNode.frame =
    [FrameCalculator frameForLeftMenuSubscriptionTitleText:self.nodeCellSize
                                             leftNodeFrame:_videoChannelThumbnailsNode.frame
                                            withFontHeight:ROW_TITLE_FONT_SIZE];

}


- (void)effectThirdForChannelInfo {
   // 1
   _videoChannelThumbnailsNode.layerBacked = true;

   // 2
   _channelTitleTextNode.layerBacked = true;
   _channelTitleTextNode.backgroundColor = [UIColor clearColor];
}


@end
