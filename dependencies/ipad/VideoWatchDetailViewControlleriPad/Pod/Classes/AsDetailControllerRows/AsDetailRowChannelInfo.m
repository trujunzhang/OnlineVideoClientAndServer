//
//  AsDetailRowChannelInfo.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/14/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "AsDetailRowChannelInfo.h"
#import "YoutubeVideoCache.h"
#import "YoutubeParser.h"
#import "ASCacheNetworkImageNode.h"
#import "YTAsChannelThumbnailsImageNode.h"
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <AsyncDisplayKit/ASHighlightOverlayLayer.h>
#import "AsyncDisplayKitStatic.h"
#import "FrameCalculator.h"
#import "Foundation.h"

static CGFloat DetailRowChannelInfoHeight = 50.0f;


@interface AsDetailRowChannelInfo () {
    ASImageNode *_channelImageNode;

    ASTextNode *_channelTitleNode;
    ASTextNode *_publishedAtNode;

    ASDisplayNode *_divider;

    int cStep;
}


@end


@implementation AsDetailRowChannelInfo


- (instancetype)initWithVideo:(id)videoCache withTableWidth:(CGFloat)tableViewWidth {
    if(!(self = [super init]))
        return nil;

    _channelImageNode = [YTAsChannelThumbnailsImageNode nodeWithChannelId:[YoutubeParser getChannelIdByVideo:videoCache]
                                                                forCorner:5.0f];

//   _channelImageNode.image = [UIImage imageNamed:@"account_default_thumbnail.png"];//test
//   [self setNodeTappedEvent];//test

    [self addSubnode:_channelImageNode];

    // create a text node
    _channelTitleNode = [ASTextNode initWithAttributedString:
            [NSAttributedString attributedStringForDetailRowChannelTitle:[YoutubeParser getVideoSnippetChannelTitle:videoCache]
                                                                fontSize:15.0f]];


    // add it as a subnode, and we're done
    [self addSubnode:_channelTitleNode];


    // create a text node
    _publishedAtNode = [ASTextNode initWithAttributedString:
            [NSAttributedString attributedStringForDetailRowChannelPublishedAt:[YoutubeParser getVideoSnippetChannelPublishedAt:videoCache]
                                                                      fontSize:12.0f]];


    // add it as a subnode, and we're done
    [self addSubnode:_publishedAtNode];

    // hairline cell separator
    _divider = [[ASDisplayNode alloc] init];
    _divider.backgroundColor = [UIColor lightGrayColor];
    [self addSubnode:_divider];

    return self;
}


- (void)didLoad {
    // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
    self.layer.as_allowsHighlightDrawing = YES;

    [super didLoad];
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    // called on a background thread.  custom nodes must call -measure: on their subnodes in -calculateSizeThatFits:

    CGSize size = CGSizeMake(constrainedSize.width, DetailRowChannelInfoHeight);
    return size;
}


- (void)layout {

    _channelImageNode.frame = [FrameCalculator frameForDetailRowChannelInfoThumbnail:self.calculatedSize.width
                                                                          withHeight:DetailRowChannelInfoHeight];

    _channelTitleNode.frame = [FrameCalculator frameForDetailRowChannelInfoTitle:self.calculatedSize.width
                                                                    withLeftRect:_channelImageNode.frame];

    _publishedAtNode.frame = [FrameCalculator frameForDetailRowChannelInfoPublishedAt:self.calculatedSize.width
                                                                         withLeftRect:_channelTitleNode.frame];


    _divider.frame = [FrameCalculator frameForBottomDivide:self.calculatedSize.width
                                           containerHeight:DetailRowChannelInfoHeight];
}


- (void)setNodeTappedEvent {
    // configure the button
    _channelImageNode.userInteractionEnabled = YES; // opt into touch handling
    [_channelImageNode addTarget:self
                          action:@selector(buttonTapped:)
                forControlEvents:ASControlNodeEventTouchUpInside];
}


- (void)buttonTapped:(id)buttonTapped {
    NSArray *colorArray = @[
            [UIColor redColor],
            [UIColor greenColor],
            [UIColor blueColor],
    ];

    cStep++;
    _channelTitleNode.backgroundColor = colorArray[cStep % 3];


}


@end
