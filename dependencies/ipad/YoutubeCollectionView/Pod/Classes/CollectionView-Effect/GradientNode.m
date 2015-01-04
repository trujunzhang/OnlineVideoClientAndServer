//
//  GradientNode.m
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "GradientNode.h"
#import "_ASDisplayLayer.h"


@implementation GradientNode

- (void)drawRect:(CGRect)bounds withParameters:(id<NSObject>)parameters
     isCancelled:(asdisplaynode_iscancelled_block_t)isCancelledBlock
   isRasterizing:(BOOL)isRasterizing {

   CGContextRef myContext = UIGraphicsGetCurrentContext();
   CGContextSaveGState(myContext);
   CGContextClipToRect(myContext, bounds);

   uint componentCount = 2;
   CGFloat locations[] = { 0.0, 1.0 };
   CGFloat components[] = { 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0 };


   CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
   CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, componentCount);


   CGPoint myStartPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
   CGPoint myEndPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds));

   CGContextDrawLinearGradient(myContext, myGradient, myStartPoint, myEndPoint, kCGGradientDrawsAfterEndLocation);
}


@end
