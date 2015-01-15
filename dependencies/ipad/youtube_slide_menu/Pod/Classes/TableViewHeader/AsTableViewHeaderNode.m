//
// Created by djzhang on 12/27/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "AsTableViewHeaderNode.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <AsyncDisplayKit/ASHighlightOverlayLayer.h>


@implementation AsTableViewHeaderNode {
    ASTextNode *_textNode;
}


- (instancetype)init {
    if(!(self = [super init]))
        return nil;

    self.backgroundColor = [UIColor clearColor];

    return self;
}


- (void)didLoad {
    // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
    self.layer.as_allowsHighlightDrawing = YES;

    [super didLoad];
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    // called on a background thread.  custom nodes must call -measure: on their subnodes in -calculateSizeThatFits:
    return CGSizeMake(constrainedSize.width, 1.0f);
}


- (void)layout {

}


@end