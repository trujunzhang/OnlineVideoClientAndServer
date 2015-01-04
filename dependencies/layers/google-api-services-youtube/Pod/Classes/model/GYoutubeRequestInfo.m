//
//  Search.m
//  IOSTemplate
//
//  Created by djzhang on 9/25/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "GYoutubeRequestInfo.h"


@interface GYoutubeRequestInfo () {

}
@property(nonatomic, copy) NSString * queryType;

@end


@implementation GYoutubeRequestInfo

#pragma mark - for search


- (instancetype)init {
   self = [super init];
   if (self) {
      self.hasLoadingMore = NO;
      self.hasFirstFetch = NO;
   }

   return self;
}


#pragma mark - 
#pragma mark 


- (void)baseReset {
   self.nextPageToken = @"";
   self.hasLoadingMore = YES;
   self.isLoading = NO;
   self.hasFirstFetch = YES;
}


// "AV2OkzIGykA"
- (void)resetRequestInfoForSuggestionList:(NSString *)videoId {
   self.itemType = YTSegmentItemList;

   self.queryType = [GYoutubeRequestInfo getQueryTypeArray][YTSegmentItemList];
   self.itemIdentify = [GYoutubeRequestInfo getIdentifyByItemType:self.itemType];

   [self baseReset];

   NSDictionary * parameters = @{
    @"part" : @"id,snippet",
    @"type" : @"video",
    @"relatedToVideoId" : videoId,
    @"fields" : @"items(id/videoId),nextPageToken",
   };
   self.parameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
}


- (void)resetRequestInfoForPlayList:(YTPlaylistItemsType)playlistItemsType {
   self.itemType = YTSegmentItemList;
   self.queryType = [GYoutubeRequestInfo getQueryTypeArray][YTSegmentItemList];
   self.itemIdentify = [GYoutubeRequestInfo getIdentifyByItemType:self.itemType];

   [self baseReset];

   self.playlistItemsType = playlistItemsType;
}


- (void)resetRequestInfoForActivityListFromChannelWithChannelId:(NSString *)channelId {
   self.queryType = [GYoutubeRequestInfo getQueryTypeArray][YTSegmentItemList];

   self.itemType = [self getItemType];
   self.itemIdentify = [GYoutubeRequestInfo getIdentifyByItemType:self.itemType];

   self.channelId = channelId;

   [self baseReset];
}


- (void)resetRequestInfoForVideoListFromChannel {
   self.queryType = [GYoutubeRequestInfo getSegmentTitlesArray][YTSegmentItemVideos];

   self.itemType = [self getItemType];
   self.itemIdentify = [GYoutubeRequestInfo getIdentifyByItemType:self.itemType];

   [self baseReset];
}


- (void)resetRequestInfoForPlayListFromChannelWithChannelId:(NSString *)channelId {
   self.queryType = [GYoutubeRequestInfo getSegmentTitlesArray][YTSegmentItemProgression];

   self.itemType = [self getItemType];
   self.itemIdentify = [GYoutubeRequestInfo getIdentifyByItemType:self.itemType];

   [self baseReset];
}


- (void)resetRequestInfoForSearchWithItemType:(YTSegmentItemType)itemType withQueryTeam:(NSString *)queryTeam {
   self.queryType = [GYoutubeRequestInfo getQueryTypeArray][itemType];

   self.itemType = [self getItemType];
   self.itemIdentify = [GYoutubeRequestInfo getIdentifyByItemType:self.itemType];

   [self baseReset];

   NSDictionary * parameters = @{
    @"q" : queryTeam,
    @"type" : self.queryType,
    @"part" : @"id,snippet",
    @"fields" : @"items(id/videoId),nextPageToken",
   };
   self.parameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
}


#pragma mark - 
#pragma mark 


- (void)putNextPageToken:(NSString *)pageToken {
   if (pageToken == nil || [pageToken isEqualToString:@""]) {
      self.hasLoadingMore = NO;
      return;
   }
   if ([self.nextPageToken isEqualToString:@""] == NO && [pageToken isEqualToString:self.nextPageToken]) {
      self.hasLoadingMore = NO;
   }
   if ([self.nextPageToken isEqualToString:@""]) { // First request
      self.nextPageToken = pageToken;
   }

   [self.parameters setObject:pageToken forKey:@"pageToken"];
}


#pragma mark -
#pragma mark


- (YTSegmentItemType)getItemType {
   int index = 0;
   NSArray * array = [GYoutubeRequestInfo getSegmentTitlesArray];
   for (int i = 0; i < array.count; ++i) {
      if ([self.queryType isEqualToString:array[i]]) {
         index = i;
         break;
      }
   }
   return [GYoutubeRequestInfo getItemTypeByIndex:index];
}


#pragma mark -
#pragma mark - next page


- (void)resetInfo {
   self.videoList = [[NSMutableArray alloc] init];
   self.hasLoadingMore = YES;
}


- (BOOL)hasNextPage {
   return self.hasLoadingMore;
}


- (void)appendNextPageData:(NSArray *)array {
//   NSLog(@"leng = %d", array.count);
   [self.videoList addObjectsFromArray:array];
}


#pragma mark  Constant


+ (NSArray *)getChannelPageSegmentTitlesArray {
   NSArray * array = [NSArray arrayWithObjects:
    @"List",
    @"Videos",
    @"Progression",
     nil];
   return array;
}


+ (NSArray *)getSegmentTitlesArray {
   NSArray * array = [NSArray arrayWithObjects:
    @"Videos",
    @"Channels",
    @"Playlists",
     nil];
   return array;
}


+ (NSArray *)getQueryTypeArray {
   NSArray * array = [NSArray arrayWithObjects:
    @"video",
    @"channel",
    @"playlist",
     nil];
   return array;
}


+ (NSString *)getIdentifyByItemType:(YTSegmentItemType)itemType {
   switch (itemType) {
      case YTSegmentItemList:
         return @"VideoIdentifier";
      case YTSegmentItemVideos:
         return @"ChannelIdentifier";
      case YTSegmentItemProgression:
         return @"PlaylistIdentifier";
   }
   return nil;
}


+ (YTSegmentItemType)getItemTypeByIndex:(int)index {
   switch (index) {
      case 0:
         return YTSegmentItemList;
      case 1:
         return YTSegmentItemVideos;
      case 2:
         return YTSegmentItemProgression;
   }
   return YTSegmentItemList;
}


@end
