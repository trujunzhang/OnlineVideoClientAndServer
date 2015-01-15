//
//  YTAsChannelThumbnailsImageNode.m
//  IOSTemplate
//
//  Created by djzhang on 10/24/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "YTAsChannelThumbnailsImageNode.h"
#import "YoutubeParser.h"
#import "GYoutubeHelper.h"


@interface YTAsChannelThumbnailsImageNode () {

}

@end


@implementation YTAsChannelThumbnailsImageNode

- (instancetype)initWithChannelId:(NSString *)channelId {
    self = [super init];
    if(self) {
        self.channelId = channelId;

        [self checkCacheAndFetchImage];
    }

    return self;
}


- (void)checkCacheAndFetchImage {

}


+ (instancetype)nodeWithThumbnailUrl:(NSString *)thumbnailUrl {
    return [YTAsChannelThumbnailsImageNode nodeWithImageUrl:thumbnailUrl];
}


+ (instancetype)nodeWithThumbnailUrl:(NSString *)thumbnailUrl forCorner:(CGFloat)cornerRadius {
    YTAsChannelThumbnailsImageNode *node = [YTAsChannelThumbnailsImageNode nodeWithImageUrl:thumbnailUrl];

    [self makeImageNodeCorner:cornerRadius node:node];

    return node;
}


+ (void)makeImageNodeCorner:(CGFloat)cornerRadius node:(YTAsChannelThumbnailsImageNode *)node {
    node.imageModificationBlock = ^UIImage *(UIImage *image) {
        UIImage *modifiedImage = nil;
        CGRect rect = (CGRect){CGPointZero, image.size};

        UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);

        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
        [image drawInRect:rect];
        modifiedImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        return modifiedImage;
    };
}


+ (instancetype)nodeWithChannelId:(NSString *)channelId {
    ASImageNode *node;

    NSString *thumbnailUrl = [YoutubeParser checkAndAppendThumbnailWithChannelId:channelId];
    if(thumbnailUrl) {
        node = [YTAsChannelThumbnailsImageNode nodeWithImageUrl:thumbnailUrl];
    } else {
        node = [[self alloc] initWithChannelId:channelId];
    }

    return node;

}


+ (instancetype)nodeWithChannelId:(NSString *)channelId forCorner:(CGFloat)cornerRadius {
    YTAsChannelThumbnailsImageNode *node = [YTAsChannelThumbnailsImageNode nodeWithChannelId:channelId];

    [self makeImageNodeCorner:cornerRadius node:node];

    return node;
}


@end
