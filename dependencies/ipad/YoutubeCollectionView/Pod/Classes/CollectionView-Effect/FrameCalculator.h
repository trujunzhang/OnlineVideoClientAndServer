//
// Created by djzhang on 11/24/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FrameCalculator : NSObject

+ (CGRect)frameForBottomDivide:(CGFloat)containerWidth containerHeight:(CGFloat)containerHeight;
+ (CGRect)frameForDescriptionText:(CGRect)containerBounds featureImageFrame:(CGRect)featureImageFrame;
+ (CGRect)frameForDivider:(CGSize)containerSize thirdRowHeight:(CGFloat)thirdRowHeight;
+ (CGRect)frameForChannelThumbnail:(CGRect)containerBounds thirdRowHeight:(CGFloat)thirdRowHeight;
+ (CGRect)frameForChannelTitleText:(CGRect)containerBounds thirdRowHeight:(CGFloat)thirdRowHeight leftNodeFrame:(CGRect)leftNodeFrame;
+ (CGRect)frameForTitleText:(CGRect)containerBounds featureImageFrame:(CGRect)featureImageFrame;
+ (CGRect)frameForGradient:(CGRect)featureImageFrame;

+ (CGRect)frameForFeatureImage:(CGSize)featureImageSize containerFrameWidth:(CGFloat)containerFrameWidth;

+ (CGRect)frameForChannelThumbnails:(CGSize)featureImageSize nodeFrameHeight:(CGFloat)nodeFrameHeight;
+ (CGFloat)calculateWidthForDurationLabel:(NSString *)labelText;
+ (CGRect)frameForDurationWithCloverSize:(CGSize)cloverSize withDurationWidth:(CGFloat)durationWidthIs;
+ (CGRect)frameForBackgroundImage:(CGRect)containerBounds;
+ (CGRect)frameForContainer:(CGSize)featureImageSize;
+ (CGSize)sizeThatFits:(CGSize)size withImageSize:(CGSize)imageSize;
+ (CGSize)aspectSizeForWidth:(CGFloat)width originalSize:(CGSize)originalSize;

+ (CGRect)frameForDetailRowChannelInfoThumbnail:(CGFloat)containerWidth withHeight:(CGFloat)containerHeight;
+ (CGRect)frameForDetailRowChannelInfoTitle:(CGFloat)containerWidth withLeftRect:(CGRect)leftRect;
+ (CGRect)frameForDetailRowChannelInfoPublishedAt:(CGFloat)containerWidth withLeftRect:(CGRect)leftRect;
+ (CGRect)frameForDetailRowVideoInfoTitle:(CGSize)containerSize withTitleHeight:(CGFloat)titleHeight withFontHeight:(CGFloat)fontHeight;
+ (CGRect)frameForDetailRowVideoInfoLikeCount:(CGRect)relatedRect;
+ (CGRect)frameForDetailRowVideoInfoViewCount:(CGRect)relatedRect withContainWidth:(CGFloat)containWidth;

+ (CGRect)frameForLeftMenuSubscriptionThumbnail:(CGSize)containerSize;
+ (CGRect)frameForLeftMenuSubscriptionTitleText:(CGSize)containerSize leftNodeFrame:(CGRect)leftNodeFrame withFontHeight:(CGFloat)fontHeight;

+ (CGRect)frameForPageChannelBannerThumbnails:(CGSize)cellSize secondRowFrameHeight:(CGFloat)nodeFrameHeight;
+ (CGRect)frameForPageChannelThumbnails:(CGSize)cellSize;
+ (CGRect)frameForPageChannelTitle:(CGSize)cellSize secondRowFrameHeight:(CGFloat)nodeFrameHeight;
+ (CGRect)frameForPageChannelStatisticsSubscriberCount:(CGSize)cellSize secondRowFrameHeight:(CGFloat)nodeFrameHeight;
@end