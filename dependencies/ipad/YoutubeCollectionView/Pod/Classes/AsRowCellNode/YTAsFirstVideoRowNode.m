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
   NSString * videoUrl = [YoutubeParser getVideoOnlineUrl:self.nodeInfo];

   SubtitleResponseBlock subtitleResponseBlock = ^(NSURL * responseString) {
       NSString * debug = @"debug";
   };
   [FetchingSubtitleManager fetchSubtitleForVideoUrl:videoUrl subtitleResponseBlock:subtitleResponseBlock];

   YKDirectVideo * _directVideo = [[YKDirectVideo alloc] initWithContent:[NSURL URLWithString:[videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

   [_directVideo play:YKQualityLow];
}

@end