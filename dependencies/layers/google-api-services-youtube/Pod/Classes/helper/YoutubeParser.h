//
//  YoutubeParser.h
//  IOSTemplate
//
//  Created by djzhang on 11/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YoutubeConstants.h"


@interface YoutubeParser : NSObject

+ (NSString *)getVideoIdsByActivityList:searchResultList;
+ (NSString *)getVideoIdsBySearchResult:(NSMutableArray *)searchResultList;

+ (NSString *)checkAndAppendThumbnailWithChannelId:(NSString *)channelId;
+ (void)AppendThumbnailWithChannelId:(NSString *)channelId withThumbnailUrl:(NSString *)thumbnailUrl;
+ (NSString *)timeFormatConvertToSecondsWithInteger:(NSUInteger)timeSecs;
+ (NSString *)timeFormatConvertToSeconds:(NSString *)timeSecs;

+ (NSError *)getError:(NSData *)data httpresp:(NSHTTPURLResponse *)httpresp;

+ (NSString *)getChannelBrandingSettingsTitle:(YTYouTubeChannel *)channel;
+ (NSString *)getChannelStatisticsSubscriberCount:(YTYouTubeChannel *)channel;


+ (NSString *)getChannelTitle:(YTYouTubeChannel *)channel;
+ (NSString *)getPlayListTitle:(YTYouTubePlayList *)channel;
+ (NSString *)getPlayListThumbnailsGeneratedFromVideo:(YTYouTubePlayList *)video;
// Channel for other request
+ (NSString *)getChannelBannerImageUrl:(YTYouTubeChannel *)channel;
+ (NSArray *)getChannelBannerImageUrlArray:(YTYouTubeChannel *)channel;
+ (NSString *)getChannelSnippetId:(YTYouTubeChannel *)channel;
+ (NSString *)getChannelProjectFullPath:(YTYouTubeChannel *)channel;
+ (NSString *)getChannelSnippetTitle:(YTYouTubeChannel *)channel;
+ (NSString *)getChannelSnippetThumbnail:(YTYouTubeChannel *)channel;

// Video cache
+ (NSString *)getVideoSnippetThumbnails:(YTYouTubeVideoCache *)video;
//+ (NSString *)getWatchVideoId:(YTYouTubeVideoCache *)video;
+ (NSString *)getChannelIdByVideo:(YTYouTubeVideoCache *)video;
+ (NSString *)getVideoSnippetTitle:(YTYouTubeVideoCache *)video;
+ (NSString *)getVideoStatisticsViewCount:(YTYouTubeVideoCache *)video;
+ (NSString *)getVideoStatisticsLikeCount:(YTYouTubeVideoCache *)video;
+ (NSString *)getVideoDescription:(YTYouTubeVideoCache *)video;
+ (NSString *)getVideoSnippetChannelTitle:(YTYouTubeVideoCache *)video;
+ (NSString *)getVideoSnippetChannelPublishedAt:(YTYouTubeVideoCache *)video;
+ (NSString *)getVideoOnlineUrl:(YTYouTubeVideoCache *)fileInfo withNavigationIndex:(NSInteger)index;
+ (NSString *)getVideoThumbnailsGeneratedFromVideo:(YTYouTubeVideoCache *)fileInfo;
+ (void)parseDescriptionStringWithRegExp:(YTYouTubeVideoCache *)videoCache;

+ (void)cacheWithKey:(NSString *)key withValue:(NSString *)value;

+ (NSString *)getYoutubeTypeTitle:(id)type;
@end
