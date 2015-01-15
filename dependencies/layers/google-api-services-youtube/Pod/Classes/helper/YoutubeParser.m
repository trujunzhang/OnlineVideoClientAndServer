//
//  YoutubeParser.m
//  IOSTemplate
//
//  Created by djzhang on 11/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <google-api-services-youtube/GYoutubeHelper.h>
#import "YoutubeParser.h"
#import "ISMemoryCache.h"
#import "RXMatch.h"
#import "NSString+Regexer.h"
#import "YoutubeVideoDescriptionStringAttribute.h"
#import "NSString+PJR.h"
#import "GYoutubeHelper.h"
#import "SqliteManager.h"
#import "MxTabBarManager.h"
#import "MobileBaseDatabase.h"
#import "SqliteDatabaseConstant.h"


@interface YoutubeParser ()

@end


@implementation YoutubeParser


#pragma mark -
#pragma mark  Video cache


+ (NSString *)getVideoSnippetThumbnails:(YTYouTubeVideoCache *)video {
    return @"";
}


//+ (NSString *)getWatchVideoId:(YTYouTubeVideoCache *)video {
//
//   NSObject * domain = [[GYoutubeHelper getInstance] getCurrentDomainUrl];
//   NSString * onlineVideoPlayUrl = [video getOnlineVideoPlayUrl:domain];
//   return onlineVideoPlayUrl;
//}


+ (NSString *)getChannelIdByVideo:(YTYouTubeVideoCache *)video {
    return @"";
}


+ (NSString *)getVideoSnippetTitle:(YTYouTubeVideoCache *)video {
    NSString *string = video.sqliteObjectName;
    string = [string stringByDeletingPathExtension];
    return string;
}


+ (NSString *)getVideoDescription:(YTYouTubeVideoCache *)video {
    return @"";
}


+ (NSString *)getVideoSnippetChannelTitle:(YTYouTubeVideoCache *)video {
    return @"";
}


+ (NSString *)getVideoSnippetChannelPublishedAt:(YTYouTubeVideoCache *)video {
    return @"";
}


+ (NSString *)encodeAbstractPath:(NSString *)url {
    return [url replaceCharcter:@" " withCharcter:@"%20"];
}


+ (NSString *)getVideoOnlineUrl:(YTYouTubeVideoCache *)fileInfo {
    NSObject *domain = [[GYoutubeHelper getInstance] getCurrentDomainUrl];
    NSObject *htdocs = [[GYoutubeHelper getInstance] getHtdocs];

    NSString *relativePath = [fileInfo.objectFullPath replaceCharcter:htdocs
                                                         withCharcter:@""];

    return [NSString stringWithFormat:@"%@%@", domain, relativePath];
}


+ (NSString *)getVideoThumbnailsGeneratedFromVideo:(YTYouTubeVideoCache *)fileInfo {

    NSString *thumbnailName = [MobileBaseDatabase getThumbnailName:fileInfo.sqliteObjectID];
    NSObject *domain = [[GYoutubeHelper getInstance] getCurrentDomainUrl];
    NSString *stringWithFormat = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                                            domain,
                                                            [[GYoutubeHelper getInstance] getServerCacheDirectory],
                                                            appCacheDirectory,
                                                            thumbnailFolder,
                                                            thumbnailName];
    return stringWithFormat;
}


#pragma mark -
#pragma mark Channel for other request


+ (NSString *)getPlayListTitle:(YTYouTubePlayList *)channel {
    return channel.sqliteObjectName;
}


+ (NSString *)getPlayListThumbnailsGeneratedFromVideo:(YTYouTubePlayList *)playList {
    if(playList.sqliteObjectArray.count == 0) {
        return @"";
    }

    ABProjectFileInfo *firstFileInfo = [playList getFirstABProjectFileInfo];

    NSString *generatedFromVideo = [self getVideoThumbnailsGeneratedFromVideo:firstFileInfo];
    return generatedFromVideo;
}


+ (NSString *)getChannelBannerImageUrl:(YTYouTubeChannel *)channel {
    return @"";
}


+ (NSArray *)getChannelBannerImageUrlArray:(YTYouTubeChannel *)channel {

    return @[
            @"",
            @"",
    ];
}


+ (NSString *)getChannelSnippetId:(YTYouTubeChannel *)channel {
    return [NSString stringWithFormat:@"%@", channel.sqliteObjectID];
}


+ (NSString *)getChannelProjectFullPath:(YTYouTubeChannel *)channel {
    return channel.objectFullPath;
}


+ (NSString *)getChannelSnippetTitle:(YTYouTubeChannel *)channel {
    return [channel.sqliteObjectName removeSubString:@"@@"];
}


+ (NSString *)getChannelSnippetThumbnail:(YTYouTubeChannel *)channel {
    return @"";
}


+ (NSString *)getChannelBrandingSettingsTitle:(YTYouTubeChannel *)channel {
    return @"";
}


+ (NSString *)getChannelStatisticsSubscriberCount:(YTYouTubeChannel *)channel {
    return @"";
}


#pragma mark -
#pragma mark Url cache


+ (void)cacheWithKey:(NSString *)key withValue:(NSString *)value {
    [[ISMemoryCache sharedCache] setObject:value forKey:key];
}


+ (NSString *)checkAndAppendThumbnailWithChannelId:(NSString *)key {
    return [[ISMemoryCache sharedCache] objectForKey:key];
}


+ (NSString *)getYoutubeTypeTitle:(YTYouTubeType *)projectType {
    return [projectType.sqliteObjectName removeSubString:@"@"];
}
@end
