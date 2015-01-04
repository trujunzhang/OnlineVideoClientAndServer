//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsThirdChannelRowNode.h"
#import "Foundation.h"


@interface YTAsThirdChannelRowNode () {
   ASTextNode * _channelTitleNode;
   ASDisplayNode * _divider;
}
@end


@implementation YTAsThirdChannelRowNode {

}


- (void)makeRowNode {
   _channelTitleNode = [ASTextNode initWithAttributedString:
    [NSAttributedString attributedStringForCollectionChannelTitle:[YoutubeParser getVideoSnippetChannelTitle:self.nodeInfo]
                                                         fontSize:12.0f]];

   [self addSubnode:_channelTitleNode];

   // hairline cell separator
   _divider = [[ASDisplayNode alloc] init];

   _divider.backgroundColor =
//    [UIColor iOS8lightGrayColor];
    [UIColor lightGrayColor];

   [self addSubnode:_divider];
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   return self.cellRect.size;
}


- (void)layout {
   CGFloat titleWidth = 180.0f;
   _channelTitleNode.frame = CGRectMake(VIDEO_TITLE_PADDING_LEFT, self.cellRect.size.height - 18, titleWidth, 20);

   CGFloat pixelHeight = 1.0f / [[UIScreen mainScreen] scale];
   _divider.frame =
    CGRectMake(0.0f, self.cellRect.size.height - pixelHeight, self.cellRect.size.width, pixelHeight);
}

@end