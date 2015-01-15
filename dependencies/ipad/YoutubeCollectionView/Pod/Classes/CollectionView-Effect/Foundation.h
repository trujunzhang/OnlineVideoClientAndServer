//
//  Foundation.h
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"


@interface NSAttributedString (custom)

+ (NSAttributedString *)attributedStringForTitleText:(NSString *)text;

+ (NSAttributedString *)attributedStringForDurationText:(NSString *)text;

+ (NSAttributedString *)attributedStringForChannelTitleText:(NSString *)text;

+ (NSAttributedString *)attributedStringForPageChannelTitleText:(NSString *)text;

+ (NSAttributedString *)attributedStringForChannelStatisticsSubscriberCount:(NSString *)text;

+ (NSAttributedString *)attributedStringForLeftMenuSubscriptionTitleText:(NSString *)text fontSize:(CGFloat)fontSize;

+ (NSAttributedString *)attributedStringForCollectionVideoTitle:(NSString *)text fontSize:(CGFloat)fontSize;

+ (NSAttributedString *)attributedStringForCollectionChannelTitle:(NSString *)text fontSize:(CGFloat)fontSize;

+ (NSMutableAttributedString *)attributedStringForDetailRowDescription:(NSString *)text fontSize:(CGFloat)fontSize;

+ (NSAttributedString *)attributedStringForDetailRowChannelTitle:(NSString *)text fontSize:(CGFloat)fontSize;

+ (NSAttributedString *)attributedStringForDetailRowChannelPublishedAt:(NSString *)text fontSize:(CGFloat)fontSize;

+ (NSAttributedString *)attributedStringForDetailRowVideoLikeCount:(NSString *)text fontSize:(CGFloat)fontSize;

+ (NSAttributedString *)attributedStringForDetailRowVideoViewCount:(NSString *)text fontSize:(CGFloat)fontSize;

@end


@interface NSParagraphStyle (custom)

+ (NSParagraphStyle *)justifiedParagraphStyleForCommon;

+ (NSParagraphStyle *)justifiedParagraphStyle;

+ (NSParagraphStyle *)justifiedParagraphStyleForDuration;

+ (NSMutableParagraphStyle *)justifiedParagraphStyleForTitleText:(UIFont *)font;

+ (NSParagraphStyle *)justifiedParagraphStyleForCollectionVideoTitle;

+ (NSParagraphStyle *)justifiedParagraphStyleForCollectionChannelTitle;

+ (NSParagraphStyle *)justifiedParagraphStyleForDescription;

+ (NSParagraphStyle *)justifiedParagraphStyleForDetailRowChannelTitle;

+ (NSParagraphStyle *)justifiedParagraphStyleForDetailRowVideoViewCount;

+ (NSParagraphStyle *)justifiedParagraphStyleForChannelTitle;

+ (NSParagraphStyle *)justifiedParagraphStyleForPageChannelTitle;

+ (NSParagraphStyle *)justifiedParagraphStyleForLeftMenuSubscriptionTitle;

@end


@interface NSShadow (custom)

+ (NSShadow *)titleTextShadow;

+ (NSShadow *)descriptionTextShadow;
@end


