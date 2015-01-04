//
//  YTAsLeftTableCellNode.m
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "YTAsLeftTableCellNode.h"
#import "FrameCalculator.h"

#import "Foundation.h"

#import "ASCacheNetworkImageNode.h"
#import "AsyncDisplayKitStatic.h"
#import "YTAsChannelThumbnailsImageNode.h"

static CGFloat ASROW_TITLE_FONT_SIZE = 16;


@interface YTAsLeftTableCellNode () {

   CGSize _nodeCellSize;

   ASImageNode * _videoChannelThumbnailsNode;
   ASTextNode * _channelTitleTextNode;
}


@end


@implementation YTAsLeftTableCellNode

- (instancetype)initWithNodeCellSize:(struct CGSize const)nodeCellSize lineTitle:(NSString *)lineTitle lineIconUrl:(NSString *)lineIconUrl isRemoteImage:(BOOL)isRemoteImage {
   self = [super init];
   if (self) {
      _nodeCellSize = nodeCellSize;

      // 1
      [self showSubscriptionThumbnail:isRemoteImage lineIconUrl:lineIconUrl];

      // 2
      _channelTitleTextNode = [ASTextNode initWithAttributedString:
       [NSAttributedString attributedStringForLeftMenuSubscriptionTitleText:lineTitle fontSize:ASROW_TITLE_FONT_SIZE]];

      [self addSubnode:_channelTitleTextNode];

      // 1
      self.backgroundColor = [UIColor clearColor];
      _channelTitleTextNode.backgroundColor = [UIColor clearColor];

   }

   return self;
}


#pragma mark -
#pragma mark third row for channel title.(Row N03)


- (void)showSubscriptionThumbnail:(BOOL)isRemoteImage lineIconUrl:(NSString *)lineIconUrl {
   if (isRemoteImage) {
      _videoChannelThumbnailsNode = [YTAsChannelThumbnailsImageNode nodeWithThumbnailUrl:lineIconUrl
                                                                               forCorner:4.0f];
   } else {
      _videoChannelThumbnailsNode = [ASImageNode initWithImageNamed:lineIconUrl];
   }

   [self addSubnode:_videoChannelThumbnailsNode];
}


#pragma mark -
#pragma mark


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {

//   CGSize measuredSize = [_channelTitleTextNode measure:CGSizeMake(constrainedSize.width - 40,
//    constrainedSize.height)];
//   return CGSizeMake(constrainedSize.width, measuredSize.height);

   return _nodeCellSize;
}


- (void)layout {
   _videoChannelThumbnailsNode.frame = [FrameCalculator frameForLeftMenuSubscriptionThumbnail:_nodeCellSize];


   _channelTitleTextNode.frame =
    [FrameCalculator frameForLeftMenuSubscriptionTitleText:_nodeCellSize
                                             leftNodeFrame:_videoChannelThumbnailsNode.frame
                                            withFontHeight:ASROW_TITLE_FONT_SIZE];

//   CGSize textSize = _channelTitleTextNode.calculatedSize;
//   _channelTitleTextNode.frame = CGRectMake(40.0f, 2.0f, textSize.width, textSize.height);
}


@end
