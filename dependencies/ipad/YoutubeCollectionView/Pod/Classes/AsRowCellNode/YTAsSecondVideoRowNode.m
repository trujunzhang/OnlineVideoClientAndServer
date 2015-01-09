//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsSecondVideoRowNode.h"
#import "Foundation.h"


@interface YTAsSecondVideoRowNode () {
   ASTextNode * _videoTitleNode;
}
@end


@implementation YTAsSecondVideoRowNode {

}

- (void)makeRowNode {
   // 2.2
   _videoTitleNode = [ASTextNode initWithAttributedString:
    [NSAttributedString attributedStringForCollectionVideoTitle:[YoutubeParser getVideoSnippetTitle:self.nodeInfo]
                                                       fontSize:13.0f]];


   [self addSubnode:_videoTitleNode];
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   return self.cellRect.size;
}


- (void)layout {
   _videoTitleNode.frame =
    CGRectMake(VIDEO_TITLE_PADDING_LEFT, 10, self.cellRect.size.width - VIDEO_TITLE_PADDING_LEFT * 2, COLLECTION_CELL_SECOND_HEIGHT - 12);
}


@end