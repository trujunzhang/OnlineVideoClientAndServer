//
//  Foundation.m
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "Foundation.h"
#import "ASTextNodeCoreTextAdditions.h"


@implementation NSAttributedString (custom)


#pragma mark -
#pragma mark UICollection Cell


+ (NSAttributedString *)attributedStringForTitleText:(NSString *)text {
    UIFont *font = [UIFont systemFontOfSize:14];

    NSDictionary *titleAttributes =
            @{NSFontAttributeName : font,
                    NSForegroundColorAttributeName : [UIColor blackColor],
//     NSShadowAttributeName : [NSShadow titleTextShadow],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyleForTitleText:font]
            };

    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


+ (NSAttributedString *)attributedStringForChannelTitleText:(NSString *)text {
    UIFont *font = [UIFont systemFontOfSize:12];

    NSDictionary *titleAttributes =
            @{NSFontAttributeName : font,
                    NSForegroundColorAttributeName : [UIColor redColor],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyleForChannelTitle]
            };

    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


+ (NSAttributedString *)attributedStringForPageChannelTitleText:(NSString *)text {
    UIFont *font = [UIFont systemFontOfSize:12];

    NSDictionary *titleAttributes =
            @{NSFontAttributeName : font,
                    NSForegroundColorAttributeName : [UIColor darkTextColor],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyleForPageChannelTitle]
            };

    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


+ (NSAttributedString *)attributedStringForChannelStatisticsSubscriberCount:(NSString *)text {
    UIFont *font = [UIFont systemFontOfSize:12];

    NSDictionary *titleAttributes =
            @{NSFontAttributeName : font,
                    NSForegroundColorAttributeName : [UIColor darkGrayColor],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyleForPageChannelTitle]
            };

    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


- (NSDictionary *)createAttributesForFontStyle:(NSString *)style
                                     withTrait:(uint32_t)trait {
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *descriptorWithTrait = [fontDescriptor fontDescriptorWithSymbolicTraits:trait];
    UIFont *font = [UIFont fontWithDescriptor:descriptorWithTrait size:0.0];

    return @{NSFontAttributeName : font};
}


+ (NSAttributedString *)attributedStringForTitleText123:(NSString *)text {

    NSDictionary *titleAttributes =
            @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Heavy" size:30],
                    NSForegroundColorAttributeName : [UIColor whiteColor],
                    NSShadowAttributeName : [NSShadow titleTextShadow],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyle]
            };

    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


+ (NSAttributedString *)attributedStringForDurationText:(NSString *)text {
    NSDictionary *titleAttributes =
            @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12],
                    NSForegroundColorAttributeName : [UIColor whiteColor],
                    NSBackgroundColorAttributeName : [UIColor clearColor],
                    NSShadowAttributeName : [NSShadow descriptionTextShadow],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyleForDuration]
            };


    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


#pragma mark -
#pragma mark Left menu table cell


+ (NSAttributedString *)attributedStringForLeftMenuSubscriptionTitleText:(NSString *)text fontSize:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];

    NSDictionary *titleAttributes =
            @{NSFontAttributeName : font,
                    NSForegroundColorAttributeName : [UIColor lightTextColor],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyleForLeftMenuSubscriptionTitle]
            };

    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


#pragma mark -
#pragma mark YTAsSecondVideoRowNode


+ (NSAttributedString *)attributedStringForCollectionVideoTitle:(NSString *)text fontSize:(CGFloat)fontSize {
    UIFont *font =
            [UIFont fontWithName:@"Helvetica" size:fontSize];
//    [UIFont boldSystemFontOfSize:fontSize];

    NSDictionary *titleAttributes =
            @{NSFontAttributeName : font,
                    NSForegroundColorAttributeName : [UIColor darkTextColor],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyleForCollectionVideoTitle]
            };

    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


#pragma mark -
#pragma mark YTAsThirdVideoRowNode


+ (NSAttributedString *)attributedStringForCollectionChannelTitle:(NSString *)text fontSize:(CGFloat)fontSize {
    UIFont *font =
            [UIFont fontWithName:@"Helvetica" size:fontSize];
//    [UIFont boldSystemFontOfSize:fontSize];

    NSDictionary *titleAttributes =
            @{NSFontAttributeName : font,
                    NSForegroundColorAttributeName : [UIColor lightGrayColor],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyleForCollectionChannelTitle]
            };

    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


#pragma mark -
#pragma mark AsDetailRowChannelInfo


+ (NSMutableAttributedString *)attributedStringForDetailRowDescription:(NSString *)text fontSize:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];

    NSDictionary *titleAttributes =
            @{
                    NSForegroundColorAttributeName : [UIColor blackColor],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyleForDescription],
            };

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text
                                                                                         attributes:titleAttributes];

    [attributedString addAttribute:NSFontAttributeName
                             value:font
                             range:NSMakeRange(0, text.length)];


    return attributedString;
}


+ (NSAttributedString *)attributedStringForDetailRowChannelTitle:(NSString *)text fontSize:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];

    NSDictionary *titleAttributes =
            @{NSFontAttributeName : font,
                    NSForegroundColorAttributeName : [UIColor blackColor],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyleForDetailRowChannelTitle],
            };

    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


+ (NSAttributedString *)attributedStringForDetailRowChannelPublishedAt:(NSString *)text fontSize:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];

    NSDictionary *titleAttributes =
            @{NSFontAttributeName : font,
                    NSForegroundColorAttributeName : [UIColor darkGrayColor],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyle],
            };

    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


+ (NSAttributedString *)attributedStringForDetailRowVideoLikeCount:(NSString *)text fontSize:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];

    NSDictionary *titleAttributes =
            @{NSFontAttributeName : font,
                    NSForegroundColorAttributeName : [UIColor darkGrayColor],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyleForCommon],
            };

    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


+ (NSAttributedString *)attributedStringForDetailRowVideoViewCount:(NSString *)text fontSize:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];

    NSDictionary *titleAttributes =
            @{NSFontAttributeName : font,
                    NSForegroundColorAttributeName : [UIColor darkGrayColor],
                    NSParagraphStyleAttributeName : [NSParagraphStyle justifiedParagraphStyleForDetailRowVideoViewCount],
            };

    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}


@end


@implementation NSParagraphStyle (custom)

#pragma mark -
#pragma mark common style


+ (NSParagraphStyle *)justifiedParagraphStyleForCommon {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentLeft;

    style.paragraphSpacing = 0.0;

    return style;
}


#pragma mark -
#pragma mark UICollection Cell


+ (NSParagraphStyle *)justifiedParagraphStyle {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//   [style setAlignment:NSTextAlignmentJustified];
//   style.lineBreakMode = NSLineBreakByTruncatingTail;

    return style;
}


+ (NSParagraphStyle *)justifiedParagraphStyleForDuration {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;

    return style;
}


+ (NSParagraphStyle *)justifiedParagraphStyleForChannelTitle {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentLeft;

    return style;
}


+ (NSParagraphStyle *)justifiedParagraphStyleForPageChannelTitle {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentLeft;

    return style;
}


+ (NSMutableParagraphStyle *)justifiedParagraphStyleForTitleText:(UIFont *)font {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//   style.paragraphSpacing = 0.5 * font.lineHeight;
    style.hyphenationFactor = 1.0;
//   style.lineBreakMode = NSLineBreakByTruncatingTail;
//   style.alignment = kCTTextAlignmentCenter;


    style.minimumLineHeight = 0.f;
    style.maximumLineHeight = 88.0f;
    style.firstLineHeadIndent = 0.0f;
    style.paragraphSpacing = 0.0;
    style.lineSpacing = 5.0;
    style.headIndent = 0.0f;
    style.tailIndent = 0.0f;

    return style;
}


#pragma mark -
#pragma mark YTAsSecondVideoRowNode


+ (NSParagraphStyle *)justifiedParagraphStyleForCollectionVideoTitle {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    style.paragraphSpacing = 1.0;

    return style;
}


#pragma mark -
#pragma mark YTAsThirdVideoRowNode


+ (NSParagraphStyle *)justifiedParagraphStyleForCollectionChannelTitle {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    style.paragraphSpacing = 1.0;

    return style;
}


#pragma mark -
#pragma mark AsDetailRowChannelInfo


+ (NSParagraphStyle *)justifiedParagraphStyleForDescription {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;

    style.paragraphSpacing = 1.0;

    return style;
}


+ (NSParagraphStyle *)justifiedParagraphStyleForDetailRowChannelTitle {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentLeft;

    style.paragraphSpacing = 0.0;

    return style;
}


+ (NSParagraphStyle *)justifiedParagraphStyleForDetailRowVideoViewCount {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentRight;

    style.paragraphSpacing = 0.0;

    return style;
}


#pragma mark -
#pragma mark Left menu table cell


+ (NSParagraphStyle *)justifiedParagraphStyleForLeftMenuSubscriptionTitle {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentLeft;


    return style;
}


@end


@implementation NSShadow (custom)

+ (NSShadow *)titleTextShadow {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithHue:0
                                    saturation:0
                                    brightness:0
                                         alpha:0.3];
    shadow.shadowOffset = CGSizeMake(0, 2);
    shadow.shadowBlurRadius = 3.0;

    return shadow;
}


+ (NSShadow *)descriptionTextShadow {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    shadow.shadowOffset = CGSizeMake(0, 1);
    shadow.shadowBlurRadius = 3.0;

    return shadow;
}


@end

