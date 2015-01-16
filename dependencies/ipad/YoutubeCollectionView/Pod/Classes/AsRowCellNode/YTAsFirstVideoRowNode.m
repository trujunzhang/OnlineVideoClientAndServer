//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsFirstVideoRowNode.h"
#import "FetchingSubtitleManager.h"
#import "YKDirectVideo.h"
#import "ASNetworkImageNode.h"
#import "ASDisplayNodeExtras.h"
//#import "MPMoviePlayerController+Subtitles.h"


@interface YTAsFirstVideoRowNode () {
    ASNetworkImageNode *_videoCoverThumbnailsNode;
    YKDirectVideo *_directVideo;
}

@end


@implementation YTAsFirstVideoRowNode {

}


- (void)makeRowNode {
    _videoCoverThumbnailsNode = [ASCacheNetworkImageNode nodeWithImageUrl:[YoutubeParser getVideoThumbnailsGeneratedFromVideo:self.nodeInfo]];
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


- (void)buttonTapped:(id)buttonTapped {
    NSString *string = [[YoutubeParser getVideoOnlineUrl:self.nodeInfo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _directVideo = [[YKDirectVideo alloc] initWithContent:[NSURL URLWithString:string]];

    SubtitleResponseBlock subtitleResponseBlock = ^(NSURL *responseString, NSError *error) {
        NSString *localSRTPath = [responseString relativePath];
        if(error)
            localSRTPath = nil;
        [_directVideo play:YKQualityLow subtitlesPathStr:localSRTPath];
    };
    [[GYoutubeHelper getInstance] fetchingSubtitle:subtitleResponseBlock
                                           withUrl:[NSString stringWithFormat:@"%@.%@", [string stringByDeletingPathExtension], @"srt"]];
}

@end