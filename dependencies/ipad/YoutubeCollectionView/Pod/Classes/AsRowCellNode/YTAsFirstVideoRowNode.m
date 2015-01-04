//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsFirstVideoRowNode.h"
#import "Foundation.h"
#import "AsyncDisplayKitStatic.h"
#import "MxTabBarManager.h"
#import "YKDirectVideo.h"
#import "FetchingSubtitleManager.h"


@interface YTAsFirstVideoRowNode () {
   ASNetworkImageNode * _videoCoverThumbnailsNode;
}

@end


@implementation YTAsFirstVideoRowNode {

}


- (void)makeRowNode {
   _videoCoverThumbnailsNode = [[ASNetworkImageNode alloc] init];
   _videoCoverThumbnailsNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();

   NSString * playListThumbnails = [YoutubeParser getVideoThumbnailsGeneratedFromVideo:self.nodeInfo];

   _videoCoverThumbnailsNode.URL = [NSURL URLWithString:playListThumbnails];

   _videoCoverThumbnailsNode.contentMode = UIViewContentModeScaleToFill;

   [self addSubnode:_videoCoverThumbnailsNode];

   [self setNodeTappedEvent];

}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   return self.cellRect.size;
}


- (void)layout {
   _videoCoverThumbnailsNode.frame = self.cellRect;

}


#pragma mark -
#pragma mark node tapped event


- (void)setNodeTappedEvent {
   // configure the button
   _videoCoverThumbnailsNode.userInteractionEnabled = YES; // opt into touch handling
   [_videoCoverThumbnailsNode addTarget:self
                                 action:@selector(buttonTapped:)
                       forControlEvents:ASControlNodeEventTouchUpInside];
}


//YTYouTubePlayList
- (void)buttonTapped:(id)buttonTapped {
   NSInteger navigationIndex = [[MxTabBarManager sharedTabBarManager] getCurrentNavigationIndex];

   NSString * videoThumbnails = [YoutubeParser getVideoOnlineUrl:self.nodeInfo withNavigationIndex:navigationIndex];

   [FetchingSubtitleManager fetchSubtitleForVideoUrl:videoThumbnails];

   NSLog(@"videoThumbnails = %@", videoThumbnails);
   //http://192.168.1.200:8040/macshare/MacPE/Lynda.com/Adobe.com/@Muse/serials/@@Muse%20Essential%20Training%20by%20Justin%20Seeley/15.%20Publishing%20Your%20Website/01-Exporting%20to%20HTML%20and%20CSS.mp4
   //"http://192.168.1.103:8040/Adobe.com/@Muse/serials/@@Muse%20Essential%20Training%20by%20Justin%20Seeley/2.%20Getting%20to%20Know%20Adobe%20Muse/02-Exploring%20the%20Tools%20panel.mp4"
   //http://192.168.1.200:8040/Adobe.com/@Muse/serials/@@Muse%20Essential%20Training%20by%20Justin%20Seeley/2.%20Getting%20to%20Know%20Adobe%20Muse/02-Exploring%20the%20Tools%20panel.mp4
   YKDirectVideo * _directVideo = [[YKDirectVideo alloc] initWithContent:[NSURL URLWithString:videoThumbnails]];

   [_directVideo play:YKQualityLow];
}

@end