//
// Created by djzhang on 11/24/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "FrameCalculator.h"
#import "YoutubeParser.h"

#define textAreaHeight 300.0

#define textAreaPaddingX 8.0

//#define cardWidth 320.0


@implementation FrameCalculator {

}


#pragma mark -
#pragma mark divide on bottom


+ (CGRect)frameForBottomDivide:(CGFloat)containerWidth containerHeight:(CGFloat)containerHeight {

   CGFloat pixelHeight = 1.0f / [[UIScreen mainScreen] scale];
   return CGRectMake(0.0f, containerHeight - pixelHeight, containerWidth, pixelHeight);
}


#pragma mark -
#pragma mark UICollection Cell


+ (CGRect)frameForDescriptionText:(CGRect)containerBounds featureImageFrame:(CGRect)featureImageFrame {

   return CGRectMake(24.0, CGRectGetMaxY(featureImageFrame) + 20.0, containerBounds.size.width - 48.0, textAreaHeight);
}


+ (CGRect)frameForDivider:(CGSize)containerSize thirdRowHeight:(CGFloat)thirdRowHeight {
   CGFloat divY = containerSize.height - thirdRowHeight - 1;
   return CGRectMake(0.0f, divY, containerSize.width, 1);
}


+ (CGRect)frameForChannelThumbnail:(CGRect)containerBounds thirdRowHeight:(CGFloat)thirdRowHeight {
   CGFloat thumbnailPaddingTop = 5;

   CGFloat divX = 6;
   CGFloat divY = containerBounds.size.height - thirdRowHeight + thumbnailPaddingTop;
   CGFloat thumbnailHeight = thirdRowHeight - thumbnailPaddingTop * 2;
   return CGRectMake(divX, divY, thumbnailHeight, thumbnailHeight);
}


+ (CGRect)frameForChannelTitleText:(CGRect)containerBounds thirdRowHeight:(CGFloat)thirdRowHeight leftNodeFrame:(CGRect)leftNodeFrame {
   CGFloat titlePaddingTop = 7;

   CGFloat divX = leftNodeFrame.origin.x + leftNodeFrame.size.width + leftNodeFrame.origin.x;
   CGFloat divY = containerBounds.size.height - thirdRowHeight + titlePaddingTop;
   return CGRectMake(divX, divY, 180.0f, thirdRowHeight - titlePaddingTop);
}


+ (CGRect)frameForTitleText:(CGRect)containerBounds featureImageFrame:(CGRect)featureImageFrame {
   CGFloat tY = featureImageFrame.origin.y + featureImageFrame.size.height + 6;
   return CGRectMake(textAreaPaddingX, tY, containerBounds.size.width - textAreaPaddingX * 2, 48);
}


+ (CGRect)frameForGradient:(CGRect)featureImageFrame {
   return featureImageFrame;
}


+ (CGRect)frameForFeatureImage:(CGSize)cellSize containerFrameWidth:(CGFloat)containerFrameWidth {
   CGSize imageFrameSize = [FrameCalculator aspectSizeForWidth:containerFrameWidth originalSize:cellSize];
   return CGRectMake(0, 0, imageFrameSize.width, imageFrameSize.height);
}


+ (CGRect)frameForChannelThumbnails:(CGSize)cellSize nodeFrameHeight:(CGFloat)nodeFrameHeight {
   return CGRectMake(0, 0, cellSize.width, nodeFrameHeight);
}


+ (CGFloat)calculateWidthForDurationLabel:(NSString *)labelText {
   float widthIs =
    [labelText
     boundingRectWithSize:CGSizeZero
                  options:NSStringDrawingUsesLineFragmentOrigin
               attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12] }
                  context:nil].size.width;

   return widthIs;
}


+ (CGRect)frameForDurationWithCloverSize:(CGSize)cloverSize withDurationWidth:(CGFloat)durationWidthIs {
   CGFloat durationHeight = 18;
   return CGRectMake(cloverSize.width - durationWidthIs - 1, cloverSize.height - durationHeight - 1, durationWidthIs, durationHeight);
}


+ (CGRect)frameForBackgroundImage:(CGRect)containerBounds {
   return containerBounds;
}


+ (CGRect)frameForContainer:(CGSize)cellSize {
//   CGFloat containerWidth = [FrameCalculator cardWidth];
//   CGSize size = [FrameCalculator sizeThatFits:CGSizeMake(containerWidth, CGFLOAT_MAX)
//                                 withImageSize:cellSize];
   return CGRectMake(0, 0, cellSize.width, cellSize.height);
}


+ (CGSize)sizeThatFits:(CGSize)size withImageSize:(CGSize)imageSize {
   CGSize imageFrameSize = [FrameCalculator aspectSizeForWidth:size.width originalSize:imageSize];
   return CGSizeMake(size.width, imageFrameSize.height + textAreaHeight);
}


+ (CGSize)aspectSizeForWidth:(CGFloat)width originalSize:(CGSize)originalSize {
   CGFloat height = ceil((originalSize.height / originalSize.width) * width);
   return CGSizeMake(width, height);
}


#pragma mark -
#pragma mark video detail rows node


+ (CGRect)frameForDetailRowChannelInfoThumbnail:(CGFloat)containerWidth withHeight:(CGFloat)containerHeight {
   CGFloat paddingTop = 10;


   CGFloat divX = 14;
   CGFloat divY = paddingTop;
   CGFloat imageWH = containerHeight - paddingTop * 2;

   return CGRectMake(divX, divY, imageWH, imageWH);
//   return CGRectMake(containerWidth - imageWH - 4, divY, imageWH, imageWH);  //test
}


+ (CGRect)frameForDetailRowChannelInfoTitle:(CGFloat)containerWidth withLeftRect:(CGRect)leftRect {
   CGFloat divX = leftRect.origin.x + leftRect.size.width + 14;//used
//   CGFloat divX = 12;// test
   CGFloat divY = 8;

   return CGRectMake(divX, divY, 200.0f, 16);
}


+ (CGRect)frameForDetailRowChannelInfoPublishedAt:(CGFloat)containerWidth withLeftRect:(CGRect)leftRect {
   CGFloat divX = leftRect.origin.x;
   CGFloat divY = leftRect.origin.y + leftRect.size.height + 2;

//   CGFloat divX = 200.0f;
//   CGFloat divY = 12;

   return CGRectMake(divX, divY, 200.0f, 16);
}


+ (CGRect)frameForDetailRowVideoInfoTitle:(CGSize)containerSize withTitleHeight:(CGFloat)titleHeight withFontHeight:(CGFloat)fontHeight {
   CGFloat divX = 18.0f;
   CGFloat divY = 18;

   return CGRectMake(divX, divY, containerSize.width - divX * 2, titleHeight);
}


+ (CGRect)frameForDetailRowVideoInfoLikeCount:(CGRect)relatedRect {
   CGFloat divY = relatedRect.origin.y + relatedRect.size.height + 4;

   return CGRectMake(relatedRect.origin.x, divY, 200.0, 20);
}


+ (CGRect)frameForDetailRowVideoInfoViewCount:(CGRect)relatedRect withContainWidth:(CGFloat)containWidth {
   CGFloat divY = relatedRect.origin.y + relatedRect.size.height + 4;

   CGFloat textWidth = 200.0;
   return CGRectMake(containWidth - textWidth - 18, divY, textWidth, 20);
}


#pragma mark -
#pragma mark Left menu table cell


+ (CGRect)frameForLeftMenuSubscriptionThumbnail:(CGSize)containerSize {
   CGFloat divX = 10;
   CGFloat imageWH = 28;
   CGFloat divY = (containerSize.height - imageWH) / 2;

   return CGRectMake(divX, divY, imageWH, imageWH);
}


+ (CGRect)frameForLeftMenuSubscriptionTitleText:(CGSize)containerSize leftNodeFrame:(CGRect)leftNodeFrame withFontHeight:(CGFloat)fontHeight {
   CGFloat divX = leftNodeFrame.origin.x + leftNodeFrame.size.width + leftNodeFrame.origin.x + 2;
   CGFloat divY = (containerSize.height - fontHeight) / 2 - 2;

   CGFloat titleWidth = containerSize.width - divX - 4;
   CGFloat titleHeight = fontHeight;

   return CGRectMake(divX, divY, titleWidth, containerSize.height);
}


#pragma mark -
#pragma mark Page top banner Cell


+ (CGRect)frameForPageChannelBannerThumbnails:(CGSize)cellSize secondRowFrameHeight:(CGFloat)nodeFrameHeight {
   CGFloat divH = cellSize.height - nodeFrameHeight;
   CGRect rect = CGRectMake(0, 0, cellSize.width, divH);
   return rect;
}


+ (CGRect)frameForPageChannelThumbnails:(CGSize)cellSize {
//   return CGRectMake(17, 0, 70, 70);

   CGFloat dX = cellSize.width - 70 - 2;
//   dX = 17;
   return CGRectMake(dX, 0, 70, 70);
}


+ (CGRect)frameForPageChannelTitle:(CGSize)cellSize secondRowFrameHeight:(CGFloat)nodeFrameHeight {
   CGFloat divY = cellSize.height - nodeFrameHeight;
   return CGRectMake(12, divY + 8, 300, 15);
}


+ (CGRect)frameForPageChannelStatisticsSubscriberCount:(CGSize)cellSize secondRowFrameHeight:(CGFloat)nodeFrameHeight {
   CGFloat divY = cellSize.height - nodeFrameHeight;
   return CGRectMake(12, divY + 8 + 18, 300, 15);
}


@end