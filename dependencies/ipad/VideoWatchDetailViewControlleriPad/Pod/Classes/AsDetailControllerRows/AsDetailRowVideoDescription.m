//
//  AsDetailRowVideoDescription.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/14/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "AsDetailRowVideoDescription.h"
#import "YoutubeVideoCache.h"
#import "YoutubeParser.h"
#import "YoutubeVideoDescriptionStringAttribute.h"
#import "Foundation.h"
#import "AsyncDisplayKitStatic.h"
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <AsyncDisplayKit/ASHighlightOverlayLayer.h>


static CGFloat kTextPaddingHorizontal = 18.0f;
static CGFloat kTextPaddingVertical = 10.0f;

static NSString * kLinkAttributeName = @"PlaceKittenNodeLinkAttributeName";


@interface AsDetailRowVideoDescription ()<ASTextNodeDelegate> {
   ASTextNode * _textNode;

   CGFloat _tableViewWidth;
}

@end


@implementation AsDetailRowVideoDescription


- (instancetype)initWithVideo:(YTYouTubeVideoCache *)videoCache withTableWidth:(CGFloat)tableViewWidth {
   if (!(self = [super init]))
      return nil;

   _tableViewWidth = tableViewWidth;

   self.backgroundColor = [UIColor whiteColor];

   // generate an attributed string using the custom link attribute specified above
   NSMutableArray * linkAttributeNames = [[NSMutableArray alloc] init];

   NSMutableAttributedString * attributedString =
    [NSAttributedString attributedStringForDetailRowDescription:[YoutubeParser getVideoDescription:videoCache]
                                                       fontSize:16.0f];

   // create a text node
   _textNode = [ASTextNode initWithAttributedString:attributedString withLinkAttributeNames:linkAttributeNames];

   // configure the node to support tappable links
   _textNode.delegate = self;


   // add it as a subnode, and we're done
   [self addSubnode:_textNode];

   return self;
}


- (void)didLoad {
   // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
   self.layer.as_allowsHighlightDrawing = YES;

   [super didLoad];
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   // called on a background thread.  custom nodes must call -measure: on their subnodes in -calculateSizeThatFits:
   CGSize measuredSize =
    [_textNode measure:CGSizeMake(constrainedSize.width - 2 * kTextPaddingHorizontal, constrainedSize.height)];

   return CGSizeMake(_tableViewWidth, measuredSize.height + kTextPaddingVertical * 2);
}


- (void)layout {
   // called on the main thread.  we'll use the stashed size from above, instead of blocking on text sizing
   CGSize textNodeSize = _textNode.calculatedSize;

   _textNode.frame =
    CGRectMake(kTextPaddingHorizontal, 0, self.calculatedSize.width - kTextPaddingHorizontal * 2, textNodeSize.height);

}


- (BOOL)textNode:(ASTextNode *)richTextNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point {
   // opt into link highlighting -- tap and hold the link to try it!  must enable highlighting on a layer, see -didLoad
   return YES;
}


- (void)textNode:(ASTextNode *)richTextNode tappedLinkAttribute:(NSString *)attribute value:(NSURL *)URL atPoint:(CGPoint)point textRange:(NSRange)textRange {
   // the node tapped a link, open it
   NSLog(@"URL = %@", URL);
   [[UIApplication sharedApplication] openURL:URL];
}


@end
